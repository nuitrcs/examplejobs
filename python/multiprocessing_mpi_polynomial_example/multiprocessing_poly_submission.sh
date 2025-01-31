#!/bin/bash

#SBATCH --account=<YOUR_ALLOCATION_ID>
#SBATCH --partition=<PARTITION> ## short, normal, long,...
#SBATCH --nodes=1 ## number of nodes will always be 1 for single-node, multi-core parallel
#SBATCH --time=00:20:00 ## Maximum job walltime 
#SBATCH --mem=18G ## this is memory (RAM) per node, not mem per core
#SBATCH --job-name=multiprocessing_python ## Job name 
#SBATCH --output=<PATH_TO_OUTPUT_FILE>
#SBATCH --error=<PATH_TO_ERROR_FILE>

## NOTE: number of cores will be specified in the command line 

## echo some stuff and usage information
echo "NOTE: to submit this job as intended, you should have ran:"
echo "sbatch --ntasks-per-node=<NUM> parallel_submission.sh"
echo "to submit this job with a specific number of tasks per node."
echo "Otherwise it will default to 1."
echo " "
echo "SLURM Job ID: $SLURM_JOB_ID"
echo "Node List: $SLURM_JOB_NODELIST"
echo "Tasks per node: $SLURM_NTASKS_PER_NODE"

## activate my virtual environment with my python packages
module purge
module load mamba/24.3.0
eval "$(conda shell.bash hook)"
conda activate <YOUR_VIRTUAL_ENVIRONMENT>

SCRIPT_DIR=<PATH_TO_WHERE_PYTHON_SCRIPT_IS>

## run my script
python $SCRIPT_DIR/run_poly_analysis_parallel.py
