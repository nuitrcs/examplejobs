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
module load mpi/openmpi-4.1.7-gcc-12.4.0
module load singularityce 

## Run code 

export OMP_NUM_THREADS=1
INPUT_FILE=./Lalanine.inp
OUTPUT_FILE=./Lalanine_parallel.out

mpirun -np $SLURM_NPROCS -x PMIX_MCA_psec=^munge singularity exec -B /projects:/projects /software/2025/cp2k/cp2k_2025.2_openmpi_x86_64_psmp.sif /opt/cp2k/bin/cp2k.psmp -i $INPUT_FILE -o $OUTPUT_FILE


## Adapted from: https://www.cp2k.org/exercises:2025_cp2k_crystallography:ex1 

