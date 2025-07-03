using CUDA

## First check that GPUs are available:
# Check if CUDA is functional
println("CUDA functional? ", CUDA.functional())

# Get the number of available CUDA devices
num_devices = length(CUDA.devices())
println("Num devices : ", num_devices)

# Print the output of CUDA.devices()
println("CUDA.devices : ", CUDA.devices())

# Print the name of device 0
println("Device 0s name : ", CUDA.name(CuDevice(0)))
println()

# Iterate through the devices to get information about each one
for i in 0:(num_devices - 1)
    
    println("Iter : ", i)
    dev = CUDA.CuDevice(i)
    println("Device : ", dev)
    
    ### This weirdly causes a segfault when its in a loop
    ##println("Device ", i, ": ", CUDA.name(dev))

    println("Device memory in GiB : ", CUDA.totalmem(dev)/(1024. ^ 3.))
    println()
end

