## Code to run a simple python scaling study on Quest


## submit_jobs.sh -- helper bash script that submits the jobs to run 
## submit_script_specify_cores.sh -- submission script called by submit_jobs.sh
## py_test_multiprocessing.py -- python script that approximates the number pi 
##                               with parallel processing 
## plot_scaling_study.ipynb -- ipython notebook that plots the runtime and
##                             parallel speedup information from the python jobs


## This code requires a virtual environment to run, which can be created with the
## following command:
mamba create -n parallel_python_env -c conda-forge python=3.12 \
 pandas matplotlib seaborn numpy ipykernel jupyter

## The ipython notebook requires a kernel to be created from the
## virtual environment:
mamba activate parallel_python_env
python -m ipykernel install --user --name parallel_python_env \
 --display-name "Python (parallel_python_env)"

## See this page for more information about virtual environments and ipython
## kernels on Quest:
## https://rcdsdocs.it.northwestern.edu/tutorials/software-management/conda-mamba-quest/mamba-conda-quest.html#mamba-or-conda-virtual-environments

## NOTE: please review the scripts and change any necessary paths or configurations 
## before running it. 

