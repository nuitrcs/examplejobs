#!/bin/bash

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=picard
#SBATCH --output=picard.out
#SBATCH --error=picard.err
#SBATCH --time=8:00:00
#SBATCH --mem=15G       ### edit this line to reserve more/less memory
#SBATCH --ntasks=3      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=anthony.pulvino@northwestern.edu

module load samtools/1.10.1
module load java/jdk1.8.0_191
module load picard/2.21.4

# bash loop:
# in this directory there's filenames.txt file that has a list of all unique filename IDs so that the commands in the loop are run on every file we're working with
# first line:
# samtools is used to sort using 3 threads; -o specifies we want output files to be named as specified below; -O ensures we want the output in bam format
# second line: 
# we specify we are looking to collect summary metrics from our alignment output with picard's CollectAlignmentSummaryMetrics tool
# we specify the GRCh38 human genome as our reference
# we specify the input as each of our sorted bams to loop over
# and the output summary metric text files from the command will be output in this directory (make sure you copy to working dir in your lab's projects directory) for every file you loop over with the unique extension/prefix in your filenames.txt file
# Anthony Pulvino; 10/24/2022

export example_files=/projects/genomicsshare/GCC_scripts/picard

cat $example_files/filenames.txt | while read line; do \
        file=$line;
        
        samtools sort -@ 3 $example_files/${file}_aln_pe.bam -o ${file}_aln_pe_sorted.bam -O bam
        
        picard CollectAlignmentSummaryMetrics \
        REFERENCE_SEQUENCE=$example_files/GRCh38_HumanGenome.fa \
        INPUT=$example_files/${file}_aln_pe_sorted.bam \
        OUTPUT=${file}_aln_SumMetrics.txt

done
