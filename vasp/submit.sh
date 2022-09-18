#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --job-name=vasp-openmpi-slurm
#SBATCH --nodes=2
#SBATCH --tasks-per-node=4
#SBATCH --time=01:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --constraint="[quest8|quest9|quest10]"

module purge all
module load vasp/5.4.4-openmpi-4.0.5-intel-19.0.5.281

mpirun -np ${SLURM_NTASKS} vasp_std 
#srun -n ${SLURM_NTASKS} vasp_std
