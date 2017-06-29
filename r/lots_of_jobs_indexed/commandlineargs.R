## save command line arguments -- reference with the args vector of character data
args <- commandArgs(trailingOnly = TRUE)
n <- as.integer(args[1]) # if you want the value to be numeric instead of char

myFunction<-function(idx) {
	# perhaps read in a data file with the idx in the name
	# read.csv(paste0("mydata",idx,".csv"))
	
	# process the file
	
	# write output
	# write.csv(paste0("myoutputdata",idx,".csv", row.names=FALSE))
}

myFunction(n) ## you don't have to use a function, but if you already happened to have one written...

# other things you need to do with your data