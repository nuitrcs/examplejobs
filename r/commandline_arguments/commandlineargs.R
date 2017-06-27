library(dplyr) ## an example, not used below; install packages ahead of time in your account

## save command line arguments -- reference with the args vector of character data
args <- commandArgs(trailingOnly = TRUE)
n <- as.integer(args[2])+1

## write file, using arguments for filename
fileConn<-file(paste0(args[1],".txt"))
writeLines(c(paste(args[1], n)), fileConn)
close(fileConn)

cat("Test output") # this will direct to stdout, which will go to an output file generated as part of the job submission


## make and save a plot as pdf
pdf() ## with no file specified, will default to Rplots.pdf in working directory
plot(1:5,1:5)
dev.off()

## because the above runs quickly, sleep a bit so you can see the process running if you want;
## not necessary, but useful for showing use of job management commands
# Sys.sleep(60)