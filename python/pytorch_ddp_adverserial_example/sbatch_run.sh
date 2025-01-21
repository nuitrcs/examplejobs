#!/bin/bash
#SBATCH --account=p30157
#SBATCH --partition=gengpu
#SBATCH --time=04:00:00
#SBATCH --job-name=multinode-example
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --gres=gpu:h100:2
#SBATCH --mem=20G
#SBATCH --constraint=rhel8
#SBATCH --cpus-per-task=4

module purge
module load mamba/24.3.0
eval "$(conda shell.bash hook)"
conda activate /projects/a9009/sbc538/documentation/108515/pytorch/torch_with_cuda_12_4/

export LOGLEVEL=INFO
export export NCCL_P2P_LEVEL=NVL

srun torchrun \
    --nnodes $SLURM_NNODES \
    --nproc_per_node $SLURM_NTASKS_PER_NODE \
    --rdzv_id $RANDOM \
    --rdzv_backend c10d \
    --rdzv_endpoint "$SLURMD_NODENAME:29500" \
    ./multinode_torchrun.py 10000 100
