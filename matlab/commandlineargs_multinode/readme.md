For this example to work, you must first have a parallel profile set up.  See the [Quest MATLAB Documentation](https://kb.northwestern.edu/quest-matlab).  In the MATAB script (script1.m), you must change the name of the parallel profile to match a parallel profile that you have set up.  

You submit this job by running the `myjob.sh` script, not by using `sbatch`. You must make the `myjob.sh` script executable first:

```
chmod u+x myjob.sh
./myjob.sh
```

MATLAB will use the parallel profile that's been set up to submit jobs for us.  

It will take a few minutes for your job to be submitted, but you can get information about it once it's started with 

```
showq -u your_netid
```