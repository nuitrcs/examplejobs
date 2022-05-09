#!/bin/bash

jid0=($(sbatch --time=00:10:00 --account=w10001 --partition=w10001 --nodes=1 --ntasks-per-node=1 --mem=8G --job-name=example --output=job_%A.out example_submit.sh))

echo "jid0 ${jid0[-1]}" >> slurm_ids

jid1=($(sbatch --dependency=afterok:${jid0[-1]} --time=00:10:00 --account=w10001 --partition=w10001 --nodes=1 --ntasks-per-node=1 --mem=8G --job-name=example --output=job_%A.out --export=DEPENDENTJOB=${jid0[-1]} example_submit.sh))

echo "jid1 ${jid1[-1]}" >> slurm_ids

jid2=($(sbatch --dependency=afterok:${jid1[-1]} --time=00:10:00 --account=w10001 --partition=w10001 --nodes=1 --ntasks-per-node=1 --mem=8G --job-name=example --output=job_%A.out --export=DEPENDENTJOB=${jid1[-1]} example_submit.sh))

echo "jid2 ${jid2[-1]}" >> slurm_ids
