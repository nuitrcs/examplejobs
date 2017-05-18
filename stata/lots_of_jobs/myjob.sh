#!/bin/bash
#MSUB -A <allocationID>
#MSUB -q <queueName>
#MSUB -l walltime=<hhh:mm:ss> 
#MSUB -M <emailAddress>
#MSUB -j oe
#MSUB -N <jobName>
#MSUB -l nodes=1:ppn=4

module load stata

# Set your working directory: where are your scripts and data?
# This sets it to the directory you're submitting from -- change as appropriate
cd $PBS_O_WORKDIR
# Another example: cd /projects/<allocationID>

# After you change directories with the command above, all files below 
# are then referenced with respect to that directory

# mycode.do is your Stata script.  If it's not in the working directory set above, add 
# the full or relative path as appropriate.
# Extra values are being passed to mycode.do
stata-mp -b do mycode ${PASSEDPARAMS} 

# Stata output will be in mycode.log in the working directory.

# There will also be a job output file called <jobname>.o<jobID> 
# in the directory from which you submit the job with information from the scheduler

# See the readme.md file for info on submitting this job.

