#!/bin/bash
#SBATCH --account=pXXXX  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=gengpu  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need - for AlphaFold this should always be one
#SBATCH --ntasks-per-node=4 ## how many cpus or processors do you need on each computer
#SBATCH --job-name=Ollama-batch-job ## When you run squeue -u <NETID> this is how you can identify the job
#SBATCH --time=3:30:00 ## how long does this need to run 
#SBATCH --mem=40GB ## how much RAM do you need per node (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --gres=gpu:h100:1 ## type of GPU requested, and number of GPU cards to run on
#SBATCH --output=output-%j.out ## standard out goes to this file
#SBATCH --error=error-%j.err ## standard error goes to this file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=email@northwestern.edu ## your email, non-Northwestern email addresses may not be supported

#########################################################################
### PLEASE NOTE:                                                      ###
### The above CPU, Memory, and GPU resources have been selected based ###
### on the computing resources that Ollama was tested on              ###
### It is likely that you do not have to change anything above        ###
### besides your allocation, and email (if you want to be emailed).   ###
### However, if you make changes to downsaple size, model type, or    ###
### other Ollama specific variables, the time and amount of GPU cards ###
### needed may have to be altered.                                    ###
#########################################################################


# Source in all the helper functions - No need to change any of this
source_helpers () {
  # Generate random integer in range [$1..$2]
  random_number () {
    shuf -i ${1}-${2} -n 1
  }
  export -f random_number

  port_used_python() {
    python -c "import socket; socket.socket().connect(('$1',$2))" >/dev/null 2>&1
  }

  port_used_python3() {
    python3 -c "import socket; socket.socket().connect(('$1',$2))" >/dev/null 2>&1
  }

  port_used_nc(){
    nc -w 2 "$1" "$2" < /dev/null > /dev/null 2>&1
  }

  port_used_lsof(){
    lsof -i :"$2" >/dev/null 2>&1
  }

  port_used_bash(){
    local bash_supported=$(strings /bin/bash 2>/dev/null | grep tcp)
    if [ "$bash_supported" == "/dev/tcp/*/*" ]; then
      (: < /dev/tcp/$1/$2) >/dev/null 2>&1
    else
      return 127
    fi
  }

  # Check if port $1 is in use
  port_used () {
    local port="${1#*:}"
    local host=$((expr "${1}" : '\(.*\):' || echo "localhost") | awk 'END{print $NF}')
    local port_strategies=(port_used_nc port_used_lsof port_used_bash port_used_python port_used_python3)

    for strategy in ${port_strategies[@]};
    do
      $strategy $host $port
      status=$?
      if [[ "$status" == "0" ]] || [[ "$status" == "1" ]]; then
        return $status
      fi
    done

    return 127
  }
  export -f port_used

  # Find available port in range [$2..$3] for host $1
  # Default: [2000..65535]
  find_port () {
    local host="${1:-localhost}"
    local port=$(random_number "${2:-2000}" "${3:-65535}")
    while port_used "${host}:${port}"; do
      port=$(random_number "${2:-2000}" "${3:-65535}")
    done
    echo "${port}"
  }
  export -f find_port

  # Wait $2 seconds until port $1 is in use
  # Default: wait 30 seconds
  wait_until_port_used () {
    local port="${1}"
    local time="${2:-30}"
    for ((i=1; i<=time*2; i++)); do
      port_used "${port}"
      port_status=$?
      if [ "$port_status" == "0" ]; then
        return 0
      elif [ "$port_status" == "127" ]; then
         echo "commands to find port were either not found or inaccessible."
         echo "command options are lsof, nc, bash's /dev/tcp, or python (or python3) with socket lib."
         return 127
      fi
      sleep 0.5
    done
    return 1
  }
  export -f wait_until_port_used

}
export -f source_helpers

source_helpers

# Find available port to run server on
OLLAMA_PORT=$(find_port localhost 7000 11000)
export OLLAMA_PORT
echo $OLLAMA_PORT


module load ollama/0.6.6
module load gcc/12.3.0-gcc
module load mamba/24.3.0

export OLLAMA_HOST=0.0.0.0:${OLLAMA_PORT} #what should our IP address be?
export SINGULARITYENV_OLLAMA_HOST=0.0.0.0:${OLLAMA_PORT} 

#start Ollama service
ollama serve &> serve_ollama_${SLURM_JOBID}.log &

#wait until Ollama service has been started
sleep 30

# activate virtual environment
eval "$('/hpc/software/mamba/24.3.0/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
source "/hpc/software/mamba/24.3.0/etc/profile.d/mamba.sh"
mamba activate /projects/p12345/envs/ollama-env # Make sure to change the path of this environment

#Run the python script
python -u create_stories.py
