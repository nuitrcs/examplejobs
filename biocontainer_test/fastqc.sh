#!/bin/bash

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=biocontainer
#SBATCH --output=biocontainer.out
#SBATCH --error=biocontainer.err
#SBATCH --time=02:00:00
#SBATCH --mem=30G	### edit this line to reserve more/less memory
#SBATCH --ntasks=8	### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module load singularity

# first line:
# bind the directory containing your fastq files for analysis to your home directory which singularity tries to read from by default
# execute the specific .sif/singularity containing the software you need to run + then run the command like normal

# "fastqc" is then followed by the command specifying number of threads (8), where all the fastq files are located by their extension so$
# the output directory will be where the command is run from. Once you've copied this directory to your working directory in your lab's $
#Anthony Pulvino; 10/24/2022



#modify to be the path to your fastqs
export SEQ_DIR=/projects/genomicsshare/GCC_scripts/biocontainer_test/sequence_read/

singularity run --bind $HOME:$SEQ_DIR \
fastqc:0.11.9.sif fastqc --threads 8 $SEQ_DIR*fastq -o .
