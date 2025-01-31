#!/bin/bash

#SBATCH --account=<YOUR_ALLOCATION_ID>
#SBATCH --partition=<PARTITION> ## short, normal, long,...
#SBATCH --nodes=2 ## Number of nodes
#SBATCH --ntasks-per-node=3 ## Number of cores per node
#SBATCH --time=00:20:00 ## Maximum job walltime 
#SBATCH --mem=8G ## Memory (RAM) per node
#SBATCH --job-name=mpi_python ## Job name 
#SBATCH --output=<PATH_TO_OUTPUT_FILE>
#SBATCH --error=<PATH_TO_ERROR_FILE>

## activate my virtual environment with mpi configured properly for Quest
module purge
module load mamba/24.3.0
eval "$(conda shell.bash hook)"
conda activate <YOUR_VIRTUAL_ENVIRONMENT>

## check job submission parameters and mpi configuration
echo "SLURM Job ID: $SLURM_JOB_ID"
echo "Node List: $SLURM_JOB_NODELIST"
echo "Tasks per node: $SLURM_NTASKS_PER_NODE"
echo "NTasks: $SLURM_NTASKS"
echo " "
echo "Environmental variables:"
printenv | grep -i ucx
echo " "
echo "which mpiexec"
which mpiexec 

SCRIPT_DIR=<PATH_TO_WHERE_PYTHON_SCRIPT_IS>

mpiexec -n ${SLURM_NTASKS} python $SCRIPT_DIR/run_poly_analysis_mpi.py

