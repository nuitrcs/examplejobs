#!/bin/bash
while IFS=$'\t' read P1 P2
do
    JOB=`msub - << EOJ

#!/bin/bash
#MSUB -A <allocationID>
#MSUB -q <queueName>
#MSUB -l walltime=<hh:mm:ss>
#MSUB -M <emailAddress>
#MSUB -j oe
#MSUB -N <jobName>
#MSUB -l nodes=1:ppn=<numberOfCores>

# load the version of python you want to use
module load python/anaconda3.6

# Set your working directory 
# This sets it to the directory you're submitting from -- change as appropriate
cd $PBS_O_WORKDIR

# After you change directories with the command above, all files below 
# are then referenced with respect to that directory

python myscript_named.py --intval=${P1} --stringval=${P2}
EOJ
`

# print out the job id for reference later
echo "JobID = ${JOB} for parameters ${P1} ${P2} submitted on `date`"
done < params.txt
exit   

# make this file executable and then run from the command line
# chmod u+x submit.sh
# ./submit.sh
