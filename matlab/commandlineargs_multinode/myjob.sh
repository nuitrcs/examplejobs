#!/bin/bash

module load matlab/r2016a
# script1 is your .m file without the extension; mylogfile.txt will be created
matlab -nosplash -nodesktop -singleCompThread -r "numiter=36;script1" > mylogfile.txt &
exit