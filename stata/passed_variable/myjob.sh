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

# The .do filename (with the path as necessary) is being passed in as an 
# environmental variable from the call to sbatch.  
stata-mp -b do ${DOFILENAME} 
# Stata output will be in mycode.log in the working directory.
# mycode.do example file also writes some additional output files.

# There will also be a job output file called <jobname>.o<jobID> 
# in the directory from which you submit the job with information from the scheduler

# From the command line, in the directory with this file, you could then 
# submit multiple jobs for different files (mycode1.do, mycode2.do).  Examples:
# sbatch -v DOFILENAME=mycode1 myjob.sh
# sbatch -v DOFILENAME=mycode2 myjob.sh

