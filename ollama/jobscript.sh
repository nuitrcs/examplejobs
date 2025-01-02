#!/bin/bash
#SBATCH -A XXXXX
#SBATCH -p gengpu
#SBATCH -t 24:00:00
#SBATCH --gres=gpu:a100:2
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=128G
#SBATCH --job-name=biblatex-transformer

module load singularity

# Use a temporary directory when pulling container image
export SINGULARITY_CACHEDIR=$TMPDIR

eval "$(conda shell.bash hook)"
# Run the container
singularity exec --nv -B /projects/your-project-here:/projects/your-project-here/ /path/to/generated/sif/file.sif ollama serve &
python /projects/path/to/your/script/with/ollama/test-ollama.py
