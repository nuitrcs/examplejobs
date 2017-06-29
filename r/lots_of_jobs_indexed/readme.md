This example runs the same R script 5 times, sending the index of the job to the script.  The file submit.sh creates 5 separate jobs.  

This type of example is useful if you have multiple data files you want to process with the same script (and the file names have sequential index numbers in them), or for simulations or estimation problems where you want to do many different runs of the same script, perhaps with different starting values.

The first time you're running a script like this, keep the number of jobs you're submitting to a small number to make sure everything goes as planned.  If you have hundreds of files to submit, you can modify this script to do that, but test with a smaller number first.

To submit the jobs, run `submit.sh`.  First (just once for the file), make the file executable:

```
chmod u+x submit.sh
```

Then run it:

```
./submit.sh
```

It will print to the console the job numbers as it creates the jobs.