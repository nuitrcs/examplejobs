## Most of this is from the example 
## Example of Parameter-Parallelism with GPU Ensemble Methods
## from here: 
## https://juliapackages.com/p/diffeqgpu

using DiffEqGPU, CUDA, OrdinaryDiffEq, StaticArrays

#####################

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

#####################

## Then do DE stuff:
function lorenz(u, p, t)
    σ = p[1]
    ρ = p[2]
    β = p[3]
    du1 = σ * (u[2] - u[1])
    du2 = u[1] * (ρ - u[3]) - u[2]
    du3 = u[1] * u[2] - β * u[3]
    return SVector{3}(du1, du2, du3)
end

u0 = @SVector [1.0f0; 0.0f0; 0.0f0]
tspan = (0.0f0, 10.0f0)
p = @SVector [10.0f0, 28.0f0, 8 / 3.0f0]
prob = ODEProblem{false}(lorenz, u0, tspan, p)
prob_func = (prob, i, repeat) -> remake(prob, p = (@SVector rand(Float32, 3)) .* p)
monteprob = EnsembleProblem(prob, prob_func = prob_func, safetycopy = false)

@time sol = solve(monteprob, GPUTsit5(), EnsembleGPUKernel(CUDA.CUDABackend()),
    trajectories = 10_000, adaptive = false, dt = 0.1f0)

#####################

