#!/bin/sh
#SBATCH -A <allocation>               # Allocation
#SBATCH -p gengpu                # Queue
#SBATCH -t 01:00:00             # Walltime/duration of the job
#SBATCH -N 1                    # Number of Nodes
#SBATCH --mem=10G               # You do not need a lot of CPU mem 
#SBATCH --gres=gpu:h100:1.      # You can also request an a100 if preferred.
#SBATCH --ntasks-per-node=4     # Number of Cores (Processors)

module purge
module load mamba/24.3.0

# Hook the virtual environment to the job
eval "$('/hpc/software/mamba/24.3.0/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
source "/hpc/software/mamba/24.3.0/etc/profile.d/mamba.sh"
mamba activate /path/to/envs/huggingface-env

python -u /path/to/python/script/that/has/model-pulling/huggingface-script.py
