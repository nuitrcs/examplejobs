#!/bin/bash

# this next line reads tab-delimited (\t) and expects to get two values per line, 
# saved as P1 and P2
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

# load the module you want to use -- here Python, but same strategy with others
module load python/anaconda3.6

# Set your working directory 
# This sets it to the directory you're submitting from -- change as appropriate
cd $PBS_O_WORKDIR

# After you change directories with the command above, all files below 
# are then referenced with respect to that directory

# Here goes the application-specific line.  Example here is using 
# named command line arguments for a Python script, but use ${P1) and ${P2} a
# as appropriate for your application
python myscript_named.py --intval=${P1} --stringval=${P2}
EOJ
`

# Note the ` marks above -- one in line 7 and one in line 32
# They are supposed to be there like that -- enclosing the msub command
# and what normally goes in a job submission script

# print out the job id for reference later so you can keep track
echo "JobID = ${JOB} for parameters ${P1} ${P2} submitted on `date`"
done < params.txt
exit   

# make this file executable and then run from the command line
# chmod u+x submit.sh
# ./submit.sh
