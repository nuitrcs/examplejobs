## Steps for running these example jobs on Quest 
## Note: replace expressions in <angle_brackets> with your 
## particular values. 
## Last updated July 2025

## SOFTWARE SETUP 
# Note: this will install julia packages in a default location 
# ~/.julia/packages 
# and default 'environment' (version number may vary)
# ~/.julia/environments/v1.11/Project.toml
# julia handles environments differently from utilities like 
# conda/mamba. For more information or to customize your package 
# environments, see:
# https://pkgdocs.julialang.org/v1/environments/#Working-with-Environments

# Start an interactive session on a GPU node on Quest. This is
# necessary for julia's CUDA package to build/function properly. 
salloc --account=<allo_id> --partition=gengpu -N 1 -n 1 --mem=16G --time=02:00:00 --gres=gpu:1

# SSH to the node running your job (will be reported by SLURM after
# executing salloc command)
ssh <hostname>

# Load the julia/1.11.4 module on Quest:
module load julia/1.11.4

# Launch julia 
julia 

# Install necessary packages (in julia prompt)
using Pkg
Pkg.add(["CUDA", "DiffEqGPU", "OrdinaryDiffEq", "LinearAlgebra", "StaticArrays", "GPUArraysCore", "StochasticDiffEq"])

# Check installation (still in julia prompt). 
# Note: by default, julia will detect the driver version on the GPU
# card and install the latest available CUDA toolkit libraries.
# This could cause less-than-ideal behavior on Quest, but julia's 
# documentation recommends against using system-level installs of 
# CUDA libraries (such as those in Quest's module system). More 
# information is available here:
# https://cuda.juliagpu.org/stable/installation/overview/#CUDA-toolkit
Pkg.status()
using CUDA
CUDA.versioninfo()
exit()

# After exiting julia prompt, run a quick julia script to verify
# that the CUDA package behaves as expected (still in your interactive
# GPU session)
# This should print out some information about the GPU node running 
# your job. 
julia julia_gpu_minimal.jl 

# Exit and cancel the GPU interactive job
exit
scancel <job_id>

## RUNNING THE EXAMPLE JOBS 
# First, edit the submission scripts 
# submit_script.sh 
# and 
# submit_script_sde.sh
# to include your Quest allocation and directory paths 

# Note that submit_script.sh runs the script julia_gpu_de_examle.jl
# Whereas submit_script_sde.sh runs an example that comes with the
# installation of the DiffEqGPU package. The script gets written 
# to a subdirectory of ~/.julia/

# Then, submit the jobs with the sbatch command 
sbatch submit_script.sh 
sbatch submit_script_sde.sh 

# After the jobs finish running, check that they had nonzero 
# GPU utilzaiton and GPU memory usage. Run the following
# sacct command and examine the .batch job step. The jobs will 
# probably utilize < 20% of GPU compute and < 1GiB of GPU memory. 
# This is fine, but the compute/memory utilization should not be 0. 
# If it is 0, something may have gone wrong. 
sacct -u <your_NetID> --format=jobid,nodelist,state,tresusagein%100



