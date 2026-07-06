#!/bin/bash
#SBATCH --account=<ACCOUNT>
#SBATCH --partition=<PARTITION>
#SBATCH --time=00:30:00    
#SBATCH --nodes=2   
#SBATCH --ntasks-per-node=1
#SBATCH --mem=2G  
#SBATCH --job-name=cp2k_lalanine_test_parallel
#SBATCH --output=cp2k_lalanine_test_parallel-%j.out

## Load cp2k
module purge
module load cp2k/8.1-openmpi-4.0.5-gcc-10.2.0

## Run code 

export OMP_NUM_THREADS=1
INPUT_FILE=./Lalanine.inp
OUTPUT_FILE=./Lalanine_parallel.out

mpirun -np $SLURM_NPROCS -x PMIX_MCA_psec=^munge cp2k.psmp -i $INPUT_FILE -o $OUTPUT_FILE


## Adapted from: https://www.cp2k.org/exercises:2025_cp2k_crystallography:ex1 

