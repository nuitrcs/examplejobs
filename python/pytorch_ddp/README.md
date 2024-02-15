# Create the virtual environment
module purge
module load mamba/23.1.0
CONDA_OVERRIDE_CUDA="12" mamba create --prefix=/projects/a9009/sbc538/workshops/Sampling-of-GPU-Applications/pytorch/gpu-env --channel conda-forge tensorflow pytorch
