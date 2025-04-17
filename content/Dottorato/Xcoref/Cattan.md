## Gli embedding dei documenti sono generati in base al contesto ottenuto anche dagli altri documenti?

```python
docs_embeddings, docs_length = pad_and_read_bert(data.topics_bert_tokens[topic_num], bert_model)
```

pad_and_read_bert genera gli embedding dei documenti

```python
def pad_and_read_bert(bert_token_ids, bert_model):
	length = np.array([len(d) for d in bert_token_ids])
	max_length = max(length)  
	
	if max_length > 512:		
		raise ValueError('Error! Segment too long!')
	
	device = bert_model.device	
	docs = torch.tensor([doc + [0] * (max_length - len(doc)) for doc in bert_token_ids], device=device)
	attention_masks = torch.tensor([[1] * len(doc) + [0] * (max_length - len(doc)) for doc in bert_token_ids], device=device)
	
	with torch.no_grad():
		embeddings, _ = bert_model(docs, attention_masks)

return embeddings, length
```

i documenti sono messi in un batch tutti insieme. Dopo di che vengono passati a bert:

```python
docs = torch.tensor([doc + [0] * (max_length - len(doc)) for doc in bert_token_ids], device=device)

[...]

embeddings, _ = bert_model(docs, attention_masks)
```

In teoria questo non significa che gli embedding dei documenti siano stati generati in contesto con gli altri come se fosse un unico testo.

Dopo di che vengono estratti i candidate

```python
span_meta_data, span_embeddings, num_of_tokens = get_all_candidate_from_topic(config, data, topic_num, docs_embeddings, docs_length)
```

span_embeddings è una tupla composta da 

```
start_end_embeddings, continuous_embeddings, width = span_embeddings
```
### continuous embeddings is a list of 11672 tensors. This number is actually the whole number of mentions across all documents in the topic

The span are fed to span_repr which turns them into usable embeddings.
```
span_emb = span_repr(start_end_embeddings, continuous_embeddings, width)

span_emb.shape
torch.Size([11672, 3092])
```

span scores are computed
```
span_scores = span_scorer(span_emb)

span_scores.shape
torch.Size([11672, 1])
```

In base agli scores viene deciso chi è una mention e chi no.

