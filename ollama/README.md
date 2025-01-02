# Ollama on Quest Via Singularity

This is a recipe for running Ollama on Quest at Northwestern.

You will need to create a singularity file, as Ollama requires root access. A singularity file to get you started is in `biblatex-singularity.def`. You can build it in the singularity remote builder per their instructions.

`test-ollama.py` is a stripped-down version of the code used in a forthcoming Code4Lib article. It serves as a proof of concept for what you can do with ollama. You can add any additional logic that you may need for your use-case.

`jobscript.sh` is a good script if you need to make about 25,000 prompts to a range of model sizes. You will want at least one A100, and 128 gigabytes of RAM seems to be somewhat optimal.
