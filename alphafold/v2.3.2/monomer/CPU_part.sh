#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=normal  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=12 ## how many cpus or processors do you need on each computer
#SBATCH --time=48:00:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem=85G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=run_AlphaFold  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=AlphaFoldCPUPart.log ## standard out and standard error goes to this file

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
module load alphafold/2.3.2-with-msas-only-and-config-yaml

# real example monomer
alphafold-monomer --fasta_paths=/projects/intro/alphafold/T1050.fasta \
    --max_template_date=2022-01-01 \
    --model_preset=monomer \
    --db_preset=full_dbs \
    --only_msas=true \
    --use_gpu_relax=False \
    --output_dir=$(pwd)/out
