#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=gengpu
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=1 ## how many cpus or processors do you need on each computer
#SBATCH --gres=gpu:a100:1  ## type of GPU requested, and number of GPU cards to run on
#SBATCH --time=04:00:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem=85G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=run_AlphaFold  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=AlphaFold-GPU.log ## standard out and standard error goes to this file

#########################################################################
### PLEASE NOTE:                                                      ###
### The above CPU, Memory, and GPU resources have been selected based ###
### on the computing resources that alphafold was tested on           ###
### which can be found here:                                          ###
### https://github.com/deepmind/alphafold#running-alphafold)          ###
### It is likely that you do not have to change anything above        ###
### besides your allocation, and email (if you want to be emailed).   ###
#########################################################################

module purge
module load alphafold/2.1.1-only-msas-flag-addition

# To run alphafold more efficiently,
# we split the CPU and GPU parts of the pipeline into two separate submissions.
# Below we provide a way to run the GPU part of alpahfold-multimer and alphafold-monomer
# which will depend on the CPU part finishing before it runs

# real example monomer (takes about 3 hours and 15 minutes)
alphafold-monomer --fasta_paths=/projects/intro/alphafold/T1050.fasta \
    --max_template_date=2020-05-14 \
    --model_preset=monomer \
    --db_preset=full_dbs \
    --use_precomputed_msas=true \
    --output_dir=$(pwd)/out

# real example multimer (takes about 2 hours and 40 minutes)
alphafold-multimer --fasta_paths=/projects/intro/alphafold/6E3K.fasta \
    --max_template_date=2020-05-14 \
    --model_preset=multimer \
    --db_preset=full_dbs  \
    --use_precomputed_msas=true \
    --output_dir=$(pwd)/out
