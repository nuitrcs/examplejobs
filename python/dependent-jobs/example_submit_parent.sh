#!/bin/bash
#SBATCH --account=p30157  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=1 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:10:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=parent  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog ## standard out and standard error goes to this file

# this job runs first, setting the environmental variables ARG1 to 1
jid0=($(sbatch --export=ARG1=1 --time=00:10:00 --account=p30157 --partition=short --nodes=1 --ntasks-per-node=1 --mem=1G --job-name=child0  example_submit_child.sh))

# this job is submitted but will not begin until jid0 has completed, and ARG1 will be set to the jobid of jid0.
jid1=($(sbatch --dependency=afterok:${jid0[-1]} --export=ARG1=${jid0[-1]} --time=00:10:00 --account=p30157 --partition=short --nodes=1 --ntasks-per-node=1 --mem=1G --job-name=child1  example_submit_child.sh))


