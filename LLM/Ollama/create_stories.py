"""
This is a sample script which uses the ollama package to run a large language model and generate a series of stories
based on an author's style, a genre, and a topic. This template will help you get started for your own projects.

created by efrén cruz cortés and Sophie van Genderen.
"""

# :: IMPORTS ::
import ollama
import pandas as pd
from datetime import datetime
from pathlib import Path
import tomllib
from ollama import Client
import os

# :: LOADS ::

# connect to port
client = Client(
   host="http://localhost:" + os.environ.get("OLLAMA_PORT")
)

# :: LOAD DATA AND SYSTEM MESSAGE ::
# Load parameters and directory info
master_directory = Path("create_stories.toml")
with open(master_directory, "rb") as f:
    config_params = tomllib.load(f)

# Get model's name (change in create_stories.toml if desired)
llm_model = config_params["model"]["llm_model"]
client.pull(llm_model)

# Load system instructions (found in sysm folder. adapt to your case)
sysm_file = Path(config_params["system"]["system_message"])
with open(sysm_file, "r") as f:
    sysm = f.read()

# Format literaty elements
elements_lists = {}
for element, element_file in config_params["literary-elements"].items():
    element_file = Path(f"{element_file}")
    with open(element_file, "r") as f:
        elements_lists[element] = [x.strip() for x in f.readlines()]

# :: DOWNSAMPLE Y/N::
# Only if specified
if config_params["downsampling"]["downsample_yn"]:
    final_elements = {k:v[0:config_params["downsampling"]["donsample_quantity"]] for k,v in elements_lists.items()}
else:
    final_elements = elements_lists

# :: DEFINE GENERATING AND SAVING FUNCTIONS ::
def generate_author_responses(final_elements:dict[list], author:str, sysm:str, llm_model:str):
    responses = []
    for topic in final_elements["topics"]:
            for genre in final_elements["genres"]:
                # Using Ollama. May need to change if using another package.
                response = ollama.generate(
                    model = llm_model,
                    prompt = sysm.format(story_topic = topic, story_genre = genre, story_author = author)
                )
                story = response["response"]
                responses.append({
                    "author": author,
                    "topic": topic,
                    "genre": genre,
                    "story": story + "\n" + "**END**\n"
                })
    responses = pd.DataFrame(responses)
    return responses

def save_per_author(responses_author:pd.DataFrame, author:str, data_directory:Path):
    # Save author responses
    author_file = data_directory / Path(f"response_{author}.csv")
    responses_author.to_csv(author_file, index=False)

def save_all_in_one(responses:pd.DataFrame, data_directory:Path):
    # Appends to csv with all responses. possibly slow bc opening and closing file?
    full_file = data_directory / Path(f"response_all.csv")
    with open(full_file, "a") as f:
        responses.to_csv(f, index = False, header=(f.tell()==0))



# :: GENERATE AND SAVE FILES ::
# Create new data_date folder (if it doesn't exist):
dt = datetime.now().strftime('%Y_%m_%d')
data_directory = Path(f"data_out/data_{dt}")
data_directory.mkdir(exist_ok=True)

# Run it - This loop saves after each generation. Maybe slower, but uses less memory than generating all first.
for author in final_elements["authors"]:
    responses = generate_author_responses(final_elements, author, sysm, llm_model)
    if config_params["saving"]["save_yn"]:
        save_per_author(responses, author, data_directory)
    if config_params["saving"]["save_all_yn"]:
        save_all_in_one(responses, data_directory)

