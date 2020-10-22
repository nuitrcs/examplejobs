# job dependent submission.
```
sbatch example_submit_parent.sh
```
This will submit a job that itself will submit a series of jobs, which have a hierarchical dependence on one another (i.e. the process of the first command needs to finish before the other commands can begin). SLURM should show the jobs like follows
```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           6806205     short   child0   XXXXXX PD       0:00      1 (Priority)
           6806206     short   child1   XXXXXX PD       0:00      1 (Dependency)
```
Note the "Dependency" Reason for jobid 6806206
