#!/bin/bash
#SBATCH --account=a9009  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=a9009  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=1 ## how many cpus or processors do you need on each computer
#SBATCH --time=48:00:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem=50G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --gres=gpu:a100:1
#SBATCH --job-name="AlphaPulldown_GPU_\${SLURM_ARRAY_TASK_ID}"  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=AlphaPulldown_GPU.%A_%a.log  ## When you run squeue -u NETID this is how you can identify the job

module purge
module load mamba/23.1.0
source activate /software/AlphaPulldown/1.0.4/env

export TF_FORCE_UNIFIED_MEMORY=1
export XLA_PYTHON_CLIENT_MEM_FRACTION=4.0

run_multimer_jobs.py --mode=pulldown \
    --num_cycle=3 \
    --num_predictions_per_model=1 \
    --output_path=<outdir>/models \
    --data_dir=/software/AlphaFold/data/v2.3.2/ \
    --protein_lists=baits.txt,candidates_shorter.txt \
    --monomer_objects_dir=<outdir>/features \
    --job_index=$SLURM_ARRAY_TASK_ID \
     --compress_result_pickles=True \
    --remove_result_pickles=True
