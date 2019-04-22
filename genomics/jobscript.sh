#!/bin/bash
#SBATCH -A b1042
#SBATCH --partition=genomics
#SBATCH --time=24:00:00
#SBATCH --mail-user=myemailaddress
#SBATCH --output=<combined out and err file path>
#SBATCH -J somename_tophat
#SBATCH --nodes=<count>
#SBATCH -n <core count>

# unload modules that may have been loaded when job was submitted
module purge all

export PATH=$PATH:/projects/pxxxxx/tools/
module load bowtie2/2.2.6
module load tophat/2.1.0
module load samtools
module load boost
module load gcc/4.8.3
module load java

# Make Directory for FastQC reports in your PI folder in b1042
mkdir /projects/b1042/my_PI/fastqc/reports

# Trim poor quality sequence
java -jar <someinput> <someoutput>
# Running FastQC
fastqc -o <other_input> /projects/b1042/my_PI/fasqc/reports/<other_output>