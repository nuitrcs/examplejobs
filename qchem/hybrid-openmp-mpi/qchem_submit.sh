#!/bin/bash
#SBATCH -A pXXXX
#SBATCH -p short
#SBATCH --time=00:10:00
#SBATCH --mem-per-cpu=3G
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=4 ## how many MPI tasks are running on each computer
#SBATCH --cpus-per-task 4 ## howmany cpus does each MPI task needs to have access to
#SBATCH --job-name="DFT_benzene"
#SBATCH --output=errors.out

module purge all
module load qchem/5.3

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

qchem -mpi -nt ${SLURM_CPUS_PER_TASK} -np ${SLURM_NTASKS} DFT_benzene.in results.out
