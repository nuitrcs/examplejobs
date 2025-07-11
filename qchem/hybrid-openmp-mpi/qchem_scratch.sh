#!/bin/bash
#SBATCH -A <allocation_ID>
#SBATCH -p short
#SBATCH --time=00:10:00
#SBATCH --mem-per-cpu=3G
#SBATCH --nodes=2 ## how many computers do you need
#SBATCH --ntasks-per-node=4 ## how many MPI tasks are running on each computer
#SBATCH --cpus-per-task 4 ## howmany cpus does each MPI task needs to have access to
#SBATCH --job-name="DFT_benzene"
#SBATCH --output=errors.out

module purge all
module load qchem/6.0.2

### Set a path to your scratch directory for this specific job. Make the directory if it doesn't already exist. 
MYTMP=/scratch/$USER/qchem_jobs/${SLURM_JOB_ID}
mkdir -p $MYTMP

### Set the variables for the MPI processing and point qchem to the scratch directory for processing. 
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
export QCSCRATCH=$MYTMP
export QCLOCALSCR=$MYTMP

### Copy the input file into scratch and move to that directory so that QChem can reference all the correct files. 
cp ${SLURM_SUBMIT_DIR}/DFT_benzene.in  $MYTMP/.
cd $MYTMP

### Run the QChem command with parallelization. 
qchem -mpi -nt ${SLURM_CPUS_PER_TASK} -np ${SLURM_NTASKS} DFT_benzene.in results.out

### Copy the results file back to your /projects directory. This way the scratch information can be deleted. 
cp $MYTMP/results.out $SLURM_SUBMIT_DIR/

### Delete the temporary scratch directory. 
rm -rf $MYTMP
