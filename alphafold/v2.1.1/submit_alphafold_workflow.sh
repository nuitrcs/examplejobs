#!/bin/bash

cpu_job=($(sbatch example_submit_cpu_part.sh))

echo "cpu_job ${cpu_job[-1]}" >> slurm_ids

gpu_job=($(sbatch --dependency=afterok:${cpu_job[-1]} example_submit_gpu_part.sh))

echo "gpu_job ${gpu_job[-1]}" >> slurm_ids
