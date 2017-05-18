#!/bin/bash
#MSUB -A <allocationID>
#MSUB -q <queueName>
#MSUB -l walltime=<hhh:mm:ss> 
#MSUB -M <emailAddress>
#MSUB -j oe
#MSUB -N <jobName>
#MSUB -l nodes=1:ppn=4

## We use 4 for ppn (cores) above because Stata-MP has a 4 core license.

module load stata

# Set your working directory: where are your scripts and data?
# This sets it to the directory you're submitting from -- change as appropriate
cd $PBS_O_WORKDIR
# Another example: cd /projects/<allocationID>

# After you change directories with the command above, all files below 
# are then referenced with respect to that directory

# The .do filename (with the path as necessary) is being passed in as an 
# environmental variable from the call to msub.  
stata-mp -b do ${DOFILENAME} 
# Stata output will be in mycode.log in the working directory.
# mycode.do example file also writes some additional output files.

# There will also be a job output file called <jobname>.o<jobID> 
# in the directory from which you submit the job with information from the scheduler

# From the command line, in the directory with this file, you could then 
# submit multiple jobs for different files (mycode1.do, mycode2.do).  Examples:
# msub -v DOFILENAME=mycode1 myjob.sh
# msub -v DOFILENAME=mycode2 myjob.sh

