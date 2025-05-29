# Quest LLMs - Fine-Tuning with HuggingFace

Repo with sample templates for fine-tuning  LLMs on Quest.

More templates to come!

## `pull-model`
This is a sample script which uses the HuggingFace package transformers to pull models and then fine-tune them on Quest.

This folder contains a python script as well as a submission script that allows you to pull models from HuggingFace.

## Change the location where models are saved
If you would like the models you pull to be saved in a different location than in your home directory (defualt), you can use the following command:

`echo "export HF_HOME=/scratch/<netID>/path/to/HF/.cache/huggingface/" >> $HOME/.bashrc`

Instead of in Scratch, you can also make this location point to a directory in your /projects/pXXXXX folder. Make sure the quote signs are copied over into Quest correctly.

## Virtual Environment
In order to run this workflow, you will need to create a virtual environment with transformers, unsloth, and all other packages that your python script requires. Here are some instructions to create the virtual environment that works for this workflow specifically (you will need to change the paths for your work environment):

`module load mamba/24.3.0`
`mamba create --prefix=/path/to/envs/huggingface-env python=3.11`
`mamba activate /path/to/envs/huggingface-env`
`mamba install pytorch-cuda=12.1 pytorch nvidia/label/cuda-12.1.0::cuda-toolkit xformers -c pytorch -c nvidia -c xformers`
`pip install unsloth` 


## Running the Workflow on Quest
1. In the directory where you want the code to be, clone down the examplejobs repo from github using the command
git clone git@github.com:nuitrcs/examplejobs.git
2. To run the workflow, go into the examplejobs folder, and into the LLM > HuggingFace folder. Here you will find the submit-model.sh script. Make sure you make the appropriate changes in the resource request and the path to the virtual environment. You can run the workflow using the command
`sbatch submit-model.sh` 

created by efrén cruz cortés, Emilio Lehoucq, and Sophie van Genderen.
