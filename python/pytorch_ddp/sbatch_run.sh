#!/bin/bash
#SBATCH --account=pXXXXX
#SBATCH --partition=gengpu
#SBATCH --time=04:00:00
#SBATCH --job-name=multinode-example
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=20G
#SBATCH --cpus-per-task=4

module purge
module load mamba/23.1.0
source activate <some-env>

export LOGLEVEL=INFO

srun torchrun \
    --nnodes $SLURM_NNODES \
    --nproc_per_node $SLURM_NTASKS_PER_NODE \
    --rdzv_id $RANDOM \
    --rdzv_backend c10d \
    --rdzv_endpoint "$SLURMD_NODENAME:29500" \
    ./multinode_torchrun.py 10000 100
