#!/bin/bash
#SBATCH --account=e32680
#SBATCH --partition=short
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=34G
#SBATCH --job-name=star_index

module purge
module load STAR/2.7.9a

STAR \
  --runMode genomeGenerate \
  --runThreadN 8 \
  --genomeDir /projects/e32680/05_rnaseq_alignment/STARindex \
  --genomeFastaFiles /projects/e32680/05_rnaseq_alignment/oh.polished.fasta \
  --sjdbGTFfile /projects/e32680/05_rnaseq_alignment/braker.gtf \
  --sjdbOverhang 100 

