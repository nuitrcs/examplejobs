#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need (For Gaussian do not change this from 1)
#SBATCH --ntasks-per-node=10 ## how many cpus or processors do you need on each computer
#SBATCH --time=04:00:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem=10G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=sample_gaussian_job  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=output.log ## standard out and standard error goes to this file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=email@u.northwestern.edu ## your email

# load the module
module load Gaussian16/g16-C.01_avx2

# the next line prevents OpenMP parallelism from conflicting with Gaussian's internal SMP parallelization
export OMP_NUM_THREADS=1

DYNAMIC_MEMORY="$SLURM_MEM_PER_NODE""mb"
echo "Setting the dynamic memory to $DYNAMIC_MEMORY"
echo "Setting the number of processors to $SLURM_NTASKS"

g16 -m=$DYNAMIC_MEMORY -p=$SLURM_NTASKS ch3.com
