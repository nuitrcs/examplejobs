args var1 var2 var3
use http://stats.idre.ucla.edu/stat/stata/webbooks/reg/elemapi
regress api00 `var1' `var2' `var3' //get the variable names to use from the arguments

/*  
Note that while this example takes the variable names in as arguments, the number of variables being used is set.  If you want to pass different numbers of variable names, you'll need to do some more advanced Stata programming to parse or execute the string value you pass in. 
*/