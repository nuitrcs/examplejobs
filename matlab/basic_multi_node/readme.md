For this example to work, you must first have a cluster profile set up.  See the [Quest MATLAB Documentation](https://services.northwestern.edu/TDClient/30/Portal/KB/ArticleDet?ID=1548#multinode).

You submit this job by running the `submit_matlab_job_wrapper.sh` script, not by using `sbatch`. You must make the `submit_matlab_job_wrapper.sh` script executable first:

```
chmod u+x submit_matlab_job_wrapper.sh
./submit_matlab_job_wrapper.sh
```

MATLAB will use the parallel profile that's been set up to submit the jobs for us.

It will take a few minutes for your job to be submitted, but you can get information about it once it's started with 

```
squeue -u your_netid
```
