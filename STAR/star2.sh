#!/bin/bash
#SBATCH --account=e32680
#SBATCH --partition=short
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=25G
#SBATCH --job-name=star_align

module purge
module load STAR/2.7.9a

STAR \
  --runThreadN 8 \
  --genomeDir /projects/e32680/05_rnaseq_alignment/STARindex \
  --readFilesIn /projects/e32680/05_rnaseq_alignment/SRR7773980_1.fastq.gz,/projects/e32680/05_rnaseq_alignment/SRR7773980_2.fastq.gz \
  --readFilesCommand gunzip -c \
  --outFileNamePrefix ./STARoutputs
