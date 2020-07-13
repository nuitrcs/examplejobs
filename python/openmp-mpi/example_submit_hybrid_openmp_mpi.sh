#!/bin/bash
#SBATCH --account=w10001  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=w10001  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=4 ## how many MPI tasks are running on each computer
#SBATCH --cpus-per-task 4 ## howmany cpus does each MPI task needs to have access to
#SBATCH --time=00:10:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=sample_job  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog ## standard out and standard error goes to this file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=scottcoughlin2014@u.northwestern.edu ## your email
###SBATCH --constraint="[quest5|quest6|quest8|quest9]" ### you want computers you have requested to be from either quest5 or quest6/7 or quest8 or quest 9 nodes, not a combination of nodes. Import for MPI, not usually import for job arrays)

export OMP_NUM_THREADS=4

module purge all
module load python-anaconda3
source activate slurm-py37-test

mpirun --bind-to none -n ${SLURM_NTASKS} python helloworld.py
