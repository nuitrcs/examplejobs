#!/bin/bash

## Note: be cautious of submitting many jobs or job arrays in 
## bash scripts such as this - it can overwhelm the job scheduler. 
## This is fine since it is a small number of job arrays that each
## have a small number of sub-jobs. 
 
# List of CPU counts
cpu_values=(1 2 4 6 8 10 16 20 32 40 64)

for N in "${cpu_values[@]}"; do
    echo "Submitting job with $N CPUs..."
    sbatch --job-name="scaling_study_pi_job-CPUs-$N" \
           --ntasks-per-node="$N" \
           submit_script_specify_cores.sh
    ## This sleep statement is helpful for the job scheduler 
    sleep 10
done


