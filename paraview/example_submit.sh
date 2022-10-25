#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=4 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:10:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=sample_job  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog ## standard out and standard error goes to this file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=email@u.northwestern.edu ## your email
#SBATCH --constraint="[quest8|quest9|quest10|quest11]" ### you want computers you have requested to be from either quest8 or quest9 or quest10, not a combination of nodes. Import for MPI, not usually import for job arrays)

module purge all
module load paraview/5.9.0

# The paraview module is a wrapper around a container. In order to avoid annoying container calls, shell functions have been defined for your convience when submitting jobs on Quest. See all of the function names below.

mpi-pvbatch test-pvbatch.py
#pvbatch XXXX
#pvserver XXXX
#pvpython XXXX
#mpi-pvserver XXXX
#mpi-pvpython XXXX
