#!/bin/bash
#MSUB -A <allocationID>
#MSUB -q <queueName>
#MSUB -l walltime=<hh:mm:ss>
#MSUB -M <emailAddress>
#MSUB -j oe
#MSUB -N <jobName>
#MSUB -l nodes=1:ppn=<numberOfCores>

# Leave a blank line, like above, before you start your other commands

# with #MSUB, a # doesn't indicate a comment;
# it's part of the MSUB specification (and first line).
# In the rest of the script, # starts a comment

# load module with version you want
module load R/3.3.2

# Set your working directory 
# This sets it to the directory you're submitting from -- change as appropriate
cd $PBS_O_WORKDIR

# command line args (myoutputfile and 14) are hard-coded here
Rscript commandlineargs.R myoutputfile 14

# submit this file with msub
# msub myjob.sh