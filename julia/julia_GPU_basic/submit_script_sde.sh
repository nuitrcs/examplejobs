#!/bin/bash
#SBATCH --account=<allocation_id>
#SBATCH --partition=gengpu
#SBATCH --time=00:40:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10G
#SBATCH --gres=gpu:1
#SBATCH --job-name=julia_de_gpu_test
#SBATCH --output=<path_to_logs>/julia-%j.log

module purge
module load julia/1.11.4

## DiffEqGPU Package comes with its own test scripts in installation directory 
## (exact directory may vary based on particular build)
julia ~/.julia/packages/DiffEqGPU/0Jmg9/test/ensemblegpuarray_sde.jl

