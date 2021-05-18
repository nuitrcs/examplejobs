#!/bin/bash
#SBATCH --account=a9009  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=master  ### PARTITION (buyin, short, normal, etc)
#SBATCH --job-name=vasp-openmpi-slurm
#SBATCH --nodes=2
#SBATCH --tasks-per-node=4
#SBATCH --time=01:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --constraint="[quest5|quest6|quest8|quest9|quest10]"

module purge all
module load vasp/5.4.4-openmpi-4.0.5-intel-19.0.5.281
export SLURM_MPI_TYPE=pmix_v3

mpirun -np ${SLURM_NTASKS} vasp_std 
#srun -n ${SLURM_NTASKS} vasp_std
