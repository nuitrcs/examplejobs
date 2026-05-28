#!/bin/bash 
#SBATCH --account=<YOUR ACOUNT>
#SBATCH --partition=short
#SBATCH --time=02:00:00    
#SBATCH --array=0-7
#SBATCH --nodes=1  
#SBATCH --mem=5G         
#SBATCH --output=scaling_study_pi_job-%A-%a.out 
#SBATCH --constraint=quest12

## provide a path to --output if you'd like the terminal output 
## from the job to go somewhere other than the working directory

## constraining the jobs to a particular generation of nodes can 
## help ensure consistent results for a scaling study. 

## Note: --ntasks-per-node and --job-name are not specified here because 
## they will be specified in the command line (or a bash script) when we 
## actually submit the jobs. 

# initialize virtual environment 
module purge
module load mamba/24.3.0
eval "$('/hpc/software/mamba/24.3.0/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
source "/hpc/software/mamba/24.3.0/etc/profile.d/mamba.sh"

mamba activate parallel_python_env

## if you gave the environment a different name or prefix, adjust that above

echo "running on $SLURM_NTASKS_PER_NODE CPU cores"

## where you want the output to go (create directory if it doesn't exist)
## change this if you want to  
OUTPUT_DIR=./output
mkdir -p $OUTPUT_DIR

python py_test_multiprocessing.py $SLURM_ARRAY_TASK_ID $OUTPUT_DIR


