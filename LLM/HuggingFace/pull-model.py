import pandas as pd
# Only if you need this for your calculations. You have to put it in the environment
# if so:
#from sklearn.model_selection import train_test_split

import torch
import numpy as np
from datasets import Dataset, DatasetDict
from transformers import (
    AutoTokenizer,
    AutoModelForSequenceClassification,
    TrainingArguments,
    Trainer
)

# Only if you need this for your calculations. You have to put it in the environment
# if so:
# from sklearn.metrics import precision_recall_fscore_support

model_name = "distilbert-base-uncased" # for speed, can try "bert-base-uncased"  later (TODO)

# distilbert-base-uncased (from Hugging Face) is a distilled version of bert-based-uncased (from Google)
# it's a transformer model, smaller and faster than BERT
# pretrained for masked language modeling
# mostly intended to be fine-tuned on tasks that use the whole sentence to make decisions
# such as sequence classification

# https://huggingface.co/docs/transformers/en/model_doc/auto#transformers.AutoTokenizer
# instantiates a tokenizer
tokenizer = AutoTokenizer.from_pretrained(model_name)

def tokenize_function(examples):
    return tokenizer(
        examples["text"],
        # ensures that all tokenized sentences are of the same length
        # pads shorter sentences with [PAD] token up to max_length
        # [PAD] tokens do not contribute to model predictions because attention masks prevents model from considering it
        # useful because models work more efficiently with uniform input sizes
        padding="max_length",
        # make sure that input sentences longer than max_length are truncated to fit limit
        truncation=True,
        # fixed size for all tokenized inputs
        # 128 for speed, but could try increasing it
        max_length=128
    )
    

# Apply the tokenizer to each split
# applies to batches of inputs rather than one at the time (faster/more efficient)
tokenized_dataset = dataset_dict.map(tokenize_function, batched=True)
