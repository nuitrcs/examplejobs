#!/bin/bash
#SBATCH --account=<ACCOUNT>
#SBATCH --partition=<PARTITION>
#SBATCH --time=00:30:00    
#SBATCH --nodes=1   
#SBATCH --ntasks-per-node=1 
#SBATCH --mem=5G  
#SBATCH --job-name=cp2k_h2o_test_serial
#SBATCH --output=cp2k_h2o_test_serial-%j.out

## Load cp2k
module purge
module load cp2k/2025.2

## Run code 
export OMP_NUM_THREADS=1
cp2k -i h2o.inp -o h2o_serial.out

## Adapted from: https://manual.cp2k.org/trunk/getting-started/first-calculation.html
