If you want to run a lot of Stata jobs -- for example processing a lot of data files or running many simulations with different parameters -- you may not want to write separate msub commands for each as is done in the examples in the commandline_arguments directory.

This example shows how to read parameter values from a text file (parameters.txt) and send them to your job.  parameters.txt is organized for one line per job you want to run.  Parameter values are separated by spaces.  If you need to send text with spaces in it, surround the value with quotes.

To submit one job per line in parameters.txt using myjob.sh (which expects a variable $PASSEDPARAMS), do:

```bash
while read p || [[ -n $p ]]; do msub -V PASSEDPARAMS=$p myjob.sh; done < parameters.txt
```

The parts of the above command that you might need to change are:
* `PASSEDPARAMS`: this is the name of the variable used in myjob.sh
* `myjob.sh` is the name of the job submission script
* `parameters.txt` is the name of the text file with the parameter values.  Parameter values should be separated by spaces.  Quote text that has spaces in it.  Make sure there's an empty line at the end of the file, or the last line of parameters won't get read because the line isn't complete.

Leave the rest alone.

Note that in this example, we manually entered values in parameters.txt, but there are ways to write loops to generate such a file if you're trying to run all combinations of a few values or a sequence of values for a given parameter.
