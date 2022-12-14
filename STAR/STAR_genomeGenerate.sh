#!/bin/bash 

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=STAR_mkdb
#SBATCH --output=STAR_mkdb.out 
#SBATCH --error=STAR_mkdb.err 
#SBATCH --time=20:00:00 
#SBATCH --mem=35G       ### edit this line to reserve more/less memory
#SBATCH --ntasks=1      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module load STAR/2.7.9a

# first line:
# we use STAR calling it with the run mode genomeGenerate so we can use the program to create an alignment database for later alignment (see STAR docs for how to write the alignment command)
# we run the command on 1 thread
# we specify the genome.fa GRCz10 zebrafish genome
# we specify the corresponding annotation genes.gtf
# we specify 49 to sjdbOverhang -- min read length -1
# length (bases) of the SA pre-indexing string. Typically between 10 and 15. See STAR manual for details on smaller genomes.
# STAR MANUAL: https://physiology.med.cornell.edu/faculty/skrabanek/lab/angsd/lecture_notes/STARmanual.pdf

#Anthony Pulvino; 10/24/2022

export example_files=/projects/genomicsshare/GCC_scripts/STAR

STAR --runMode genomeGenerate \
--runThreadN 1 \
--genomeDir . \
--genomeFastaFiles $example_files/genome.fa \
--sjdbGTFfile $example_files/genes.gtf \
--sjdbOverhang 49 \
--genomeSAindexNbases 10
