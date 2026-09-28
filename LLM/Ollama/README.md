# Ollama on Quest

Example of running a large language model (LLM) on Quest with [Ollama](https://ollama.com).

For the full walkthrough of these files, including virtual environment setup and where to store downloaded models, see [Using Ollama on Quest](https://rcdsdocs.it.northwestern.edu/tutorials/python/python-llm-ollama.html).

## Files

* `basic_usage.py`: Generates a response from a single prompt, loops over prompts built from a template, and requests structured JSON output validated with Pydantic.
* `submit_ollama_job.sh`: Slurm submission script. Finds a free port, loads the Ollama module, starts the Ollama server, activates your virtual environment, and runs `basic_usage.py`.

## Running the Example

1. Create a virtual environment with the Ollama Python library and Pydantic:

```
module load mamba/24.3.0
mamba create --prefix=/projects/<account_id>/envs/ollama-env -c conda-forge python=3.12
mamba activate /projects/<account_id>/envs/ollama-env
mamba install -c conda-forge ollama-python pydantic
```

2. In `submit_ollama_job.sh`, set `--account` and `--mail-user`, and update the `mamba activate` path to your environment.

3. Submit the job:

```
sbatch submit_ollama_job.sh
```

Results are printed rather than saved, so generated text appears in `output-<jobid>.out`. Ollama server messages go to `serve_ollama_<jobid>.log`.

Models download to your home directory unless you set `OLLAMA_MODELS` to a location in `/scratch` or `/projects`. Home directories are limited to 80 GB and models can be several GB each.

created by efrén cruz cortés.
