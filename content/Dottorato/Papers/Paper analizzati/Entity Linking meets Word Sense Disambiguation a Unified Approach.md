---
publish: false
---
Il paper propone un approccio unificato a due task:[[Word Sense Disambiguation]] ed [[Entity Linking]].
Generalmente in WSD quello che si cerca è una "perfect association" tra la menzione di un concetto ed il suo significato, questo nel paper viene fatto tenendo un insieme di significati "candidati" (candidate meanings) per ogni menzione in modo tale da avere un'alta recall nel collegare menzioni parziali, proponendo un metodo per approcciare l'alto grado di ambiguità che ne consegue.

**In soldoni:**
Il linking consiste nell'associare ogni menzione con l'entry più appropriata di una data knowledge base.
La disambiguazione consiste nel disambiguare le entità nominali.

## L'approccio
L'approccio è piuttosto semplice ma molto efficace
1. Preso un network semanticamente annotato (necessario) si associa ad ogni vertice (concetto o named entity) una "semantic signature". La semantic signature è un insieme di vertici correlati
2. Candidate identification: Dato un testo in input vengono identificati i sostantivi da disambiguare e di cui fare linking, vengono identificati dei "Candidati" per il significato di queste entità nominali
3. Costruzione del network: viene costruito il network che individua i possibili significati della frase
![[Pasted image 20241030104126.png]]

4. Risoluzione del network: viene risolto il network con un algoritmo chiamato "candidate disambiguation" che individua i significati
![[Pasted image 20241030104155.png]]


## Problemi con questo approccio che ho notato

Questo approccio a grafo fa sì che vengano disambiguati significati in maniera abbastanza impressionante soprattutto considerato che è tutto definito senza modelli di linguaggio e solo con algoritmi su grafi.

![[Pasted image 20241030104532.png]]

Il problema è che proprio per questa natura a grafo, omettere alcune parti potrebbe far cadere l'intera lettura della frase. Ad esempio omettere il cognome di Thomas Muller fa si che anche Mario Gomez non venga riconosciuto

![[Pasted image 20241030104736.png]]

Questo perchè evidentemente viene a mancare il collegamento tra Thomas Muller e Mario Gomez che risulta indispensabile per disambiguare il Mario Gomez.
Cosa che però non è vera al contrario.

![[Pasted image 20241030104923.png]]

Questo problema non c'è se si considerano i "partial matches":
![[Pasted image 20241030105634.png]]

Inoltre non è resiliente agli errori grammaticali

![[Pasted image 20241030105023.png]]

Anche errori banali come il cambio di una maiuscola:

![[Pasted image 20241030105252.png]]