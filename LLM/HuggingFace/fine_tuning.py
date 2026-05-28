#!/usr/bin/env python
# coding: utf-8

# # Task 3 - Fine Tuning

# For this tasks we will move away from our trustworthy ollama library and use HuggingFace's libraries, since they are more apt for fine tuning. In particular we will rely heavily on *transformers*, *datasets*, and *evaluate*. Note that transformers may have some other dependencies, like pytorch or tensorflow.

# ## Imports

# In[ ]:


# HuggingFace libraries
from transformers import AutoTokenizer, AutoModelForSequenceClassification, TrainingArguments, Trainer, pipeline
from datasets import load_dataset, concatenate_datasets
import evaluate
# import datasets

# Machine learning
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report, roc_curve, auc, precision_recall_curve, average_precision_score

# Misc
import numpy as np
from collections import Counter
# import fsspec

import matplotlib.pyplot as plt


# ## Load Data

# I'll be using the IMDB data from `datasets`. We will only select a small percentage of the whole data. Note that the dataset has all the 0 labels first, so instead of taking the first N samples, we take a randome sample. Luckily, `datasets` loading is "lazy" so it doesn't load everything into memory right away, so we can do the following:

# In[2]:


dataset = load_dataset("imdb", split="train")

neg_dataset = dataset.filter(lambda x: x['label'] == 0).select(range(250))
pos_dataset = dataset.filter(lambda x: x['label'] == 1).select(range(250))


# In[3]:


dataset = concatenate_datasets([neg_dataset, pos_dataset]).shuffle(seed=42)


# In[4]:


print(Counter(dataset["label"]))


# ## Create Model

# First we tokenize the data:

# In[ ]:


# Model name
model_name = "distilbert-base-uncased"

# Tokenize dataset
tokenizer = AutoTokenizer.from_pretrained(model_name)
def preprocess(text_sample):
    return tokenizer(text_sample["text"], truncation=True, padding="max_length", max_length=128)

tokenized_dataset = dataset.map(preprocess, batched=True)


# Now we can create the fine-tuned classification model

# In[21]:


# Create model
model = AutoModelForSequenceClassification.from_pretrained(model_name, num_labels=2)


# Before we train, we define our accuracy metric

# In[7]:


# Define accuracy metric
accuracy = evaluate.load("accuracy")

def compute_metrics(pred):
    preds = np.argmax(pred.predictions, axis=1)
    return accuracy.compute(predictions=preds, references=pred.label_ids)


# And now we create our trainer

# In[27]:


# Training setup
training_args = TrainingArguments(
    output_dir="./test_fine_tuning",
    per_device_train_batch_size=4,
    num_train_epochs=1,
    logging_steps=10,
    save_steps=1000,
    push_to_hub=False,  # disable pushing to HF
    report_to="none",  # disable logging to wandb (weights and biases) and other places - otherwise it asks for API key
    # evaluation_strategy="no", # it's marking as unexpected argument?
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_dataset,
    tokenizer=tokenizer,
    compute_metrics=compute_metrics
)


# And train!!

# In[28]:


# TRAIN
trainer.train()


# ## Evaluate

# For evaluation we need to get the testing dataset and tokenize it.

# In[ ]:


# Load a test split, remember data is not balanced so we need to load and filter
test_dataset = load_dataset("imdb", split="test")

# Filter 250 negative and 250 positive samples
test_neg = test_dataset.filter(lambda x: x['label'] == 0).select(range(250))
test_pos = test_dataset.filter(lambda x: x['label'] == 1).select(range(250))

test_dataset = concatenate_datasets([test_neg, test_pos]).shuffle(seed=42)

# Tokenize
tokenized_test = test_dataset.map(preprocess, batched=True)


# Now we can evaluate!

# In[20]:


# Evaluate
trainer.evaluate(tokenized_test)


# ## Predict

# Now that we have our fine-tuned model, let's predict the label for some example tests.

# In[22]:


# Create a classification pipeline with our model
classif_pipeline = pipeline("text-classification", model=model, tokenizer=tokenizer)


# In[29]:


classif_pipeline("Wow, this is the worst movie I've seen in my entire life")


# In[30]:


classif_pipeline("Wow, this is the best movie I've seen in my entire life")


# In[31]:


classif_pipeline("Wow, I don't know how to feel about it")


# ## Simple viz

# Now let's do some quick visualizations. First, we can visualize the error evolution during training:

# In[32]:


# Training evolution

logs = trainer.state.log_history

loss = [entry['loss'] for entry in logs if 'loss' in entry]
steps = [entry['step'] for entry in logs if 'loss' in entry]

plt.plot(steps, loss)
plt.xlabel("Steps")
plt.ylabel("Training Loss")
plt.title("Loss during Training")
plt.show()


# And now we can plot performance metrics:

# In[33]:


# Evaluation

preds = trainer.predict(tokenized_test)
y_true = preds.label_ids
y_pred = preds.predictions.argmax(axis=1)


# In[ ]:


disp = ConfusionMatrixDisplay.from_predictions(y_true,y_pred, display_labels=["Negative", "Positive"], cmap = 'Greys')


# In[35]:


# ROC
y_scores = preds.predictions[:, 1]  # score for class 1 (positive)
fpr, tpr, thresholds = roc_curve(y_true, y_scores)
roc_auc = auc(fpr, tpr)

plt.figure()
plt.plot(fpr, tpr, label=f"AUC = {roc_auc:.2f}")
plt.plot([0, 1], [0, 1], "k--")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")
plt.title("ROC Curve")
plt.legend(loc="lower right")
plt.show()


# In[36]:


# Precision recall curve

precision, recall, thresholds = precision_recall_curve(y_true, y_scores)
avg_precision = average_precision_score(y_true, y_scores)

plt.plot(recall, precision, label=f"Avg Precision = {avg_precision:.2f}")
plt.xlabel("Recall")
plt.ylabel("Precision")
plt.title("Precision-Recall Curve")
plt.legend()
plt.show()


# In[ ]:




