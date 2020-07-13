## Examples

* commandline\_arguments has an example of submitting a Python script with values you set at the command line or in the submission script
* lots\_of\_jobs has an example of using the same Python script with many different parameter combinations

For information about using Python and installing Python packages on Quest, see this KB page: [https://kb.northwestern.edu/page.php?id=78623](https://kb.northwestern.edu/page.php?id=786230)


## Set up Environment
module purge all
module load python-anaconda3
conda create --name slurm-py37-test python=3.7 openmpi-mpicc --yes
source activate slurm-py37-test
pip install mpi4py

## simple
This contains a basic slurm submission file which asks for 1 computer and 1 cpu on that computer

## job-array
This contains an extension of the simple slurm submission file which asks that the same job be repeated 10 times
with the only thing changing is the "job array index", it shows how to access the array number through SLURMS environmental variables

## mpi
This contains an example of how to ask and use the resources of multiple computers through using MPI.

## hybrid openmp MPI
Parallelize across multiple computers using MPI but parallelize within the computer using openMP.
