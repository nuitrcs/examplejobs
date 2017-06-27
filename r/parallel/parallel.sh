#!/bin/bash
#MSUB -A <allocationID>
#MSUB -q <queueName>
#MSUB -l walltime=<hh:mm:ss>
#MSUB -M <emailAddress>
#MSUB -j oe
#MSUB -N <jobName>
#MSUB -l nodes=1:ppn=4

module load R/3.3.2

# set environment variable for R for parallelization;
# MC_CORES should be 1 less that cores requested above (which is 4), 
# since it is additional processes on top of the main one
export MC_CORES=3

# Set your working directory
cd $PBS_O_WORKDIR

Rscript parallel.R 

# submit this script with msub from the command line:
# msub parallel.sh