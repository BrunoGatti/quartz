Problemi con le attuali metriche di Machine Translation: Premiano troppo i metodi che mimano i quality assessment umani.

Metriche neurali sono preferite a metriche "overlap based" perché mostrano maggiore correlazione con il giudizio umano. Il problema è proprio questo perché queste metriche neurali sono addestrate a mimare il giudizio umano in maniera "black box".

L'obiettivo di questo paper è usare metriche sentinella ("**sentinel metrics**") per far apparire questi problemi nelle metriche di valutazione.
SENTINEL<sub>cand</sub> è una metrica che valuta la qualità della traduzione conoscendo solo la traduzione senza conoscere la frase di riferimento. Questo ci fa capire bene cos'è una "metrica sentinella" cioè una metrica fallata che dovrebbe (idealmente) avere un ranking basso perché si basa solo sulla fluidità della frase e non su quanto bene ha tradotto la frase di origine (che è sconosciuta).
Invece questa metrica ha un ranking in [[WMT23]] superiore a metriche molto solide come "[COMET](https://aclanthology.org/2020.emnlp-main.213/)" e "[BLEURT](https://doi.org/10.18653/v1/2020.acl-main.704)".

### WMT evaluation process
Per prima cosa diversi modelli di machine translation sono impiegati sullo stesso segmento sorgente,

```
Hi how are you?
"Ciao Come stai?" modello 1
"Hey, come va?" modello 2
"Ciao, come va?" modello 3
```

come seconda fase viene condotta una valutazione manuale delle traduzioni: Un umano fa il ranking delle traduzioni dei vari modelli

```
ranking:
modello 1
modello 3
modello 2
```

Le metriche di valutazione vengono valutate in base a quanto mimano bene il ranking fatto dagli umani per la qualità della traduzione

| Metric 1 ranking | Metric 2 rnaking | **Human Ranking** |
| ---------------- | ---------------- | ----------------- |
| modello 1        | modello 3        | modello 1         |
| modello 3        | modello 2        | modello 3         |
| modello 2        | modello 1        | modello 2         |
Quindi in questo esempio la metrica 1 verrebbe valutata in maniera positiva perchè rispecchia il ranking fatto dall'umano.

In realtà le metriche vengono valutate in due livelli di granularità:
1. Segment level: ogni Metrica assegna uno score ad ogni traduzione

```SCORE_METRIC_1
Hi how are you?
"Ciao Come stai?" modello 1 SCORE: 7
"Hey, come va?" modello 2 SCORE: 6
"Ciao, come va?" modello 3 SCORE: 6,5
```

```SCORE_METRIC_2
Hi how are you?
"Ciao Come stai?" modello 1 SCORE: 5,5
"Hey, come va?" modello 2 SCORE: 6
"Ciao, come va?" modello 3 SCORE: 7
```

Le metriche vengono valutate in base alla loro abilità di discernere traduzioni buone da traduzioni non buone

2. System Level: Le metriche assegnano uno score ad ogni sistema di Machine Translation in generale (non alla singola traduzione ma all'intero sistema di machine translation) e le metriche sono ordinate in base alla loro capacità di distinguere sistemi migliori o peggiori di Machine translation

```Metric1
Metric 1 valuta modello 1: 7
Metric 1 valuta modello 2: 6
Metric 1 valuta modello 3: 6,5
```

Il modello viene valutato nel suo insieme **non nelle singole traduzioni**.

## Summay
Nel paper *Guardians of the Machine Translation Meta-Evaluation: Sentinel Metrics Fall In!*, gli autori affrontano due problematiche principali nel processo di meta-valutazione dei metriche di traduzione automatica (MT), evidenziando come queste influenzino l’equità, l’affidabilità e la validità delle classifiche metriche. Di seguito una sintesi dei punti chiave:

### Contesto: Meta-Valutazione al WMT
Ogni anno, la Conference on Machine Translation (WMT) valuta i metriche MT in base alla loro correlazione con i giudizi umani. L’introduzione recente di metriche neurali, che spesso mancano di trasparenza, rende più complesso il processo di meta-valutazione.

### Concetti Chiave
1. **Metriche Sentinella**: Gli autori introducono le *metriche sentinella* come strumenti diagnostici progettati per rivelare difetti nel processo di meta-valutazione. Questi includono:
   - **SENTINELCAND**: Valuta solo la fluidità della traduzione senza considerare l’adeguatezza del contenuto.
   - **SENTINELSRC** e **SENTINELREF**: Valutano la qualità della traduzione basandosi solo sul testo di origine o di riferimento, senza analizzare la traduzione stessa.

2. **Strategie di Raggruppamento nella Meta-Valutazione**:
   - **Nessun Raggruppamento**: Le traduzioni vengono valutate in un unico insieme, senza distinzione per frase di origine o sistema MT.
   - **Raggruppamento per Sistema**: Le traduzioni sono raggruppate in base al sistema di traduzione automatica che le ha prodotte.
   - **Raggruppamento per Segmento**: Le traduzioni sono raggruppate in base alla frase di origine, confrontando quindi solo le traduzioni della stessa frase.

   Gli autori sostengono che il *Raggruppamento per Segmento* sia il più efficace per ridurre le *correlazioni spurie*, ovvero i modelli irrilevanti (come la lunghezza della frase o il numero di nomi propri) che potrebbero influenzare erroneamente il punteggio di una metrica.

### Problematiche Principali
1. **Bias delle Strategie di Raggruppamento**: Le strategie *Nessun Raggruppamento* e *Raggruppamento per Sistema* introducono distorsioni che favoriscono metriche che sfruttano correlazioni spurie. Ad esempio, metriche come SENTINELCAND ottengono punteggi alti con queste strategie pur valutando solo la fluidità e non l’adeguatezza.
2. **Bias nella Calibrazione dei Pareggi**: Le metriche continue (con una gamma di valori ampia) sono favorite quando la *calibrazione dei pareggi* viene condotta sullo stesso test, poiché si adattano più facilmente rispetto a metriche discrete (che hanno meno valori di punteggio). Gli autori suggeriscono di usare invece un insieme di dati separato per questo processo.

### Risultati degli Esperimenti
Gli autori dimostrano che:
- Con il **Raggruppamento per Segmento**, metriche come SENTINELSRC e SENTINELREF (che si basano su correlazioni spurie) ottengono punteggi più bassi, rendendo le classifiche più eque.
- Le metriche sentinella che si basano su correlazioni spurie ottengono classifiche più alte con **Nessun Raggruppamento** e **Raggruppamento per Sistema**, a supporto delle preoccupazioni degli autori sui bias.
- Le metriche continue ottengono prestazioni migliori nei test di **calibrazione dei pareggi**, poiché possono adattare i loro punteggi per rispecchiare più facilmente le distribuzioni dei giudizi umani rispetto alle metriche discrete.

### Raccomandazioni
1. **Usare il Raggruppamento per Segmento** per valutare le metriche MT, poiché minimizza l’impatto delle correlazioni spurie.
2. **Evitare di condurre la calibrazione dei pareggi sullo stesso set di test** per garantire equità sia per metriche continue che discrete.
3. **Considerare nuovi metodi** per gestire le gamme di punteggi continui, migliorando interpretabilità ed equità.

### Conclusione
Il paper evidenzia che l’attuale processo di meta-valutazione WMT favorisce alcune categorie di metriche (quelle addestrate per imitare i giudizi umani e le metriche continue). Implementando *metriche sentinella* e strategie alternative di raggruppamento, gli autori sottolineano che è necessario un quadro di valutazione più robusto ed equo, affinché le metriche MT riflettano meglio la qualità dei giudizi umani.