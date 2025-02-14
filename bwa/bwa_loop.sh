#!/bin/bash

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=bwa
#SBATCH --output=bwa.out
#SBATCH --error=bwa.err
#SBATCH --time=30:00:00
#SBATCH --mem=10G       ### edit this line to reserve more/less memory
#SBATCH --ntasks=8      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module load bwa/0.7.17

# first line:
# create the genome index for alignment, in this case GRCh38 version of human genome with the prefix (-p) GRCh38_idx
# bash loop:
# in this directory there is a file called filenames.txt, for every unique file prefix in that file, the bwa mem command within the loop will be run
# -t specifies the threads to use, followed by the index created in the initial line, then fastqs are specified to run bwa-mem in pe mode and the output is redirected to the output SAM files before closing the loop.
# Anthony Pulvino; 10/24/2022

export genome_fa_dir=/projects/genomicsshare/GCC_scripts/bwa
export example_files=/projects/genomicsshare/GCC_scripts/bwa/sequence_read

bwa index $genome_fa_dir/GRCh38_HumanGenome.fa -p GRCh38_idx

cat $example_files/filenames.txt | while read line; do \
        file=$line;

        bwa mem -t 8 GRCh38_idx $example_files/${file}_1.filt.fastq $example_files/${file}_2.filt.fastq > ${file}_aln_pe.sam
done
