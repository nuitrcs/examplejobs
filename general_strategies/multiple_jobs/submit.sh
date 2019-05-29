#!/bin/bash

# this next line reads tab-delimited (\t) and expects to get two values per line, 
# saved as P1 and P2
while IFS=$'\t' read P1 P2
do
    JOB=`sbatch - << EOJ

#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition=<queueName>
#SBATCH --time=<hh:mm:ss>
#SBATCH --mail-user=<emailAddress>
#SBATCH --output=<combined out and err file path>
#SBATCH -J <jobName>
#SBATCH --nodes=<count>
#SBATCH -n <core count>

# unload modules that may have been loaded when job was submitted
module purge all

# load the module you want to use -- here Python, but same strategy with others
module load python/anaconda3.6

# Here goes the application-specific line.  Example here is using 
# named command line arguments for a Python script, but use ${P1} and ${P2} a
# as appropriate for your application
python myscript_named.py --intval=${P1} --stringval=${P2}
EOJ
`

# Note the ` marks above -- one in line 7 and one in line 32
# They are supposed to be there like that -- enclosing the sbatch command
# and what normally goes in a job submission script

# print out the job id for reference later so you can keep track
echo "{$JOB} for parameters ${P1} ${P2} submitted on `date`"

# sleep to prevent overwhelming scheduler
sleep 3s

done < params.txt
exit   

# make this file executable and then run from the command line
# chmod u+x submit.sh
# ./submit.sh
