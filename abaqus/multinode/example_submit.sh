#!/bin/bash
#SBATCH -A pXXXX               # Allocation
#SBATCH -p short                # Queue
#SBATCH -t 04:00:00             # Walltime/duration of the job
#SBATCH -N 2                    # Number of Nodes
#SBATCH --mem-per-cpu=3G               # Memory per node in GB needed for a job. Also see --mem-per-cpu
#SBATCH --ntasks-per-node=28     # Number of Cores (Processors)
#SBATCH --job-name=example_job       # Name of job

# unload any modules that carried over from your command line session
module purge

# load modules you need to use
module load abaqus/2020

unset SLURM_GTIDS

### Create ABAQUS environment file for current job, you can set/add your own options (Python syntax)
env_file=abaqus_v6.env

cat << EOF > ${env_file}
verbose = 1
ask_delete = OFF
mp_file_system = (DETECT, DETECT)
EOF

node_list=$(scontrol show hostname ${SLURM_NODELIST} | sort -u)

mp_host_list="["
for host in ${node_list}; do
    mp_host_list="${mp_host_list}['$host', ${SLURM_CPUS_ON_NODE}],"
done

mp_host_list=$(echo ${mp_host_list} | sed -e "s/,$/]/")

echo "mp_host_list=${mp_host_list}"  >> ${env_file}

export I_MPI_HYDRA_BOOTSTRAP=ssh

# A command you actually want to execute:
abaqus interactive analysis job=<inp file > user=<user-script> cpus=${SLURM_NPROCS} mp_mode=mpi double=both memory="3 gb" scratch=${SLURM_SUBMIT_DIR}
