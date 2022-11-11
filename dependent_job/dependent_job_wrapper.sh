#!/bin/bash

jid0=$(sbatch --parsable --time=00:10:00 --account=a9009 --partition=a9009 --nodes=1 --ntasks-per-node=1 --mem=8G --job-name=example --output=job_%A.out example_submit.sh)

echo "jid0 ${jid0}" >> slurm_ids

jid1=$(sbatch --parsable --dependency=afterok:${jid0} --time=00:10:00 --account=a9009 --partition=a9009 --nodes=1 --ntasks-per-node=1 --mem=8G --job-name=example --output=job_%A.out --export=DEPENDENTJOB=${jid0} example_submit.sh)

echo "jid1 ${jid1}" >> slurm_ids

jid2=$(sbatch --parsable --dependency=afterok:${jid1} --time=00:10:00 --account=a9009 --partition=a9009 --nodes=1 --ntasks-per-node=1 --mem=8G --job-name=example --output=job_%A.out --export=DEPENDENTJOB=${jid1} example_submit.sh)

echo "jid2 ${jid2}" >> slurm_ids
