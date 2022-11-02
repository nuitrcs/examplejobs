#!/bin/bash

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=getfasta
#SBATCH --output=getfasta_mef.out
#SBATCH --error=getfasta_mef.err
#SBATCH --time=00:02:00
#SBATCH --mem=1G        ### edit this line to reserve more/less memory
#SBATCH --nodes=1	### edit this line to reserve different no. of cores
#SBATCH --ntasks=1

module load bedtools

# first line:
# The input example zebrafish genome is provided to -fi
# second line:
# annotation coordinates for mef genes to the -bed flag in .gtf format
# the -fo specifies the output fasta file with all of the mef genes extracted from the input GRCz10, genome.fa file
# NOTE: Note the newest available zebrafish genome at the time of writing is GRCz11
## Anthony Pulvino; 10/24/2022

example_files='/projects/genomicsshare/GCC_scripts/bedtools'

bedtools getfasta -fi $example_files/genome.fa \
-bed $example_files/ZebrafishMef_GRCz10.gtf \
-fo $example_files/ZebrafishMef_GRCz10.fa
