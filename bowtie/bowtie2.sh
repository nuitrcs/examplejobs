#!/bin/bash

#SBATCH --account=e32559
#SBATCH --partition=normal
#SBATCH --job-name=bwa_align
#SBATCH --output=bwa.out
#SBATCH --error=bwa.err
#SBATCH --time=10:00:00
#SBATCH --mem=10G       ### edit this line to reserve more/less memory
#SBATCH --ntasks=8      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module load bwa/0.7.17

export REF_GENOME=/projects/e32559/example_data/oenotheraHarringtonii.softmasked.fasta
export SAMPLE_DIR=/projects/e32559/example_data


# remember to index genome before aligning
# if you're aligning many samples indexing should be done previously
#bwa index $REF_GENOME

# align reads to soft masked genome
bwa mem -t $SLURM_NPROCS $REF_GENOME \
  $SAMPLE_DIR/TRIN_5690_11_S31_L001_R1_001.fastq.gz \
  $SAMPLE_DIR/TRIN_5690_11_S31_L001_R2_001.fastq.gz > TRIN_5690_11_S31_L001_aln-pe.sam

