## Who's Ada Lovelace?

Prima fase tokenizzazione:

>[!la pipeline completa]-
>
>
![[Pasted image 20240311171821.png]]

```python
from transformers import AutoTokenizer

model_name = "TinyLlama/TinyLlama-1.1B-Chat-v1.0"
tokenizer = AutoTokenizer.from_pretrained(model_name)
```

Praticamente posso caricare automaticamente un tokenizzatore di default per quel modello (sempre grazie ad huggingface). Quando carichi un modello su huggingface, puoi caricare un file di configurazione json che sostanzialmente specifica il tokenizzatore.


```python
prompt = "Who is Ada Lovelace?"
encoded_prompt= tokenizer.encode(prompt)
```

output:

```
prompt: Who is Ada Lovelace?
encoded: [1,11644,338,23255,23974,295,815,29973]
```

![[Pasted image 20240311213255.png]]

>[!Nota]-
>```
prompt: Who is Ada Lovelace?
encoded: [1,11644,338,23255,23974,295,815,29973]
>```
>nota che i numeri del vettore encoded sono più delle parole. Questo è dovuto al fatto che nel vocabolario non ci sono parole come "Lovelace" e che quindi vengono codificate con più tokens
>23974:Lov
>295:el
>815:ace
>
>Questo tipo di idea è il cosidetto "subword tokenizer"



Tutta questa fase. è ancora fuori dal Modello di linguaggio, ma deve essere compatibile con esso, e anche se compatibile dal punto di vista delle dimensioni (cioè le dimensioni del dizionario) qusto non vuol dire sempre compatibilità totale, se per esempio usiamo il tokenizzatore di LLAMA per Mistral le dimensioni del dizionario sono le stesse ma farà schifo e genererà cose completamente a caso.

## Embedding Layer

![[Pasted image 20240311181542.png]]


La tokenizzazione prende le frasi e li trasforma in token codificati numericamente, l'embedding ha invece un vettore per ogni indice della tokenizzazione.

![[Pasted image 20240311213703.png]]

