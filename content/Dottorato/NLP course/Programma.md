### Lecture 1 (29/2/2024, 2h): Introduction

Introduction to the course. Introduction to Natural Language Processing: **understanding** and **generation**. What is NLP? The **Turing Test**, criticisms and alternatives. Tasks in NLP and its importance (with examples). Key areas and publication venues.

### Lecture 2 (01/03/2024, 4h): Machine Learning for NLP and Logistic Regression

Basics of Machine Learning for NLP. Probabilistic classification. Logistic Regression and its use for classification. Explicit vs. implicit features. The cross-entropy loss function.

### Lecture 3 (07/03/2024, 2h): Supervised vs. unsupervised vs. reinforcement learning. PyTorch

Introduction to Supervised, Unsupervised & Reinforcement Learning. The Supervised Learning framework. From real to computational: features extraction and features vectors. Feature Engineering and inferred features. PyTorch. Introduction to Colab notebooks and first part of the PyTorch hands-on.
### Lecture 4 (08/03/2024, 4h): first hands-on with PyTorch with language detection

Recap of the Supervised Learning framework, hands on practice with **PyTorch** on the Language Detection Model: tensors, gradient tracking, the **Dataset** and **DataLoader** class, the **Module** class, the backward step, the training loop, evaluating a model.

### Lecture 5 (14/03/2024, 2h): Word embeddings, word2vec

Word representations. Word embeddings. Word2vec (CBOW and skipgram), PyTorch notebook on word2vec.

### Lecture 6 (15/03/2024, 4h): Negative sampling, homework 1 assignment

**Negative sampling**: the skipgram case; changes in the loss function. **Homework 1 assignment**.

### Lecture 7 (21/03/2024, 2h): Word2vec notebook

PyTorch **notebook on word2vec**. More on **homework 1.**

### Lecture 8 (22/03/2024, 4h): introduction to language modeling

Negative sampling in the word2vec notebook. What is a language model? **N-gram models** (unigrams, bigrams, trigrams), together with their probability modeling and issues. Chain rule and n-gram estimation. Static vs. contextualized embeddings. Introduction to Recurrent Neural Networks.

### Lecture 9 (04/04/2024, 2h): RNNs and Long-Short Term Memory Networks

Recurrent Neural Networks. Issues. Long-Short Term Memory Networks.

### Lecture 10 (05/04/2024, 4h): notebooks on real-world reviewing example, training in NLP, hyperparameters, LSTMs

Notebooks on real-world review classification example, Part-of-Speech tagging brief introduction, LSTMs recap, Notebook on Part-of-Speech Tagging with LSTMs, data preprocessing and training procedure best practices.

### Lecture 11 (11/04/2024, 2h): the attention mechanism

Neural language modeling. Context2vec. Neural language models with BiLSTMs. Contextualized word representations. Introduction to the attention.

### Lecture 12 (12/04/2024, 3.5h): the Transformer

Introduction to the **Transformer** architecture. Encoder, decoder. Positional embeddings. Self-attention. Cross-attention. Decoding. Introduction to homework 1b.

### Lecture 13 (18/04/2024, 2h, S): Pre-trained language models

Pre-trained language models: BERT, GPT, RoBERTa, XLM.

### Lecture 14 (19/04/2024, 4h, TAs): homework 1b

 Introduction to homework 1b. In-class lab for the homework
### Lecture 15 (02/05/2024, 2 hours): the Transformer notebook

Practical session on the Transformer with BERT.

### Lecture 16 (03/05/2024, 4h): Contextualized word embeddings, NER, introduction to semantics, NER in the Transformer notebook

Contextualized word embeddings. Introduction to Word Sense Disambiguation (WSD). Named Entity Recognition. Connection to WSD. NER in the Transformer Notebook.

### Lecture 17 (09/05/2024, 2h): Introduction to semantics, Word Sense Disambiguation, WordNet

Introduction to lexical and sentence-level semantics. Lexical-semantic knowledge resources. More on [WordNet](https://wordnet.princeton.edu/) and its structure. The notion of synset. Lexical and semantic relations. Multilingual lexical-semantic knowledge graphs. [BabelNet](https://babelnet.org/): motivation, creation, organization.

### Lecture 18 (10/05/2024, 4h): Introduction to Large Language Models

 What is a Large Language Model? What are its ingredients? Transfer learning. Fine-tuning. Instruction tuning. Prompting and prompt engineering.
### Lecture 19 (16/05/2024, E): The Hitchhiker's Guide to Models' Evaluation

 How to evaluate a Language Model? And an LLM? Which datasets and measures to use?
### Lecture 20 (17/05/2024, 4h): Sense embeddings, Semantic Role Labeling, Homework 2 presentation on Natural Language Inference

Static and contextualized sense embeddings: SensEmbed, NASARI, SensEmBERT. Introduction to Semantic Role Labeling: resources and approaches. Presentation of homework 2 on Natural Language Inference.

### Lecture 21 (23/05/2024, 2h): WordNet notebook + hints for homework 2

How to use WordNet with NLTK. Useful relations in WordNet for homework 2: antonymy, hypernymy, hyponymy, meronymy, entailment, etc. Potential uses of Semantic Role Labeling outputs for homework 2.

### Lecture 22 (24/05/2024, R+P): Introduction to Entity Linking and Relation Extraction

 Introduction to Entity Linking. Datasets, approaches. NER+ED. ExtEnD. BLINK. GENRE. EntQA. ReLiK. Introduction to Relation Extraction. Generative RE. REBEL. ReLiK (again!).

### Lecture 23 (30/05/2024, Sc): Introduction to Text Summarization

Text Summarization. Datasets, approaches. **Extractive** vs. **abstractive** summarization. Evaluation. ROUGE and its limitations. Factuality evaluation of summarization.

### Lecture 24 (31/05/2024, 4h): Machine Translation and closing

Foundations of sequence-to-sequence models and their use within Huggingface.

Introduction to machine translation (MT) and history of MT. Overview of statistical MT. **Beam search** for decoding. Introduction to **neural machine translation: the encoder-decoder** neural architecture. The BLEU evaluation score. Performances and recent improvements. **Neural MT:** the **encoder-decoder** architecture; **Attention** in NMT.