## Introduzione al problema

Il lavoro si inserisce nel contesto di creare agenti che operino in ambienti domestici.
Idealmente vorremmo che un agente sia in grado di spostarsi all'interno di un ambiente domestico e che sia in grado di ricevere comandi, operare sull'ambiente ed aggiornare la propria rappresentazione interna.

È chiaro che in un contesto del genere un agente (robot) deve essere in grado di:
1. comprendere la descrizione del mondo
2. comprendere il comando inviato
3. legare il comando con oggetti realmente esistenti nell'ambiente (grounding)

Tra gli approcci a questo problema segnalo [GrUT](http://sag.art.uniroma2.it/NL4AI/wp-content/uploads/2022/11/paper5.pdf), in GrUT viene utilizzata un'architettura basata su transformers per fare il grounding nell' interazione uomo macchina.
In questo paper viene utilizzata una rappresentazione solo testuale del mondo. Idealmente, sarebbe utile introdurre una rappresentazione del mondo più vicina alla realtà, come un ad esempio un feedback visivo (un'immagine).

Idealmente, vorremmo creare un ambiente osservabile che l'agente sia in grado di esplorare e con cui possa interagire. 
### ProcThor: un framework per la generazione di ambienti domestici
A questo proposito ci è utile utilizzare ProcThor.
ProcThor è un framework per la generazione procedurale di ambienti domestici, ed ha vari punti di forza:
1. Gli ambienti generati sono realistici ![[Pasted image 20231118125655.png]]
2. si possono generare diverse view diverse per ogni ambiente  ![[Pasted image 20231118125752.png]]
![[Pasted image 20231118130223.png]]
In questo modo possiamo testare l'approccio dei modelli di linguaggio su ambienti visivi realistici.
Ovviamente manca ancora il modello.
## L'approccio multimodale: [[Kosmos 2]]
A questo punto, se al problema di grounding si aggiunge la modalità visiva sotto forma di immagini, abbiamo bisogno di un modello che la gestisca: [[un modello di linguaggio multimodale]]

Ricapitolando, quindi, quello di cui abbiamo bisogno è di un modello di linguaggio, che operi su immagini (multimodale) e che sia in grado di fare il grounding delle entità presenti nel testo con le entità presenti nell'immagine.

A questo fine utilizziamo Kosmos2: un Large Language model multimodale che introduce la possibilità di fare grounding sulle immagini.

## Obiettivo del progetto
L'obiettivo del progetto è quello di valutare la performance del Large Language Model [[Kosmos 2]] su due task rilevanti: 
1. **grounded image captioning**: data un'immagine generare una caption che riferisca alle bounding box sull'immagine ![[Pasted image 20231118141400.png]]
2.  entity grounding: dato il nome di un'entità individuarne il bounding box sull'immagine.

L'idea è quella di valutare sia Kosmos zero-shot e Kosmos fine-tuned su queste task.

Ovviamente, per fare ciò c'è bisogno di un [[Creazione Dataset|Dataset]]
