#!/bin/bash

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=samtools
#SBATCH --output=samtools.out
#SBATCH --error=samtools.err
#SBATCH --time=10:00:00
#SBATCH --mem=1G        ### edit this line to reserve more/less memory for your job
#SBATCH --ntasks=8      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module load samtools/1.10.1

# bash loop:
# in this directory there is filenames.txt which contains list of unique file ID/prefix ensuring the cmd in the loop is run on each of the files you plan to work with
# first line:
# samtools view is run with 8 threads, we want the -h headers in all of the output as well as the -b output we want in bam format
# we specify input files in sam format followed by the -o output format in bam with the corresponding file name before closing the loop.
# Anthony Pulvino; 10/24/2022

export example_files=/projects/genomicsshare/GCC_scripts/samtools

cat $example_files/filenames.txt | while read line; do \
        file=$line;

        samtools view -@ 8 -b -h \
        $example_files/${file}_aln_pe.sam \
        -o ${file}_aln_pe.bam
done
