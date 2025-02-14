#!/bin/bash
#SBATCH --account=e32559
#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=hisat2_build
#SBATCH --output=hisat2_build.out
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=haleycarter2020@u.northwestern.edu  ## your email

module purge all
module load hisat2/2.1.0

hisat2-build -p $SLURM_NPROCS /projects/e32559/example_data/oenotheraHarringtonii.softmasked.fasta /projects/e32559/example_data/oenotheraHarringtonii.hisat

