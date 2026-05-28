import os
import math
import numpy as np
from random import random, seed
import multiprocessing
from multiprocessing import Pool
import time
import sys

def simulate_count_inside(args) -> int:
    """
    Draw n_samples points uniformly in the square [-1, 1] x [-1, 1]
    and count how many fall inside the unit circle.
    """
    # process args 
    n_points,  my_seed = args
    my_seed = int(my_seed)

    #print('npoints', n_points)
    #print('seed', my_seed, type(my_seed))

    # vary the seed per process, takes as an argument
    seed(my_seed)

    inside = 0
    for _ in range(n_points):
        x = random() * 2.0 - 1.0
        y = random() * 2.0 - 1.0
        if x * x + y * y <= 1.0:
            inside += 1
    return inside

if __name__ == "__main__":
    
    ## Take number from command line 
    run_id = sys.argv[1]
    data_dir = sys.argv[2]
    print("Job run id : ", run_id)

    ## slurm jobid
    slurm_jobid = int(os.environ["SLURM_JOB_ID"])
    print('Slurm Jobid : ', slurm_jobid)

    ## ncpus from multiprocessing
    ncpus_multiprocessing = multiprocessing.cpu_count()
    print("Number of cpus Python thinks you have : ", ncpus_multiprocessing)
    ## ncpus from SLURM environmental variable?
    ncpus_slurm = int(os.environ["SLURM_NTASKS_PER_NODE"])
    print("Number of cpus you asked for from SLURM : ", ncpus_slurm)
    ncpus = ncpus_slurm

    ## duplicates, seeds, sizes of trials 
    ## Note: varying the variables duplicates, points_per_duplicate, and 
    ## parallel pool chunksize effects the parllel efficiency. 
    duplicates = 4096
    my_seeds = np.arange(duplicates) + 12 
    points_per_duplicate = 2_000_000
    n = duplicates * points_per_duplicate

    # Create the work list: one integer per partition, telling the worker
    # how many samples to simulate in that partition
    args = [(points_per_duplicate, s) for s in my_seeds]

    st = time.time()
    # Parallel execution
    with Pool(processes=ncpus) as pool:
        # imap_unordered streams results back as they complete
        partial_counts = pool.imap_unordered(simulate_count_inside, args, chunksize = 500)
        total_inside = sum(partial_counts)
    en = time.time()

    pi_estimate = 4.0 * total_inside / n
    print(f"Pi is roughly {pi_estimate:.6f}")
      
    elapsed = en-st
    print("Elapsed : ",  elapsed)
    
    out_arr = np.array([[slurm_jobid,ncpus,elapsed]])

    file_name = f"pi_parallel_out-ncpus{ncpus}-run_id{run_id}.csv"
    
    np.savetxt(data_dir+"/"+file_name, out_arr, fmt=['%d','%d','%f'], delimiter=',', header='slurm_jobid,ncpus,elapsed')

    print("Done")


