#!/bin/bash

for i in {1..5} ## change 5 here to the number you need
do
    here=`pwd`
    JOB=`sbatch - << EOJ
#!/bin/bash
#SBATCH -A <allocationID>
#SBATCH --partition=normal # queue name depends on walltime - change as appropriate
#SBATCH --time=10:00:00 # an example of a 10 hour job - set as appropriate
#SBATCH --mail-type=FAIL # only send emails if job aborts; if submitting a lot of jobs, you probably don't want an email for every begin and end of a job
#SBATCH --mail-user=<emailAddress>
#SBATCH --output=<combined out and err file path> # joins stdout and stderr so everything goes to one file
#SBATCH -J <jobName> # set a descriptive value here
#SBATCH --nodes=1
#SBATCH -n 1 # often you'll be using just 1 core per job when splitting up your work this way
#SBATCH --mem=3G  # Total memory in GB needed for a job. Also see --mem-per-cpu

# unload modules that may have been loaded when job was submitted
module purge all

# load the module you want to use 
module load R/3.3.1

## remember that you should have installed any R packages you want to use ahead of time

# By default all file paths are relative to the directory where you submitted the job.
# To change to another path, use `cd <path>`, for example:
# cd /projects/<allocationID>

# call your R script, supplying the loop index
Rscript commandlineargs.R $i # $i has the value of the loop number, 1, 2, 3, 4, 5 in this example

# if you have a second script to run for each index (e.g. each data file you're processing) after the first finishes, you can call it here;
# if not, omit this part
Rscript mysecondscript.R $i 

EOJ
`

# Note the ` marks above -- one in line 5 and one in line 36
# They are supposed to be there like that -- enclosing the sbatch command
# and what normally goes in a job submission script

# print out the job id for reference later so you can keep track
echo "JobID = ${JOB} for index $i submitted on `date`"
done 
exit   

# make this file executable and then run from the command line
# chmod u+x submit.sh
# ./submit.sh
