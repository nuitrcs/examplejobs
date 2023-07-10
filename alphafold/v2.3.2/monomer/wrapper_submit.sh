#!/bin/bash
cpu_job_id=($(sbatch --parsable CPU_part.sh))
echo "cpu_job ${cpu_job_id}" >> slurm_ids
gpu_job_id=($(sbatch --parsable --dependency=afterok:${cpu_job_id} GPU_part.sh))
echo "gpu_job ${gpu_job_id}" >> slurm_ids
