#!/bin/bash
#SBATCH --mail-type=ALL ## you can receive e-mail alerts from SLURM when your job begins and when your job finishes (completed, failed, etc)
#SBATCH --mail-user=email@u.northwestern.edu ## your email

if [[ -z "${DEPENDENTJOB}" ]]; then
    echo "First job in workflow"
else
    echo "Job started after " $DEPENDENTJOB
fi

module purge all
module load python-anaconda3
source activate /projects/intro/envs/slurm-py37-test

python --version
python slurm_test.py
