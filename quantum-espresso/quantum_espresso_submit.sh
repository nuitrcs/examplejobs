#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=4 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:20:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=3G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=sample_job  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog_qe_6.7_intel ## standard out and standard error goes to this file
#SBATCH --constraint="[quest7|quest8|quest9|quest10]"

module purge all
module load quantum-espresso/6.7-openmpi-4.0.5-intel-19.0.5.281

mpirun -np $SLURM_NTASKS pw.x < ./qe.in > ./qe.out
#srun -n ${SLURM_NTASKS} pw.x < ./qe.in > ./qe.out
