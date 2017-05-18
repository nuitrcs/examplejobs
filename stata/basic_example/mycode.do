use http://stats.idre.ucla.edu/stat/stata/webbooks/reg/elemapi

export excel using "mydata", firstrow(variables) //will write mydata.xls

regress api00 acs_k3 meals full 
ssc install outreg2
outreg2 using regresults // will write file regresults.doc

correlate acs_k3 api00
return list

putexcel set corrresults //will write corrresults.xls
putexcel A1=matrix(r(C)), names 