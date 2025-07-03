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
## NOTE: I only loaded this CUDA module to test how julia 
## would behave using a system-installed CUDA rather than its
## own installation. julia does not recommend using a system-
## installed CUDA. 
## More information here: 
## https://cuda.juliagpu.org/stable/installation/overview/#CUDA-toolkit
##module load cuda/12.2.2-gcc-10.4.0
module load julia/1.11.4

julia <path_to_script>/julia_gpu_de_example.jl

