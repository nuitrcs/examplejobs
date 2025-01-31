import requests
import time
import json
import signal


def generate_text_with_ollama(model_name, prompt):
    url = 'http://localhost:11434/api/generate'
    payload = {
        "model": model_name,
        "prompt": prompt,
        "temperature": 0,
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = requests.post(url, headers=headers,
                             data=json.dumps(payload), stream=True)

    # Handle streaming response
    generated_text = ''
    for line in response.iter_lines():
        if line:
            data = json.loads(line)
            if data.get('done', False):
                break
            else:
                generated_text += data.get('response', '')

    return generated_text.strip()


def main():
    prompts = [
        "Hello world!",
        "Implement a bubble sort in python",
        "Who created the GOPHER protocol?",
        "Who was the first librarian of congress?"
    ]

    for prompt in prompts:
        print(generate_text_with_ollama("mistral", prompt))
