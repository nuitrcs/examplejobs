# Use the argparse library for named parameters: https://docs.python.org/3/library/argparse.html

import argparse

parser = argparse.ArgumentParser(description='Process some command line arguments.')
parser.add_argument('-i', '--intvalue', # name of the option, a short and long version
					type=int, # type of data to require
                    help='an integer') # help text
parser.add_argument('-s', '--stringval', 
					help='a string value')

args = parser.parse_args()
print("Int value +10 = ", args.intvalue+10) # value is already an integer, don't have to convert
print("String value: ", args.stringval)