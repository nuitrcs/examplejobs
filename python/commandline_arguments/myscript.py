import sys

## reference values with sys.argv; the first (0 index) item is the script name

print(sys.argv[2])

## arguments are passed as strings -- convert to numbers as needed
print("Passed value +10 = ", int(sys.argv[1])+10)