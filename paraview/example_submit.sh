#!/bin/bash
#SBATCH --account=w10001  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=w10001  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=4 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:10:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=1G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=sample_job  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=outlog ## standard out and standard error goes to this file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=email@u.northwestern.edu ## your email
#SBATCH --constraint="[quest5|quest6|quest8|quest9|quest10]" ### you want computers you have requested to be from either quest5 or quest6/7 or quest8 or quest 9 nodes, not a combination of nodes. Import for MPI, not usually import for job arrays)

# Let the user know what's happening
echo "Launching ParaView 5.8.0 with command: " "$@"
echo "Slurm nodelist: "$SLURM_NODELIST

# Load pv module
echo "Loading modules..."
module purge all
module load paraview/5.8.0

# Create the nodelist to pass to MPI for Singularity
echo "Preparing nodelist..."
node_list=$(scontrol show hostname ${SLURM_NODELIST} | sort -u)

mp_host_list=""
for host in ${node_list}; do
  mp_host_list="${mp_host_list}$host,"
done

mp_host_list=$(echo ${mp_host_list} | sed -e "s/,$//")

# Launch!
echo "Launching..."
mpiexec -hosts $mp_host_list -np ${SLURM_NTASKS} singularity exec -B /projects:/projects /software/paraview/5.8.0-singularity/paraview_pv-v5.8.0-osmesa-py3.sif /opt/paraview/bin/"$@"
