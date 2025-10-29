#!/bin/bash
#SBATCH --account=e32680
#SBATCH --partition=short
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=25G
#SBATCH --job-name=star_align_${SLURM_ARRAY_TASK_ID}
#SBATCH --array=0-9  # Adjust based on number of samples

module purge
module load STAR/2.7.9a

# set variables
export $GENOMEDIR=/projects/e32680/02_staralignment_reference/STARindex
export $SAMPLEDIR=/projects/e32680/04_highthroughput/data

# read in list of samples
IFS=$'\n' read -d '' -r -a lines < $SAMPLEDIR/samples.txt

STAR \
  --runThreadN $SLURM_NTASKS \
  --genomeDir $GENOMEDIR \
  --readFilesIn $SAMPLEDIR/${lines[$SLURM_ARRAY_TASK_ID]}_1.fastq.gz,$SAMPLEDIR/${lines[$SLURM_ARRAY_TASK_ID]}_2.fastq.gz \
  --readFilesCommand gunzip -c \
  --outFileNamePrefix ./${lines[$SLURM_ARRAY_TASK_ID]}_STARoutputs
