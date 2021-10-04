#!/bin/bash
#SBATCH --account=w10001  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=w10001  ### PARTITION (buyin, short, normal, w10001, etc)
#SBATCH --array=0-9 ## number of jobs to run "in parallel" 
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=1 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:10:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name="sample_job_\${SLURM_ARRAY_TASK_ID}" ## use the task id in the name of the job
#SBATCH --output=sample_job.%A_%a.out ## use the jobid (A) and the specific job index (a) to name your log file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=email@u.northwestern.edu  ## your email

module purge all
module load python-anaconda3
source activate /projects/intro/envs/slurm-py37-test

# read in each row of the input_arguments text file into an array called input_args
IFS=$'\n' read -d '' -r -a input_arguments < input_arguments.txt

# Use the SLURM_ARRAY_TASK_ID varaible to select the correct index from input_arguments and then split the string by whatever delimiter you chose (in our case each input argument is split by a space)
IFS=' ' read -r -a input_args <<< "${input_arguments[$SLURM_ARRAY_TASK_ID]}"

# Pass the input arguments associated with this SLURM_ARRAY_TASK_ID to your function.
python slurm_test.py --input-argument-1 ${input_args[0]} --input-argument-2 ${input_args[1]} --input-argument-3 ${input_args[2]} 
