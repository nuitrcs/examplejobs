#!/bin/bash

###########################
###### CPU PROCESS ########
###########################
#Count the number of jobs corresponding to the number of sequences:
baits=`grep ">" baits.fasta | wc -l`
candidates=`grep ">" example_1_sequences_shorter.fasta | wc -l`
count=$(( $baits + $candidates ))
#Run the job array, 100 jobs at a time:
cpu_job_id=($(sbatch --parsable --array=1-$count create_individual_features_SLURM.sh))
echo "cpu_job ${cpu_job_id}" >> slurm_ids

#Count the number of jobs corresponding to the number of sequences:
baits=`grep -c "" baits.txt` #count lines even if the last one has no end of line
candidates=`grep -c "" candidates_shorter.txt` #count lines even if the last one has no end of line
count=$(( $baits * $candidates ))
gpu_job_id=($(sbatch --parsable --dependency=afterok:${cpu_job_id} --array=1-$count run_multimer_jobs_SLURM.sh))
echo "gpu_job ${gpu_job_id}" >> slurm_ids
