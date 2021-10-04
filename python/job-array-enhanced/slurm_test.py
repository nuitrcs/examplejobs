import argparse
import time


def parse_commandline():
    """Parse the arguments given on the command-line.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input-argument-1",
                       help="Input argument 1")
    parser.add_argument("--input-argument-2",
                       help="Input argument 2")
    parser.add_argument("--input-argument-3",
                       help="Input argument 3")

    args = parser.parse_args()

    return args


###############################################################################
# BEGIN MAIN FUNCTION
###############################################################################
if __name__ == '__main__':
    args = parse_commandline()
    print("I am Input argument 1 {0}".format(args.input_argument_1))
    print("I am Input argument 2 {0}".format(args.input_argument_2))
    print("I am Input argument 3 {0}".format(args.input_argument_3))
