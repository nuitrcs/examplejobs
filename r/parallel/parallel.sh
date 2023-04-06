#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition=<queueName>
#SBATCH --time=<hh:mm:ss>
#SBATCH --mail-user=<emailAddress>
#SBATCH --output=<combined out and err file path>
#SBATCH --job-name <jobName>
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12G  # Total memory in GB needed for a job. Also see --mem-per-cpu

# unload modules that may have been loaded when job was submitted
module purge all

module load R/3.3.2

# set environment variable for R for parallelization;
# MC_CORES should be 1 less that cores requested above (which is 4),
# the value of $SLURM_NPROCS is set to the same value as --ntasks-per-node above
# since it is additional processes on top of the main one
export MC_CORES=$(($SLURM_NPROCS-1))

Rscript parallel.R 

# submit this script with sbatch from the command line:
# sbatch parallel.sh
