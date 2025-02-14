#!/bin/bash

#SBATCH --account=e32559
#SBATCH --partition=normal
#SBATCH --array=0-66
#SBATCH --job-name=alignreseq
#SBATCH --output=reseq.%A_%a.out
#SBATCH --error=reseq.%A_%a.err
#SBATCH --time=10:00:00
#SBATCH --mem=10G       ### edit this line to reserve more/less memory
#SBATCH --ntasks=8      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module load bwa/0.7.17

export REF_GENOME=/projects/e32559/example_data/oenotheraHarringtonii.softmasked.fasta
export SAMPLE_DIR=/projects/e32559/example_data

# read in list of samples
IFS=$'\n' read -d '' -r -a lines < $SAMPLE_DIR/list_of_samples.txt

# index softmasked genome, this should be done previously
#bwa index $REF_GENOME

# make directories for output
cd $SAMPLE_DIR
mkdir sam
mkdir bam
mkdir sorted_bam
cd sam

# align reads to soft masked genome
bwa mem -t $SLURM_PROCS $REF_GENOME \
  $SAMPLE_DIR/${lines[$SLURM_ARRAY_TASK_ID]}_R1_001.fastq.gz \
  $SAMPLE_DIR/${lines[$SLURM_ARRAY_TASK_ID]}_R2_001.fastq.gz > ${lines[$SLURM_ARRAY_TASK_ID]}_aln-pe.sam

# convert and sort ####
module load samtools/1.16.1-gcc-10.4.0

# convert sam to bam
samtools view -bS ${lines[$SLURM_ARRAY_TASK_ID]}_aln-pe.sam > ../bam/${lines[$SLURM_ARRAY_TASK_ID]}_aln.bam

# sort bam files
samtools sort -o ../sorted_bam/${lines[$SLURM_ARRAY_TASK_ID]}_sorted.bam ../bam/${lines[$SLURM_ARRAY_TASK_ID]}_aln.bam
