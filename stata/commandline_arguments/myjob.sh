#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition=<queueName>
#SBATCH --time=<hhh:mm:ss> 
#SBATCH --mail-user=<emailAddress>
#SBATCH --output=<combined out and err file path>
#SBATCH -J <jobName>
#SBATCH --nodes=1
#SBATCH -n 4 # Stata-MP has a 4 core license.
#SBATCH --mem=12G  # Total memory in GB needed for a job. Also see --mem-per-cpu

# unload modules that may have been loaded when job was submitted
module purge all

module load stata

# By default all file paths are relative to the directory where you submitted the job.
# To change to another path, use `cd <path>`, for example:
# cd /projects/<allocationID>

# mycode.do is your Stata script.  If it's not in the working directory set above, add 
# the full or relative path as appropriate
stata-mp -b do mycode $ARG1 $ARG2 $ARG3
# Stata output will be in mycode.log in the working directory.

# There will also be a job output file called <jobname>.o<jobID> 
# in the directory from which you submit the job with information from the scheduler

# From the command line, in the directory with this file, submit this job with:
# sbatch -V ARG1=3,ARG2=hello,ARG3=4.5 myjob.sh
