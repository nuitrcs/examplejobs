#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=14 ## how many cpus or processors do you need on each computer
#SBATCH --cpus-per-task=1 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:20:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem=0 ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=sample_job  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog_mpi_smp_2_node ## standard out and standard error goes to this file
#SBATCH --constraint="[quest8|quest9|quest10|quest11]"

module purge all
module load namd/2.14-openmpi-4.0.5-intel-19.0.5.281 

srun -n ${SLURM_NNODES} namd2 ++ppn $((${SLURM_NTASKS_PER_NODE}-1)) alanin.conf
