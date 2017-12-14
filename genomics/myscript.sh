#!/bin/bash
#MSUB -A b1042
#MSUB -q genomics
#MSUB -l walltime=24:00:00
#MSUB -M myemailaddress
#MSUB -j oe
#MSUB -N somename_tophat
#MSUB -l nodes=1:ppn=6
export PATH=$PATH:/projects/pxxxxx/tools/
module load bowtie2/2.2.6
module load tophat/2.1.0
module load samtools
module load boost
module load gcc/4.8.3
module load java
cd $PBS_O_WORKDIR
# Make Directory for FastQC reports in your PI folder in b1042
mkdir /projects/b1042/my_PI/fastqc/reports
19
# Trim poor quality sequence
java -jar <someinput> <someoutput>
# Running FastQC
fastqc -o <other_input> /projects/b1042/my_PI/fasqc/reports/<other_output>