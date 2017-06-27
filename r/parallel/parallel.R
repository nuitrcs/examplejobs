library(parallel)
## We've set environment variable MC_CORES in the submission script, 
## but could set it in a function call
print("Detecting cores")
print(detectCores())
print("Checking environment variable MC_CORES")
print(Sys.getenv("MC_CORES") )
print("-------------")


## Make some data
data <- data.frame(x=runif(500), y=rnorm(500))

## Run kmean with 100 starts total, split among 4 processes
parallel.function <- function(i) {
  kmeans( data, centers=4, nstart=i )
}

results <- mclapply( c(25, 25, 25, 25), FUN=parallel.function )
# results <- mclapply( c(25, 25, 25, 25), FUN=parallel.function, mc.cores=3) # could set number of additional processes to use here; remember to keep it 1 less than cores requested

temp.vector <- sapply( results, function(result) { result$tot.withinss } )
result <- results[[which.min(temp.vector)]]

print(result)


## parallelization example where the results might be easier to see:

## first, without parallelization
print("\n\nTiming Example\n---------------\nRun without parallelization")
t1<-Sys.time()
lapply(1:3, FUN=function(i){runif(100); Sys.sleep(10)} )
print(Sys.time()-t1)

## then run in parallel
print("Run with parallelization")
t1<-Sys.time()
mclapply(1:3, FUN=function(i){runif(100); Sys.sleep(10)} )
print(Sys.time()-t1)

