#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=8 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:20:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=3G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=sample_job  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog_gromacs ## standard out and standard error goes to this file
#SBATCH --constraint="[quest8|quest9|quest10|quest11]"

module purge
module load gromacs/2020.4-openmpi-4.0.5-gcc-10.2.0
######################
# RUN THE SIMULATION #
######################

export OMP_NUM_THREADS=1
export GMX_MAXBACKUP=-1
export jobname="1us-apo-NMDA-4PE5_v1"

mpirun -np ${SLURM_NTASKS} gmx_mpi mdrun -s ${jobname}.tpr -cpi ${jobname}.cpt -deffnm ${jobname} -maxh 2 -noappend
