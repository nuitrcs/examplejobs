#!/bin/bash

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=fastqc
#SBATCH --output=fastqc.out
#SBATCH --error=fastqc.err
#SBATCH --time=02:00:00
#SBATCH --mem=30G       ### edit this line to reserve more/less memory
#SBATCH --ntasks=8      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module load fastqc/0.11.5

# first line:
# fastqc is called, the command is run on a single thread, the directory holding the fastqs for QC is specified and each one will be analyzed per the "*fastq" at end of path, -o . specifies the output directory your working in to contain the output of the command. Make sure this directory is copied to your working directory in your lab's partition before running.
# Anthony Pulvino; 10/24/2022

export example_files=/projects/genomicsshare/GCC_scripts/fastqc/sequence_read

fastqc -threads 8 $example_files/*fastq -o .
