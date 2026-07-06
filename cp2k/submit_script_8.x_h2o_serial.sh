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
# module load cp2k/8.1-openmpi-4.0.5-gcc-10.2.0
module load cp2k/8.2

## Run code 
export OMP_NUM_THREADS=1

## For cp2k/8.1-openmpi-4.0.5-gcc-10.2.0
# cp2k.psmp -i h2o.inp -o h2o_serial.out

## For cp2k/8.2
cp2k.ssmp -i h2o.inp -o h2o_serial.out

## Adapted from: https://manual.cp2k.org/trunk/getting-started/first-calculation.html
