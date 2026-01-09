#!/bin/sh
#SBATCH -A <allocation>         # Allocation
#SBATCH -p gengpu               # Queue
#SBATCH -t 01:00:00             # Walltime/duration of the job
#SBATCH -N 1                    # Number of Nodes
#SBATCH --mem=30G               # Memory per node in GB needed for a job. Also see --mem-per-cpu
#SBATCH --gres=gpu:h100:1       # use gpu:1 if you don't have a preference for A100 or H100 GPU
#SBATCH --ntasks-per-node=4     # Number of Cores (Processors)

module purge
module load mamba/24.3.0

eval "$('/hpc/software/mamba/24.3.0/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
source "/hpc/software/mamba/24.3.0/etc/profile.d/mamba.sh"
mamba activate /path/to/envs/huggingface-env

python -u /path/to/python/script/that/has/model-pulling/fine_tuning.py
