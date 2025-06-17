#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=12 ## how many cpus or processors do you need on each computer
#SBATCH --time=04:00:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem=85G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=run_AlphaFold  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=AlphaFold-CPU.log ## standard out and standard error goes to this file
#SBATCH --gres=gpu:1 ## GPU resources for Alphafold simulations

#########################################################################
### PLEASE NOTE:                                                      ###
### The above CPU and Memory resources have been selected based       ###
### on the computing resources that alphafold was tested on           ###
### which can be found here:                                          ###
### https://github.com/deepmind/alphafold#running-alphafold)          ###
### It is likely that you do not have to change anything above        ###
### besides your allocation, and email (if you want to be emailed).   ###
#########################################################################

module purge
module load alphafold/3.0.0

# To run alphafold more efficiently,
# we split the CPU and GPU parts of the pipeline into two separate submissions.
# Below we provide a way to run the GPU part of alpahfold3
# Be sure to update the model_dir path to point to where the parameters are stored for your instance.

af3_gpu --model_dir=/path/to/model/parameters \
    --output_dir=$(pwd)/output/ \
    --json_path=$(pwd)/output/2pv7/2pv7_data.json
