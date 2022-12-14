#!/bin/bash 

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=blast
#SBATCH --output=blast.out
#SBATCH --error=blast.err
#SBATCH --time=00:05:00
#SBATCH --mem=1G        ### edit this line to reserve more/less memory
#SBATCH --nodes=1       ### edit this line to reserve different no. of cores
#SBATCH --ntasks=1

module load blast/2.12.0

# first line:
# make the blast database from proteomic sequences you’ll then align to
# -in inputs the GRCz10 genome fasta file, we ask blast to parse the sequence IDs and provide a nucleotide database for alignment
# second line: 
# nucleotide "blastn" command is used to align with the -query nucleotide seqs of interest against all nt seqs used to make the db above
# the query search will be a fasta file of mef genes and we will align against the genome.fa database that we created from the previous command
# Anthony Pulvino; 10/24/2022

export example_files=/projects/genomicsshare/GCC_scripts/blast

makeblastdb -in $example_files/genome.fa -parse_seqids -dbtype nucl
blastn -query $example_files/ZebrafishMef_GRCz10.fa -db $example_files/genome.fa
