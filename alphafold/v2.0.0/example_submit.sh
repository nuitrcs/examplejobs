#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=gengpu  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need - for AlphaFold this should always be one
#SBATCH --ntasks-per-node=12 ## how many cpus or processors do you need on each computer
#SBATCH --gres=gpu:a100:1  ## type of GPU requested, and number of GPU cards to run on
#SBATCH --time=48:00:00 ## how long does this need to run 
#SBATCH --mem=85G ## how much RAM do you need per node (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=run_AlphaFold  ## When you run squeue -u <NETID> this is how you can identify the job
#SBATCH --output=AlphaFold.log ## standard out and standard error goes to this file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=email@northwestern.edu ## your email, non-Northwestern email addresses may not be supported

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
module load alphafold/2.0.0

# template
# alphafold --fasta_paths=/full/path/to/fasta \
#    --output_dir=/full/path/to/outdir \
#    --model_names= \
#    --preset=[full_dbs|casp14] \
#    --max_template_date=

# real example
alphafold --output_dir $HOME/alphafold --fasta_paths=/projects/intro/alphafold/T1050.fasta --max_template_date=2021-07-28 --model_names model_1,model_2,model_3,model_4,model_5 --preset casp14
