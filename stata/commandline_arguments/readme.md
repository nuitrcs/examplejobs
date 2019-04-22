This example shows how to send arguments to a Stata .do file so that you can reuse the same .do file with different parameters (for example, if running simulations or processing similar data files).  The main files are `myjob.sh` and `mycode.do`.  The other files show variants.

`mycode.do` shows an example of referencing the supplied values by number.  `mycode\_named.do` shows an example of naming the supplied values, and `mycode\_variables.do` shows an example of picking the variables for a regression.  `myjob.sh` has the application line and `sbatch` example for `mycode.do`.  For the others:

```
stata-mp -b do mycode_named $ARG1 $ARG2 $ARG3
ARG1=3,ARG2=hello,ARG3=4.5 sbatch myjob.sh
```

```
stata-mp -b do mycode_variables $ARG1 $ARG2 $ARG3
ARG1=acs_k3,ARG2=meals,ARG3=full sbatch myjob.sh
```

In these examples, you are passing in the values to Stata from the sbatch command, but you could also hard code them explicitly into `myjob.sh`.  See `myjob_hardcoded.sh` for an example.