## Introduzione al problema

Il lavoro si inserisce nel contesto di creare agenti che operino in ambienti domestici.
Idealmente vorremmo che un agente sia in grado di spostarsi e che sia in grado di ricevere comandi, operare sull'ambiente ed aggiornare la propria rappresentazione interna.

È chiaro che in un contesto del genere un agente (robot) deve essere in grado di:
1. comprendere la descrizione del mondo
2. comprendere il comando inviato
3. legare il comando con oggetti realmente esistenti nell'ambiente (grounding)

## Grounding
Il grounding è quindi il problema di legare le entità presenti nel comando con entità realmente presenti nel mondo o nella sua rappresentazione interna che ha l'agente.

Tra gli approcci a questo problema segnalo [GrUT](http://sag.art.uniroma2.it/NL4AI/wp-content/uploads/2022/11/paper5.pdf). 
In GrUT viene utilizzata un'architettura basata su transformers per fare il grounding nell' interazione uomo macchina.
Il grounding viene fatto sulle entità realmente esistenti nel mondo sfruttando la Textification: tutte le entità e le loro proprietà vengono descritte in linguaggio naturale. 
Successivamente un modulo filtra tutte e sole le entità rilevante per il comando ricevuto. 

In questo paper viene utilizzata una rappresentazione solo testuale del mondo. 
Idealmente, vorremmo eliminare la descrizione testuale ed inserire delle rappresentazioni più vicine alla realtà, come le immagini, creando un ambiente osservabile che l'agente sia in grado di esplorare e su cui possa agire ed interagire.
### ProcThor: un framework per la generazione di ambienti domestici
A questo proposito ci è utile utilizzare ProcThor.
ProcThor è un framework per la generazione procedurale di ambienti domestici, ed ha vari punti di forza:
1. Gli ambienti generati sono realistici ![[Pasted image 20231118125655.png]]
2. si possono generare diverse view diverse per ogni ambiente  ![[Pasted image 20231118125752.png]]
![[Pasted image 20231118130223.png]]
In questo modo possiamo testare l'approccio dei modelli di linguaggio su ambienti visivi realistici.
Ovviamente manca ancora il modello.
## L'approccio multimodale: [[Kosmos 2]]
A questo punto, se al problema di grounding si aggiunge la modalità visiva sotto forma di immagini, abbiamo bisogno di un modello che la gestisca: [[Modello di linguaggio multimodale|Un modello di linguaggio multimodale]].
I modelli di linguaggio multimodale sono in grado di operare con più "modalità" oltre a quella testuale: immagini, suoni, feedback video etc.
Non basta però.
Serve anche che questo modello sia in grado di fare il grounding delle entità presenti nel testo con le entità presenti nell'immagine.

A questo fine utilizziamo [[Kosmos 2|Kosmos2]]: un Large Language model multimodale che introduce la possibilità di fare grounding sulle immagini.

Si rimanda a questo [[Kosmos 2|link]] per una descrizione esaustiva del modello.
## Obiettivo del progetto
L'obiettivo del progetto è quello di valutare la performance del Large Language Model [[Kosmos 2]] su due task rilevanti : 
1. **grounded image captioning**: data un'immagine generare una caption che riferisca alle bounding box sull'immagine ![[Pasted image 20231118141400.png]]
2.  entity grounding: dato il nome di un'entità individuarne il bounding box sull'immagine.

In questo task viene chiesto al modello di linguaggio di individuare sull'immagine un'entità precisa, creando un bounding box.
Un'esempio di entity grounding:

$$
prompt="<grounding> <phrase>television</phrase>""
$$

Viene fornito un prompt come quello di cui sopra, insieme ad un'immagine:
![[img_3.png]]

L'output del modello è una stringa come la seguente:
```
<grounding><phrase> television</phrase><object><patch_index_0301><patch_index_0467></object> and<phrase> sofa</phrase><object><patch_index_0384><patch_index_0976></object> in a room
```
Le coordinate del bounding box dell'immagine possono anche essere ottenute nel formato classico, chiedendo al modello di dare in output le "entities"
```python
[('television', (0, 10), [(0.421875, 0.296875, 0.609375, 0.453125)]), ('sofa', (15, 19), [(0.015625, 0.390625, 0.515625, 0.953125)])]
```
Ovviamente l'[[evaluation]] sarà positiva se il bounding box dell'entità di partenza (in questo caso television) è corretto.
[[evaluation|Qui]] una spiegazione in dettaglio di come verrà fatta l'evaluation su questo task a partire da un labeled dataset.
L'idea è quella di valutare sia Kosmos zero-shot e Kosmos fine-tuned su queste task.

