# Quest LLMs

Repo with sample templates for running LLMs on Quest.

As of now, the only workable files are:
* create_stories (.py)

More templates to come!

## `create_stories`
This is a sample script which uses the ollama package to run a large language model and generate a series of stories
based on an author's style, a genre, and a topic. This template will help you get started for your own projects. Edit `create_stories.toml` to change some configuration options (model, downsample, etc.).

In order to change how many authors to select from the file, change the downsample_yn variable. If downsample_yn=0, it will loop through all authors. If downsample_yn=1, it will loop through the amount set by variable downsample_quantity.

## Change the location where models are saved
If you would like the models you pull to be saved in a different location than in your home directory (defualt), you can use the following command:

echo "export OLLAMA_MODELS=/scratch/<netID>/path/to/Ollama-Models" >> $HOME/.bashrc

Instead of in Scratch, you can also make this location point to a directory in your /projects/pXXXXX folder.

## Virtual Environment
In order to run this workflow, you will need to create a virtual environment with Ollama and all other packages that your python script requires. Here are some instructions to create the virtual environment that works for this workflow specifically (you will need to change the paths for your work environment):

mamba create --prefix=/projects/p12345/envs/ollama-env python=3.12
mamba activate --prefix=/projects/p12345/envs/ollama-env
pip install ollama libpath toml pandas


## Running the Workflow on Quest
1. In the directory where you want the code to be, clone down the examplejobs repo from github using the command
git clone git@github.com:nuitrcs/examplejobs.git
2. To run the workflow, go into the examplejobs folder, and into the LLM > Ollama folder. Here you will find the submit_create_stories.sh script. Make sure you make the appropriate changes in the resource request and the path to the virtual environment. Make any changes you would like to the create_stories.toml file, and you can run the workflow using the command
sbatch submit_create_stories.sh 

created by efrén cruz cortés and Sophie van Genderen.
