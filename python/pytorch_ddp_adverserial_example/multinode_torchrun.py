import torch
from torch import nn
from torch import optim
import torch.nn.functional as F
from torch.utils.data import Dataset, DataLoader
from datautils import MyTrainDataset

import torch.multiprocessing as mp
from torch.utils.data.distributed import DistributedSampler
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.distributed import init_process_group, destroy_process_group
import os

def weights_init(m):
    classname = m.__class__.__name__
    if classname.find('Conv') != -1:
        m.weight.data.normal_(0.0, 0.02)
    elif classname.find('BatchNorm') != -1:
        m.weight.data.normal_(1.0, 0.02)
        m.bias.data.fill_(0)
    
class Generator(nn.Module):
    def __init__(self, nz=128, channels=3):
        super(Generator, self).__init__()
        self.nz = nz
        self.channels = channels
        def convlayer(n_input, n_output, k_size=4, stride=2, padding=0):
            block = [
                nn.ConvTranspose2d(n_input, n_output, kernel_size=k_size, stride=stride, padding=padding, bias=False),
                nn.BatchNorm2d(n_output),
                nn.ReLU(inplace=True),
            ]
            return block
        self.model = nn.Sequential(
            *convlayer(self.nz, 1024, 4, 1, 0),
            *convlayer(1024, 512, 4, 2, 1),
            *convlayer(512, 256, 4, 2, 1),
            *convlayer(256, 128, 4, 2, 1),
            *convlayer(128, 64, 4, 2, 1),
            nn.ConvTranspose2d(64, self.channels, 3, 1, 1),
            nn.Tanh()
        )
    def forward(self, z):
        z = z.view(-1, self.nz, 1, 1)
        img = self.model(z)
        return img

class Discriminator(nn.Module):
    def __init__(self, channels=3):
        super(Discriminator, self).__init__()
        self.channels = channels
        def convlayer(n_input, n_output, k_size=4, stride=2, padding=0, bn=False):
            block = [nn.Conv2d(n_input, n_output, kernel_size=k_size, stride=stride, padding=padding, bias=False)]
            if bn:
                block.append(nn.BatchNorm2d(n_output))
            block.append(nn.LeakyReLU(0.2, inplace=True))
            return block
        self.model = nn.Sequential(
            *convlayer(self.channels, 32, 4, 2, 1),
            *convlayer(32, 64, 4, 2, 1),
            *convlayer(64, 128, 4, 2, 1, bn=True),
            *convlayer(128, 256, 4, 2, 1, bn=True),
            nn.Conv2d(256, 1, 4, 1, 0, bias=False))
    def forward(self, imgs):
        logits = self.model(imgs)
        out = torch.sigmoid(logits)
        return out.view(-1, 1)
    

def ddp_setup():
    init_process_group(backend="gloo")
    torch.cuda.set_device(int(os.environ["LOCAL_RANK"]))

