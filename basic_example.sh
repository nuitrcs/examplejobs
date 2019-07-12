#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition=<queueName>
#SBATCH --time=<hh:mm:ss>
#SBATCH --mail-user=<emailAddress>
#SBATCH --output=<combined out and err file path>
#SBATCH -J <jobName>
#SBATCH --nodes=1
#SBATCH -n 1
#SBATCH --mem=3G  # Total memory in GB needed for a job. Also see --mem-per-cpu

# with #SBATCH, a # doesn't indicate a comment;
# it's part of the SBATCH specification (and first line).
# In the rest of the script, # starts a comment

# unload modules that may have been loaded when job was submitted
module purge all

# add a project directory to your PATH (if needed)
export PATH=$PATH:/projects/<allocationID>

# load modules you need to use: these are just examples
module load python/anaconda
module load java

# By default all file paths are relative to the directory where you submit the job.
# To change to another path, use "cd <path>", for example:
# cd /projects/<allocationID>

# After you change directories with the command above, all file paths below 
# are relative to that directory.

# A command you actually want to execute (example):
java -jar <someinput> <someoutput>

# Another command you actually want to execute, if needed (example):
python myscript.py