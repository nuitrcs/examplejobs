To run the same application script with multiple different parameter values, put the parameters in a separate file, params.txt, with each line having the parameters for one job.  The values should be tab separated.  Make sure that params.txt has an empty line at the end so that the last line of values is terminated with a new line character.  

Then instead of writing a simple submission script, use a bash script with a loop that submits one job per line of params.txt.  Both the msub command and the job submission parameters that are usually in the job submission script are in a file together: submitjobs.sh.  

Make submitjobs.sh executable:

`chmod u+x submitjobs.sh`

Then run the script:

`./submitjobs.sh`

This will submit multiple jobs.