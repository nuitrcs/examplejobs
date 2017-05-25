This example shows how to send arguments to a Python script so that you can reuse the same .py file with different parameters (for example, if running simulations or processing similar data files).  The main files are myjob.sh and myscript.py.  The other files show variants.

myscript.py shows an example of referencing the supplied values by number/position.  myscript\_named.py (which goes with myjob\_named.py) shows an example of naming the supplied values.  

To submit myjob.sh or myjob\_named.sh (change the .sh filename as appropriate): 

```
msub -V ARG1=3,ARG2=hello myjob.sh
```

In these examples, you are passing in the values to Python from the msub command, but you could also hard code them explicitly into myjob.sh.  


