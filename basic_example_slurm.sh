#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition <queueName>
#SBATCH --time=<hh:mm:ss>
#SBATCH --mail-user=<emailAddress>
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --job-name=<jobName>
#SBATCH --nodes=1              
#SBATCH --ntasks-per-node=1

# Leave a blank line, like above, before you start your other commands

# with #SBATCH, a # doesn't indicate a comment;
# it's part of the SBATCH specification (and first line).
# In the rest of the script, # starts a comment

# add a project directory to your PATH (if needed)
export PATH=$PATH:/projects/<allocationID>

# clear your module environment 
module purge all

# load modules you need to use: these are just examples
module load python/anaconda
module load java

# Set your working directory 
# This sets it to the directory you're submitting from -- change as appropriate
cd $SLURM_SUBMIT_DIR

# After you change directories with the command above, all files below 
# are then referenced with respect to that directory

# A command you actually want to execute (example):
java -jar <someinput> <someoutput>
# Another command you actually want to execute, if needed (example):
python myscript.py
