#!/bin/bash
#SBATCH --account=pXXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=4 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:20:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=3G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=lammps_openmpi  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog_lammps_openmpi_intel ## standard out and standard error goes to this file
#SBATCH --constraint="[quest8|quest9|quest10|quest11]"

module purge
module load lammps/20200303-openmpi-4.0.5-intel-19.0.5.281

mpirun -np ${SLURM_NTASKS} lmp -in in.lj
#srun --mpi=pmix_v3 lmp -in in.lj

