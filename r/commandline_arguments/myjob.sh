#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition=<queueName>
#SBATCH --time=<hh:mm:ss>
#SBATCH --mail-user=<emailAddress>
#SBATCH --output=<combined out and err file path>
#SBATCH -J <jobName>
#SBATCH --nodes=1
#SBATCH -n <core count>
#SBATCH --mem=<total memory in MB>

# unload modules that may have been loaded when job was submitted
module purge all

# load module with version you want
module load R/3.3.2

# By default all file paths are relative to the directory where you submitted the job.
# To change to another path, use `cd <path>`, for example:
# cd /projects/<allocationID>

# Command line args (myoutputfile and 14) are hard-coded here.
Rscript commandlineargs.R myoutputfile 14

# submit this file with sbatch
# sbatch myjob.sh