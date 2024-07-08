#!/bin/bash
#SBATCH --account=a9009  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=a9009  ### PARTITION (buyin, short, normal, etc)
#SBATCH --gres=gpu:a100:1 ### Optional, only if you plan on utilizing OpenCL GPU accleration
#SBATCH --nodes=1 ## how many computers do you need
#SBATCH --ntasks-per-node=1 ## how many cpus or processors do you need on each computer
#SBATCH --time=00:15:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=10G ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=EMSoft-Test  ## When you run squeue -u NETID this is how you can identify the job
#SBATCH --output=emsoft-test-job.out ## standard out and standard error goes to this file

###
### First verify the settings in your EMSoft config file: ~/.config/EMsoft/EMsoftConfig.json
###
### Make sure that you have choosen values for the input director location
#        "EMXtalFolderpathname": "<absolute-path-to-input>",
### and output directory location appropriately
#        "EMdatapathname": "<absolute-path-to-output>",

###
## Second verify that within the EMsoft run file (i.e. the .nml file) that the locations of the input and output you specify make sense *relative to the absolute paths that you set above
###
#! name of the crystal structure file location relative to EMXtalFolderpathname in the file ~/.config/EMsoft/EMsoftConfig.json
# xtalname = 'changingdw2/mp-237.xtal',
#! output data file name; pathname is relative to EMdatapathname in the file ~/.config/EMsoft/EMsoftConfig.json
# dataname = 'changingdw2/mp-237.h5'

module purge all
module load EMsoft/develop-051324
EMMCOpenCL
