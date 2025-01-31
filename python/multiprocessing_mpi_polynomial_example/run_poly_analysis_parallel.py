## Import packages
import numpy as np
import matplotlib.pyplot as plt
import time
import pandas as pd
import multiprocessing
from multiprocessing import Pool
import os
from poly_fun import noisy_even_polynomial_analysis as noise_poly

## How many tasks (hopefully it is the same as what we got from SLURM)?
print("Number of cpus Python thinks you have : ", multiprocessing.cpu_count())
## How to get the number from SLURM environmental variable?
ncpus = int(os.environ["SLURM_NTASKS_PER_NODE"])
print("Number of cpus you asked for from SLURM : ", ncpus)

## Repeat this analysis a bunch of times (in series)
num_trials = 250000
seeds = range(num_trials)
domain = 10.

## Define a helper function for each parallel worker 
def worker(args):
	## Unpack the arguments
	seed, domain = args
	## Call the function that does the work
	original_coeff, fitted_coeff, noisy_data = noise_poly(seed, domain)
	## Reformat the output
	output = {"seed": seed,"original_coeff": original_coeff,\
	 "fitted_coeff": fitted_coeff,"noisy_data": noisy_data}
	## Return the output
	return output

## Create argument tuples 
arguments = [(seed, domain) for seed in seeds]

# Parallel processing with Pool
start = time.time()
with Pool(ncpus) as pool:  # Use 2 workers
    results = pool.map(worker, arguments)

# Convert results to a Pandas DataFrame
df = pd.DataFrame(results)
end = time.time()

# Display the DataFrame
print(df)

print('execution time (serial) : ', end - start)

## Sanity check
print(type(results))
print(results[0])

## Write number of cores and execution time to a file 
out_dir = "/path/to/output/"
jobid = int(os.environ["SLURM_JOB_ID"])
out_file = f"execution_time_{jobid}.npz"
cpu_n = np.array([ncpus])
exec_time_n = np.array([end-start])
np.savez(out_dir+out_file, arr_0=cpu_n, arr_1=exec_time_n)

