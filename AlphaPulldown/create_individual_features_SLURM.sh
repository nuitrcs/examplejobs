#!/bin/bash
#SBATCH --account=a9009  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=a9009  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=8 ## how many cpus or processors do you need on each computer
#SBATCH --time=48:00:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem=50G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name="AlphaPulldown_CPU_\${SLURM_ARRAY_TASK_ID}" ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=AlphaPulldown_CPU.%A_%a.log  ## When you run squeue -u NETID this is how you can identify the job

module purge
module load mamba/23.1.0
source activate /software/AlphaPulldown/1.0.4/env

export OPENMM_CPU_THREADS=8

create_individual_features.py \
  --fasta_paths=baits.fasta,example_1_sequences_shorter.fasta \
  --data_dir=/software/AlphaFold/data/v2.3.2/ \
  --save_msa_files=True \
  --output_dir=<outdir>/features \
  --use_precomputed_msas=False \
  --max_template_date=2050-01-01 \
  --skip_existing=True \
  --seq_index=$SLURM_ARRAY_TASK_ID
