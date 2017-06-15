#!/bin/bash 
#MSUB -A <allocationID> 
#MSUB -l nodes=1:ppn=4 # 4 because that's what is set in the parpool in the .m file
#MSUB -l walltime=<hh:mm:ss> 
#MSUB -q <queueName>
#MSUB -N <jobName>
#MSUB -m abe
#MSUB -M <email>
#MSUB -j oe

## set your working directory 
cd $PBS_O_WORKDIR 

## job commands; script1 is the MATLAB .m file, specified without the .m extension
module load matlab/r2016a
matlab -nosplash -nodesktop -singleCompThread -r "numiter=500;script1" 


# Submit this job from the command line with: msub myjob.sh