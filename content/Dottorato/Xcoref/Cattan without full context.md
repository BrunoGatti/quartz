Invece di mettere le mani al codice di cattan devo modificare test.json

/home/martinelli/xcoref/coref/data/ecb/mentions/test.json

è da questo file che lo script di cattan si prende il full context delle mentions.
Fortunatamente il file, per ogni token di un documento, ha una flag True/False che mi dice se il token è effettivamente nel "Cybulska setting" oppure no.
Dove cybulska setting si intende un sottoinsieme selezionato e validato manualmente del documento.

Es: i primi token del documento 41_3

![[Pasted image 20250408164357.png]]

Invece qui la parte del documento compreso nel cybulska setting


![[Pasted image 20250408164458.png]]

Che in effetti corrispondono all'inizio del documento corrispondente
![[Pasted image 20250408164546.png]]

Quindi lo script itera sull'oggetto json e cancella tutti gli elementi che hanno al loro interno "false".

Lo script prende in input "test.json" e come output "test_filtered.json"
Chiaramente bisogna fare attenzione a salvare una copia di "test.json" in caso succedano casini e poi bisogna rinominare "test_filtered.json" a "test.json". Questa cosa l'ho lasciata manuale per evitare sempre casini.

Lo script è dentro la stessa directory di test.json e si chiama "cybulskify.py"

Okay adesso test.json non contiene più termini "false"
![[Pasted image 20250408165553.png]]

## Running things
Adesso dobbiamo runnare roba su questo test set.
Innanzitutto predict.py
predict.py prende il pairwise scorer già addestrato e fa prediction su test. Salva il risultato 

Ho lanciato predict.py con i modelli vecchi che avevo addestrato.
Questo è il file di configurazione

```
{
"gpu_num" : [0],
  
"bert_model": "roberta-large",
"hidden_layer": 1024,
"dropout": 0.3,
"with_mention_width": true,
"with_head_attention": true,
"embedding_dimension": 20,
  
"max_mention_span": 15,
"use_gold_mentions": true,
"mention_type": "entities",
"top_k": 0.35,
"split": "test",
"training_method": "continue",
"subtopic": false,
"use_predicted_topics": false,
"segment_window": 512,
"exact": false,
  
"topic_level": true,
"predicted_topics_path": "/home/nlp/ariecattan/coreference/event_entity_coref_ecb_plus/data/external/document_clustering/predicted_topics",
  
"data_folder": "data/ecb/mentions",
"save_path": "models/pairwise_scorers",
"model_path" : "models/pairwise_scorers_goldm",
"model_num": 6,
"keep_singletons": false,

"threshold": 0.75,
"linkage_type": "average"
}
```
Il risultato è un netto -5 punti.

![[Pasted image 20250408170451.png]]

## Silver
Adesso devo replicare i risultati su silver mentions. Per farlo non bisogna riaddestrare ma bisogna riconfigurare config_clustering.json

Intanto devo mettere il modello che fa meglio in silver setting
che dovrebbe essere il modell 7 con treshold 0.65. Questo si trova nella cartella "pairwise_scorers" che contiene i pairwise scorers addestrati su silver setting.

---

## Addestrando Cattan su scico

Per addestrare Cattan su Scico ho bisogno di train, dev e test su scico.
![[Pasted image 20250411161407.png]]
li ho messi dentro gold_singletons_scico e mentions_scico

A questo punto devo fare addestramento.

### Addestramento di span scorer
Per l'addestramento di span scorer ho usato questo file:

![[Pasted image 20250411161705.png]]
```bash
python train_span_scorer --config configs/config_span_scorer.json
```

Servono ancora i file test_entities.json

![[Pasted image 20250411163303.png]]

Sono informazioni che abbiamo, ma che dobbiamo tirare fuori
