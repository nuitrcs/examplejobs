import multiprocessing
from multiprocessing import Pool
import argparse
import time

def parse_commandline():
    """Parse the arguments given on the command-line.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--nproc",
                        help="Job number",
                        type=int,
                        default=1)

    args = parser.parse_args()

    return args

def f(x):
    return x*x

###############################################################################
# BEGIN MAIN FUNCTION
###############################################################################
if __name__ == '__main__':
    args = parse_commandline()
    print("Number of cpus Python thinks you have : ", multiprocessing.cpu_count())
    with Pool(args.nproc) as p:
        print(p.map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
