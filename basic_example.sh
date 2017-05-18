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

# add a project directory to your PATH (if needed)
export PATH=$PATH:/projects/<allocationID>

# load modules you need to use: these are just examples
module load python/anaconda
module load java

# Set your working directory 
# This sets it to the directory you're submitting from -- change as appropriate
cd $PBS_O_WORKDIR

# After you change directories with the command above, all files below 
# are then referenced with respect to that directory

# A command you actually want to execute (example):
java -jar <someinput> <someoutput>
# Another command you actually want to execute, if needed (example):
python myscript.py