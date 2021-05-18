#!/bin/bash 
#SBATCH -A <allocationID> 
#SBATCH --time=<hh:mm:ss> 
#SBATCH --partition=<queueName>
#SBATCH -J <jobName>
#SBATCH --mail-type=<events> # e.g. BEGIN,END,FAIL
#SBATCH --mail-user=<email>
#SBATCH --output=<combined out and err file path>
#SBATCH --nodes=1
#SBATCH -n 4 # 4 because that's what is set in the parpool in the .m file 
#SBATCH --mem=12G  # Total memory in GB needed for a job. Also see --mem-per-cpu

# unload modules that may have been loaded when job was submitted
module purge all

## job commands; script1 is the MATLAB .m file, specified without the .m extension
module load matlab/r2020b
matlab -nosplash -nodesktop -singleCompThread -r "numiter=500;script1" 

# Submit this job from the command line with: sbatch myjob.sh
