If you want to run the same Python script with different parameters, you can save those parameters in a file, one line for each job, and then submit a job for each line.

`params.txt` is a tab-delimited file.  There must be an empty line at the end, or the last line of parameter values will not get read.

The submit.sh file needs to have the executable permission set.  You only have to do this once for each file:

`chmod u+x submit.sh`

Then you submit your jobs by running the `submit.sh` script:

`./submit.sh`

This script will loop through params.txt and submit a job for each line in that file.