class Trainer:
    def __init__(
        self,
        netG: torch.nn.Module,
        netD: torch.nn.Module,
        optimizerG: torch.optim.Optimizer,
        optimizerD: torch.optim.Optimizer,
        train_data: DataLoader,
        save_every: int,
        snapshot_path: str,
    ) -> None:
        self.local_rank = int(os.environ["LOCAL_RANK"])
        self.global_rank = int(os.environ["RANK"])
        self.netG = netG.to(self.local_rank)
        self.netD = netD.to(self.local_rank)
        self.train_data = train_data
        self.optimizerG = optimizerG
        self.optimizerD = optimizerD
        self.save_every = save_every
        self.epochs_run = 0
        self.snapshot_path = snapshot_path
        if os.path.exists(snapshot_path):
            print("Loading snapshot")
            self._load_snapshot(snapshot_path)

        self.netG = DDP(self.netG, device_ids=[self.local_rank])
        self.netD = DDP(self.netD, device_ids=[self.local_rank])

    def _load_snapshot(self, snapshot_path):
        loc = f"cuda:{self.local_rank}"
        snapshot = torch.load(snapshot_path, map_location=loc)
        self.netG.load_state_dict(snapshot["GENERATOR_STATE"])
        self.netD.load_state_dict(snapshot["DISCRIMINATOR_STATE"])
        self.epochs_run = snapshot["EPOCHS_RUN"]
        print(f"Resuming training from snapshot at Epoch {self.epochs_run}")

    def _run_epoch(self, epoch):
        b_sz = len(next(iter(self.train_data))[0])
        print(f"[GPU{self.global_rank}] Epoch {epoch} | Batchsize: {b_sz} | Steps: {len(self.train_data)}")
        self.train_data.sampler.set_epoch(epoch)

        real_label = 0.5
        fake_label = 0

        for real_images, train_labels in self.train_data:

            ### Update Discriminator network
            # train with real
            self.netD.zero_grad()
            real_images = real_images.to(self.local_rank)
            batch_size = real_images.size(0)
            labels = torch.full((batch_size, 1), real_label, device=self.local_rank)
            output = self.netD(real_images)
            errD_real = nn.BCELoss(output, labels)
            errD_real.backward()
            D_x = output.mean().item()

            # train with fake
            noise = torch.randn(batch_size, self.netG.nz, 1, 1, device=self.local_rank)
            fake = self.netG(noise)
            labels.fill_(fake_label)
            output = self.netD(fake.detach())
            errD_fake = nn.BCELoss(output, labels)
            errD_fake.backward()
            D_G_z1 = output.mean().item()
            errD = errD_real + errD_fake
            self.optimizerD.step()

            ### Update Generator network
            self.netG.zero_grad()
            labels.fill_(real_label)  # fake labels are real for generator cost
            output = self.netD(fake)
            errG = criterion(output, labels)
            errG.backward()
            D_G_z2 = output.mean().item()

            self.optimizerG.step()

    def _save_snapshot(self, epoch):
        snapshot = {
            "GENERATOR_STATE": self.netG.module.state_dict(),
            "DISCRIMINATOR_STATE": self.netD.module.state_dict(),
            "EPOCHS_RUN": epoch,
        }
        torch.save(snapshot, self.snapshot_path)
        print(f"Epoch {epoch} | Training snapshot saved at {self.snapshot_path}")

    def train(self, max_epochs: int):
        for epoch in range(self.epochs_run, max_epochs):
            self._run_epoch(epoch)
            if self.local_rank == 0 and epoch % self.save_every == 0:
                self._save_snapshot(epoch)


def main(save_every: int, total_epochs: int, batch_size: int, snapshot_path: str = "snapshot.pt"):
    ddp_setup()

    # Initiaze Generator
    netG = Generator()
    # Initiaze Discriminator
    netD = Discriminator()
    
    LR_G = 0.001
    LR_D = 0.001

    beta1 = 0.5

    optimizerD = optim.Adam(netD.parameters(), lr=LR_D, betas=(beta1, 0.999))
    optimizerG = optim.Adam(netG.parameters(), lr=LR_G, betas=(beta1, 0.999))


    dataset = MyTrainDataset(100)

    train_data = DataLoader(
        dataset,
        batch_size=24,
        pin_memory=True,
        shuffle=False,
        sampler=DistributedSampler(dataset)
    )

    trainer = Trainer(netG, netD, optimizerG, optimizerD, train_data, save_every, snapshot_path)
    trainer.train(total_epochs)
    destroy_process_group()


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='simple distributed training job')
    parser.add_argument('total_epochs', type=int, help='Total epochs to train the model')
    parser.add_argument('save_every', type=int, help='How often to save a snapshot')
    parser.add_argument('--batch_size', default=32, type=int, help='Input batch size on each device (default: 32)')
    args = parser.parse_args()
    
    main(args.save_every, args.total_epochs, args.batch_size)
