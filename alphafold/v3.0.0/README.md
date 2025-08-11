# AlphaFold 3.0.0
## Running AlphaFold
Whenever possible it’s recommended to split the CPU and GPU workloads for AlphaFold. This helps with resource optimization and ensuring your workflow completes in the most efficient way.

The AlphaFold3 module provides 3 functions: af3_cpu, af3_gpu, and af3_full

The examples below can also be found on the [AlphaFold3 GitHub example](https://github.com/nuitrcs/examplejobs/tree/master/alphafold/v3.0.0) and show how to run an example workflow in the CPU and GPU steps.

The [AlphaFold3 site](https://github.com/google-deepmind/alphafold3/tree/main) also provides a fold_input.json as an example of how to format the input for the application.

```
{
  "name": "2PV7",
  "sequences": [
    {
      "protein": {
        "id": ["A", "B"],
        "sequence": "GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG"
      }
    }
  ],
  "modelSeeds": [1],
  "dialect": "alphafold3",
  "version": 1
}
```

Using this input file, you can run the cpu only data pipeline with the command below. The data pipeline is the first step in the Alphafold3 simulations and completes the genetic and template search for the input data.

af3_cpu --model_dir=/path/to/model/parameters \
    --output_dir=$(pwd)/output \
    --json_path=$(pwd)/fold_input.json
If the application launches successfully, you’ll see information about the start of the simulation and how long each iteration took to complete in the log file for the batch job.

Once the CPU portion completes, you can update the paths to run the GPU portion of AlphaFold3. This is the inference part of the simulation. It takes the output of the previous CPU step as input for the inference.

af3_gpu --model_dir=/path/to/model/parameters \
    --output_dir=$(pwd)/output/ \
    --json_path=$(pwd)/output/2pv7/2pv7_data.json
After the GPU inference is completed, you should see similar information about the application’s setup and simulation times in the log file. All of the output for the CPU and GPU steps of the simulation can be found in the --output_dir as specified by you.