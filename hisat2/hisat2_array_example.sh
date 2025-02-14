#!/bin/bash
#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --array=2-63
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name="hisat2_\${SLURM_ARRAY_TASK_ID}"
#SBATCH --output=hisat2.%A_%a.out ## use the jobid (A) and the specific job index (a) to name your log file
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=haleycarter2020@u.northwestern.edu  ## your email

module purge all
module load singularity/3.8.1

IFS=$'\n' read -d '' -r -a lines < /projects/p32300/rna-seq/list_of_files.txt

singularity exec -B /projects /projects/b1042/Carter/hisat2:2.2.1--py38he1b5a44_0 \
  hisat2 --dta -q \
    -x /projects/b1042/easel_oenotheraHarringtonii_20240708/02_index/hisat2/hisat2.index/hisat2 \
    -1 /projects/b1042/Carter/fastp/${lines[$SLURM_ARRAY_TASK_ID]}_fastp_1.fastq.gz \
    -2 /projects/b1042/Carter/fastp/${lines[$SLURM_ARRAY_TASK_ID]}_fastp_2.fastq.gz \
    -S /projects/b1042/Carter/hisat2/${lines[$SLURM_ARRAY_TASK_ID]}.sam
