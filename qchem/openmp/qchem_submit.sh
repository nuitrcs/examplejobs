#!/bin/bash
#SBATCH -A pXXXX
#SBATCH -p short
#SBATCH --time=00:10:00
#SBATCH --mem-per-cpu=3G
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH -n 4 ## how many CPUs 
#SBATCH --job-name="ECP_AgCl"
#SBATCH --output=errors.out

module purge all
module load qchem/5.3

export OMP_NUM_THREADS=${SLURM_NTASKS}

qchem -nt ${SLURM_NTASKS} ECP_AgCl.in results.out
