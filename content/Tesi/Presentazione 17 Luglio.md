

![[Flusso_dati_tesi (2).png]]

![[Flusso_train_and_eval.png]]

### Classification task

![[Pasted image 20240717121438.png]]
![[Pasted image 20240717121505.png]]

Poi ci siamo accorti che il prompt era errato e che il training faceva overfitting

![[Pasted image 20240717121605.png]]
![[Pasted image 20240717121635.png]]
Ma il modello fa molte più domande
![[Pasted image 20240717121723.png]]


Risultati finali su class di classificazione riassunti:
![[Pasted image 20240717122837.png]]
### Generation task

![[Pasted image 20240717121910.png]]

Abbiamo valutato preferenza dei modelli ed agreement tra annotatori

|                                                                  |                                                                                      |                                                      |                   |                                          |                                                                                                          |                |               |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------ | ---------------------------------------------------- | ----------------- | ---------------------------------------- | -------------------------------------------------------------------------------------------------------- | -------------- | ------------- |
| **Expected output**                                              | **Model output 1**                                                                   | **Image Path**                                       | **Perfect match** | **Model output 2**                       | **Conversation**                                                                                         | **ID**         | **annotator** |
| Dove costruire il primo blocco e dove costruire altri 3 blocchi? | Posso eseguirlo.                                                                     | /data/bgatti/dati_IGLU/data/images//CQ-game-5216.png | 0                 | Dove devo costruire il primo blocco blu? | <image><br><br>Costruisci 1 blocco blu e distruggilo e poi costruisci altri 3 blocchi verdi in sequenza. | CQ-game-5216_1 | 2             |
| Distruggere quale blocco?                                        | Quale blocco specifico devo distruggere? Inoltre, dove dovrei costruire i 3 blocchi? | /data/bgatti/dati_IGLU/data/images//CQ-game-5552.png | 0                 | Posso eseguirlo.                         | <image><br><br>Distruggi 1 blocco e ne costruisci altri 3 di fila.                                       | CQ-game-5552_3 | 1             |

![[Pasted image 20240717122057.png]]

### Perchè non abbiamo valutato il modello vs Gold standard su tutti gli esempi, e quali abbiamo escluso

Abbiamo escluso i "falsi positivi": quelli in cui il modello generava "Posso eseguirlo." e il gold standard era una domanda.

![[Pasted image 20240717122323.png]]

Questo perchè il modello ha già sbagliato a priori. E mentre confrontare questo tipo di esempi, se compariamo i due modelli ha senso (ad esempio "Posso eseguirlo" potrebbe essere considerato buono anche se non corretto rispetto ad una domanda senza senso), in questo caso, il gold standard ha sempre ragione, perchè a monte abbiamo sbagliato il problema di classificazione.

![[Pasted image 20240717122515.png]]

Ripropongo i risultati:

![[Pasted image 20240717122057.png]]


### Considerazioni

#### Classification Task
Problema principale: il modello non fa abbastanza domande.
Addestrare il modello su tutta la storia ha però mitigato gli effetti negativi

![[Pasted image 20240717122837.png]]

#### Question generation task

Netta preferenza del modello con storia contro quello senza storia
E nel confronto con il gold standard le performance sono buone.
![[Pasted image 20240717123210.png]]
Claudiu io non so a cosa ti riferisci quando dici che mancano tantissime cose che mi avevi chiesto di sistemare, ci sono 20 pagine in più rispetto all'ultima versione. 1.1:Ho espanso l'introduzione mettendo esempi e chiarendo il task già dall' 1.1. 1.2:Modificato il capitolo 1.2 in modo tale da non fare riferimento a cose che avrei introdotto dopo, chiarendo solo il contributo della tesi rispetto a quanto già menzionato nell'1.1, fornito esempi di question generation e classification task 2.1.2/2.1.3 modificato gli errori che avevi segnalato 2.1.4 Tolto frasi con poco significato e messo la maiuscola al titolo. Nella Multi Headed Attention ho specificato che quando ho nominato la "Multi Headed attention" non mi riferivo a quanto detto prima, ma a quanto avrei detto dopo (divisione delle feature per attention head e aggiunta di trasformazioni lineari nell'operazione 2.1.5 aggiunto le citazioni che sui modelli che non ho spiegato, tolto "generate natural language text" che non voleva dire nulla. Aggiunto e sviluppato il conceto di fine tuning, scritto meglio, ed aggiunto un capitolo su decoder only architectures, introducendo GPT-2, few shot learning, instruction learning prima di parlare della multimodalità 2.2 spiegato molto più nel dettaglio i concetti di multimodalità, come vengono introdotti, cos'è un vision encoder, cos'è CLIP e cos'è il contrastive learning e 2.3 cambiato completamente l'overview della challenge IGLU riproponendo esempi per quanto riguarda le due task di classificazione e question generation, introducendo il dataset originale di IGLU 2.4 ho aggiunto una spiegazione degli obiettivi della tesi in relazione al dataset appena descritto e ai due task ed introdotto LLaVA più approfonditamente e spiegato perchè abbiamo scelto llava citando gli ottimi risultati su dialogo, infine ho introdotto LLaMA2 e LLaMA2chat che, come più avanti hai giustamente detto, non ho mai analizzato nonostante li stia usando. Per quanto riguarda il capitolo 3: Ho cambiato il titolo, 3.1 Introdotto il perchè ci serve il dataset e perchè l'approccio dialogico è conveniente e perchè il dataset originale di IGLU è inadatto a questo. Ho inoltre espanso la lista di passi che ho eseguito per la manipolazione di dati e modificato la figura per renderla più chiara 3.2 modificato le tabelle del capitolo per far in modo che entrassero nei bordi


Here's the picture transformed into a markdown table:

| ID           | Image_path | Description                                                                                                      | Command                                                          | Is command clear | Expected output     |
| ------------ | ---------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | ---------------- | ------------------- |
| CQ-game-1000 |            | there are no blue blocks, no yellow blocks, no green blocks, no orange blocks, five purple blocks, no red blocks | Place four blocks to the east of the highest block horizontally. | No               | Which color blocks? |

The image path column is left empty as the image cannot be directly included in a markdown table. If you have a URL for the image, you can add it like this: `![image description](image URL)`.