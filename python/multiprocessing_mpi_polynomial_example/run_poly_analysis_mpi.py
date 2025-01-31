## Import packages
import numpy as np
import pandas as pd
import os
from mpi4py import MPI
from poly_fun import noisy_even_polynomial_analysis as noise_poly

## Initialize MPI
comm = MPI.COMM_WORLD
rank = comm.Get_rank()  # worker (process) ID
size = comm.Get_size()  # Total number of workers (processes)

## Define the number of trials for each worker (process) to do,
## as well as seeds for that worker (process)
num_trials_per_rank = 5
seeds_for_rank = np.arange(rank * num_trials_per_rank, (rank + 1) * num_trials_per_rank)
domain = 10.

## Print a message from the worker (process)
print(f"Hey, its process {rank} of {size}. I have seeds {np.min(seeds_for_rank)} through {np.max(seeds_for_rank)}")

## Each worker (process) does its own trials independently 
#### Function signature is : 
#### coefficients, fitted_coefficients, y_noisy = 
#### noisy_even_polynomial_analysis(rand_seed, sym_domain, print_statements=False, plots=False)

## Create a helper function to return the seed as well
def poly_engine(seed, domain):
	original_coeff, fitted_coeff, noisy_data = noise_poly(seed, domain)
	## Format the output
	output = {"seed": seed,"original_coeff": original_coeff,\
	 "fitted_coeff": fitted_coeff,"noisy_data": noisy_data}
	## Return the output
	return output

## Do the work 
results = [poly_engine(seed, domain) for seed in seeds_for_rank]

## Every rank calls comm.gather with the data it wants to 
## send to the root worker (process)
all_results = comm.gather(results, root=0)

## If youre rank 0, save the results and print some stuff 
if rank == 0:

	print("\nProcess 0 is collecting and flattening the results.")
	flat_results = [item for result in all_results for item in result]

	# Convert results to a Pandas DataFrame
	df = pd.DataFrame(flat_results)

	# Display the DataFrame
	print(df)
	first_row = df.loc[0, ['seed', 'original_coeff', 'fitted_coeff']]
	print(first_row)

	print('done.')



