import argparse
import time


def parse_commandline():
    """Parse the arguments given on the command-line.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--job-id",
                       help="Job number",
                       default=0)

    args = parser.parse_args()

    return args


###############################################################################
# BEGIN MAIN FUNCTION
###############################################################################
if __name__ == '__main__':
    args = parse_commandline()
    time.sleep(10) # Sleep for 3 seconds
    print(args.job_id)
