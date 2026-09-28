"""
Basic usage guide for the Ollama Python library.

This script demonstrates how to:
1. Generate simple text responses using a single model and prompt.
2. Iterate/loop over multiple prompts using templates.
3. Obtain structured JSON outputs validated via Pydantic models.
"""

# ==============================================================================
# IMPORTS
# ==============================================================================

# You will need the ollama python library
from ollama import Client

# Optionally, but recommended, you will need some imports from pydantic
from pydantic import BaseModel, ValidationError

# Other imports
import os

# ==============================================================================
# Ollama SETUP
# ==============================================================================
llm_name = "llama3.1"

client = Client(
   host="http://localhost:" + os.environ.get("OLLAMA_PORT")
)

# Download model if not available already
client.pull(llm_name)


# ==============================================================================
# THE BASICS IN ONE LINE
# ==============================================================================

# To generate a response you must provide:
#
# * A model. If you have already downloaded the model, it will be saved in your computer, 
#   otherwise the process may take a bit as it downloads the requested model.
# * A prompt. This is your standard message to the model. You can provide general 
#   behavior instructions as well as specific tasks.
#
# And with that, you only need one line of code!

print("--- Running Basic Generation ---")

gen_answer = client.generate(
    model=llm_name,
    prompt='Tell me the story of Koko the gorilla in two limericks'
)

# If you print the response as is, you will notice it has extra data you may not always need:
print("\n\nRaw response:")
print(gen_answer)

# If you're interested only in the text response, you'll need to access the `response` field:
print("\n\nText response field:")
print(gen_answer.response)


# ==============================================================================
# LOOPING OVER PROMPTS
# ==============================================================================

# Often, you will want to call the LLM on a variety of prompts (patient interviews, 
# literary texts, etc.). Let's simulate a simple scenario that accomplishes this:

print("--- Running Looping Prompts ---")

# We first create a template base prompt
base_prompt = "Write a 10-line absurdist play about <<SUBJECT>>."

# We indicate the values we want to iterate over
subjects = [
    'pretentious and scholarly platypuses',
    'the greatest marbles tournament in the world',
    'a heated discussion about tea: should milk be poured first or last?'
]

# This is how your prompts will look, using the `.replace` string method
print("Constructed prompts:")
for subj in subjects:
    print(base_prompt.replace('<<SUBJECT>>', subj))

# In reality you'll determine the variable prompt at the time of generation:
print("\n\nGenerating responses...")
gen_answers = []
for subj in subjects:
    answer = client.generate(model=llm_name, prompt=base_prompt.replace('<<SUBJECT>>', subj))
    gen_answers.append(answer)

# And now we can look at the results
print("Results:")
for answer in gen_answers:
    print(answer.response)
    print("\n ======= \n")


# ==============================================================================
# STRUCTURED OUTPUT
# ==============================================================================

# Finally, you're able to constrain your output so that it follows a specific structure. 
# This is very useful when extracting qualitative data from text.

# First we need to define a simple pydantic class, indicating the data types for your fields:
class PoemEvaluation(BaseModel):
    rating: float
    haiku: int
    rationale: str


print("--- Running Structured Output ---")

# We provide our created class in the `format` field
gen_answer = client.generate(
    model=llm_name,
    prompt='''
        Please evaluate the poem below, you must reply in JSON format. The fields of your reply are:
        - rating (a rating from 0-10 of how good the poem is)
        - haiku (a binary 0/1, indicating if it is a haiku or not)
        - rationale (an explanation of why you have provided such rating)

        Poem:
        Scattered light's gentle dance
        Dancing waves of azure hue
        Blue heaven's wondrous peace
        ''',
    format=PoemEvaluation.model_json_schema()
)

print("Raw response from LLM (JSON format):")
print(gen_answer.response)

# LLMs are not perfect, and their output may not always be the correct data type. 
# Luckily you can validate the output format, for this we import ValidationError from pydantic.
#
# In this case, it will check that "rating" is indeed a float, "haiku" an int, and "rationale" a str.
try:
    valid_response = PoemEvaluation.model_validate_json(gen_answer.response)
    print("\n\nValidated Pydantic model response:")
    print(valid_response)
except ValidationError as e:
    print(f"Not a valid output format: {e}")

# Note how easy it is to extract the rating:
print("\n\nExtracted Rating:")
print(valid_response.rating)