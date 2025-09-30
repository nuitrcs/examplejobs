#!/bin/bash
#SBATCH --job-name=test_ansys
#SBATCH --output=test_ansys-%j.log
#SBATCH --account=<slurm-account> ## Required: your Slurm account name, i.e. eXXXX, pXXXX or bXXXX
#SBATCH --partition=<slurm-partition> ## Required: (buyin, short, normal, long, gengpu, genhimem, etc)
#SBATCH --time=00:05:00 ## Required: How long will the job need to run (remember different partitions have restrictions on this parameter)
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2GB
#SBATCH --time=00:05:00

module purge all
mpi/openmpi-4.1.6rc2-gcc-10.4.0
module load ansys/2025R1

JOB_NODES="$(scontrol show hostnames)"
JOB_NODES=$(echo ${JOB_NODES} | tr ' ' ',')

fluent 3ddp -g -cnf=${JOB_NODES} -t${SLURM_NTASKS} -mpitest -mpi=openmpi
