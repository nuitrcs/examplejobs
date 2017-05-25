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

# load the version of python you want to use
module load python/anaconda3.6

# Set your working directory 
# This sets it to the directory you're submitting from -- change as appropriate
cd $PBS_O_WORKDIR

# After you change directories with the command above, all files below 
# are then referenced with respect to that directory

python myscript_named.py --intval=${ARG1} --stringval=${ARG2}

# OR
# python myscript_named.py -i ${ARG1} -s ${ARG2}