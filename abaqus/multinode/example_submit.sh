#!/bin/bash
#SBATCH -A pXXXXX               # Allocation
#SBATCH -p short                # Queue
#SBATCH -t 04:00:00             # Walltime/duration of the job
#SBATCH --ntasks=20             # Number of CPUs (no need to specify how many nodes as it is MPI)
#SBATCH --mem-per-cpu=3G        # Memory per cpu
#SBATCH --job-name=example_job  # Name of job
#SBATCH --constraint="[quest9|quest10|quest11|quest12]"

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

if [[ $SLURM_JOB_CPUS_PER_NODE =~ "," ]]; then
    cpus_per_node_list=()
    node_list=($(scontrol show hostname ${SLURM_NODELIST} | sort -u))
    IFS=',' read -r -a cpus_per_node <<< "$SLURM_JOB_CPUS_PER_NODE"
    mp_host_list="["
    for i in "${!cpus_per_node[@]}"
    do
        if [[ ${cpus_per_node[i]} =~ "x" ]]; then
            weird_syntax_stripped_out=`echo "${cpus_per_node[i]}" | sed "s/(//" | sed "s/)//" | sed "s/x/,/"`
            IFS=',' read -r -a repeated_cpus_per_node <<< "$weird_syntax_stripped_out"
            for (( ii=0; ii<${repeated_cpus_per_node[1]}; ii++ )); do
                echo $ii
                cpus_per_node_list+=(${repeated_cpus_per_node[0]})
            done;
        else
            cpus_per_node_list+=(${cpus_per_node[i]})
        fi
    done

    mp_host_list="["
    for i in "${!node_list[@]}"
    do
        x=${node_list[i]}
        y=${cpus_per_node_list[i]}
        mp_host_list="${mp_host_list}['$x', $y],"
    done
else
    node_list=$(scontrol show hostname ${SLURM_NODELIST} | sort -u)
    mp_host_list="["
    for host in ${node_list}; do
        mp_host_list="${mp_host_list}['$host', ${SLURM_CPUS_ON_NODE}],"
    done
fi

mp_host_list=$(echo ${mp_host_list} | sed -e "s/,$/]/")

echo "mp_host_list=${mp_host_list}"  >> ${env_file}

export I_MPI_HYDRA_BOOTSTRAP=ssh

# A command you actually want to execute:
abaqus interactive analysis job=<inp file > user=<user-script> cpus=${SLURM_NPROCS} mp_mode=mpi double=both memory="3 gb" scratch=${SLURM_SUBMIT_DIR}
