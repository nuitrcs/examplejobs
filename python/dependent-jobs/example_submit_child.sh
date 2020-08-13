#!/bin/bash
module purge all
module load python-anaconda3
source activate /projects/intro/envs/slurm-py37-test

python slurm_test.py --filename=${ARG1}
