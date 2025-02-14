#!/bin/bash
#SBATCH --account=e32559
#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=hisat2_align
#SBATCH --output=hisat2.out
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=haleycarter2020@u.northwestern.edu  ## your email

module purge all
module load hisat2/2.1.0

hisat2 --dta -q \
    -x /projects/e32559/example_data/oenotheraHarringtonii.hisat \
    -1 /projects/e32559/example_data/SRR7773980_1.fastq.gz \
    -2 /projects/e32559/example_data/SRR7773980_2.fastq.gz \
    -S SRR7773980.sam
