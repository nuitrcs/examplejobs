#!/bin/bash
#SBATCH --account=a9009  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=a9009  ### PARTITION (buyin, short, normal, a9009, etc)
#SBATCH --array=0-9 ## number of jobs to run "in parallel" 
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=1 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:10:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name="sample_job_\${SLURM_ARRAY_TASK_ID}" ## use the task id in the name of the job
#SBATCH --output=sample_job.%A_%a.out ## use the jobid (A) and the specific job index (a) to name your log file
#SBATCH --constraint=quest10

module purge all
module load python-anaconda3
source activate /projects/intro/envs/slurm-py37-test

# read in each row of the input_arguments text file into an array called input_args
IFS=$'\n' read -d '' -r -a input_arguments < input_arguments.txt

# Use the SLURM_ARRAY_TASK_ID varaible to select the correct index from input_arguments and then split the string by whatever delimiter you chose (in our case each input argument is split by a space)
IFS=' ' read -r -a input_args <<< "${input_arguments[$SLURM_ARRAY_TASK_ID]}"

# based on the values of input_args, the job itself creates the folder and then changes into this folder to actually run the command
mkdir -p ${input_args[0]}/${input_args[1]}/${input_args[2]}

# change directory
cd ${input_args[0]}/${input_args[1]}/${input_args[2]}

# Pass the input arguments associated with this SLURM_ARRAY_TASK_ID to your function.
python /home/quest_demo/workshop/Scheduler-Job-Array-and-Dependent-Jobs/slurm_examples/python/job-array-huge/slurm_test.py --input-argument-1 ${input_args[0]} --input-argument-2 ${input_args[1]} --input-argument-3 ${input_args[2]}

# At the end of the run, we want the outlog which is currently in the directory where
mv $SLURM_SUBMIT_DIR/sample_job.$SLURM_ARRAY_JOB_ID"_"$SLURM_ARRAY_TASK_ID.out .
