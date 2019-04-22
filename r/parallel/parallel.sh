#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition=<queueName>
#SBATCH --time=<hh:mm:ss>
#SBATCH --mail-user=<emailAddress>
#SBATCH --output=<combined out and err file path>
#SBATCH -J <jobName>
#SBATCH --nodes=1
#SBATCH -n 4

# unload modules that may have been loaded when job was submitted
module purge all

module load R/3.3.2

# set environment variable for R for parallelization;
# MC_CORES should be 1 less that cores requested above (which is 4), 
# since it is additional processes on top of the main one
export MC_CORES=3

Rscript parallel.R 

# submit this script with sbatch from the command line:
# sbatch parallel.sh