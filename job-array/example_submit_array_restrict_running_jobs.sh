#!/bin/bash
#SBATCH --account=w10001  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=w10001  ### PARTITION (buyin, short, normal, w10001, etc)
#SBATCH --array=0-9%1 ## left of percentage sign, number of jobs to run "in parallel" but, right of percentage sign, limiting how many jobs can be running at a given time to only 1.
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=1 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:10:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name="sample_job_\${SLURM_ARRAY_TASK_ID}" ## use the task id in the name of the job
#SBATCH --output=sample_job.%A_%a.out ## use the jobid (A) and the specific job index (a) to name your log file

module purge all
module load python-anaconda3
source activate /projects/intro/envs/slurm-py37-test

IFS=$'\n' read -d '' -r -a lines < list_of_files.txt

python slurm_test.py --job-id $SLURM_ARRAY_TASK_ID --filename ${lines[$SLURM_ARRAY_TASK_ID]}
