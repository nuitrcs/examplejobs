#!/bin/bash
#SBATCH --account=<slurm-account> ## Required: your Slurm account name, i.e. eXXXX, pXXXX or bXXXX
#SBATCH --partition=<slurm-partition> ## Required: (buyin, short, normal, long, gengpu, genhimem, etc)
#SBATCH --time=00:05:00 ## Required: How long will the job need to run (remember different partitions have restrictions on this parameter)
#SBATCH --nodes=2 ## how many computers/nodes do you need (no default)
#SBATCH --ntasks-per-node=16 ## how many cpus or processors do you need on per computer/node (default value 1)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per computer/node (this affects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=ansys_fluent_mpi_test ## When you run squeue -u

module purge
module load ansys/2023R2

#Set license type and LM server
export LSTC_LICENSE_FILE=network
export LSTC_LICENSE_SERVER=rho.mcc.northwestern.edu
export LSTC_LICENSE=ANSYS
export ANSYSPATH=/software/ansys/2023R2/v232/

# Add the LS-DYNA executables to the PATH
export PATH=$ANSYSPATH/ansys/bin/linx64/:$PATH

# Add the MPI executables and libs to the PATH / LD_LIBRARY_PATH
# Depending on ANSYS version the MPI paths may require changing.
export PATH=$ANSYSPATH/commonfiles/MPI/Intel/2021.8.0/linx64/bin/:$PATH
export LD_LIBRARY_PATH=$ANSYSPATH/commonfiles/MPI/Intel/2021.8.0/linx64/lib/:$LD_LIBRARY_PATH

MACHINEFILE="machinefile.$SLURM_JOB_ID"
scontrol show hostname $SLURM_NODELIST > $MACHINEFILE
echo "MACHINE FILE CREATED: $MACHINEFILE"

# Setup my variables
#
# lsdyna_sp_mpp.e is for LS-DYNA single precision massively parallel.
# lsdyna_dp_mpp.e is for LS-DYNA double precision massively parallel.

SOLVER=lsdyna_dp_mpp.e
INPUT=1.k
MEMORY=2529m

#Run your LS-DYNA work below:
mpirun -hostfile $MACHINEFILE $SOLVER i=$INPUT z=d3ifac memory=$MEMORY
