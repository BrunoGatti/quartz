## obiettivi
replicare i risultati e rendere dialogico il modello


Noi abbiamo dataset del genere

![[Pasted image 20240427095805.png]]

Una serie di game con ID e path all'immagine

![[Pasted image 20240427095825.png]]

Una descrizione testuale del mondo
Un comando da eseguire sull'ambiente e il gold sstandard di risposta che ci si aspetta dal modello di linguaggio.

![[Pasted image 20240427095850.png]]

Alcuni di questi comandi, volutamente non sono completi. In totale ho crica 5k comandi. Di cui i non completi son 717.

Aggiungo tre nuove colonne 

| User clarification | Is command 2 clear | Agent Response 2 |
| ---- | ---- | ---- |
per il nuovo comando di chiarificazione nel caso in cui il comando precedente non fosse 
completo tipo nel caso:

| Command                                                                                                                                        | Is command clear | Expected output          | User clarification                      | Is command 2 clear | Agent Response 2    |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | ------------------------ | --------------------------------------- | ------------------ | ------------------- |
| Costruisci 2 blocchi bianchi sopra il blocco verde. Metti un blocco verde in cima. La figura risultante sarà 4x1 di verde bianco bianco verde. | No               | Dove sono i blocchi blu? | ES: ah scusa intendevo i blocchi gialli | ES: Yes            | ES: Posso Eseguirlo |

Quindi ad un comando non chiaro deve seguire un comando di chiarificazione dell'utente, al quale deve essere data una risposta adeguata dell'agente, nel caso che la chiarificazione dell'utente sia corretta allora la risposta dell'agente deve essere qualcosa tipo "Posso eseguirlo", altrimenti deve essere un'ulteriore richiesta di chiarificazione.

Ho scritto uno script python che permette l'annotazione manuale degli esempi:
![[Pasted image 20240427114907.png]]

Questo programma ci permette di annotare il dataset facilmente, trova tutte le righe del dataset che non sono chiare (command clear: no) e chiede all'utente di modificarle.
Questo permette un'annotazione manuale da parte dell'utente.

Fa il display dell'immagine ed inoltre permette di vedere la descrizione testuale del  modno insieme all'input originale dell'utente, alla risposta originale dell'agente ed un contatore che indica quanti elementi sono ancora da annotare.

## Lunedì alle 10 da claudiu 

Split dei dialoghi
I dialoghi sono massimo da 5
50% saranno dialoghi da 2 passi (1 comando aggiuntivo)
35% dialoghi da 3 passi (2 comandi aggiuntivi)
10% dialoghi da 4 passi (3 comandi aggiuntivi)
5% dialoghi da 5 passi (4 comandi aggiuntivi)

Tutti i comandi tranne quello finale saranno ambigui

Formula per calcolare il numero di comandi:

$$ ((numero\ di\ righe\ ambigue)/100)*(5*4+10*3+35*2+50*1)= $$

Il numero di righe ambigue in train è 717, il che significa che 

$$ (7,17)*(20+30+70+50)= (7,17)*136 = 1219 $$

## Fai un bel conteggio di tutti i dati che hai e dati che avrai (diviso tra ambiguo e non)

## Suggerimenti o idee per annotare i comandi

0. comando corretto e non ambiguo (solo per l'ultimo comando da annotare, la risposta del robot deve essere: Posso eseguirlo.)
1. spostare/ distruggere blocchi di un colore che non è presente nell'immagine
2. aggiungere blocchi di un colore che non può essere aggiunto
3. spostare blocchi di un colore che è nella mappa ma in una quantità che non è presente sulla mappa
4. scrivere un comando con semantica non comprensibile: sposta quattro isolati da su a giu
5. scrivere un comando con semantica comprensibile ma sintassi molto sbagliata(come se avessi fatto un errore di battitura) es: sposta tuttoli i blocsafdhflkas viola ad ovestesrdklts
6. distruggere spostare blocchi di un colore e in una quantità presente nell'immagine ma con una posizione dove non sono (es: sposta i blocchi viola che sono sopra i blocchi blu (e in realtà sono sotto i blocchi blu))
7. Dare un comando completamente diverso da quello dato in precedenza (completo se è l'ultimo comando da dare non completo se ci sono ancora comandi da inserire)
8. chiedere di piazzare dei blocchi senza specificare dove e in che quantità
9. EVITA: di invertarsi "destra", "sinistra", "nord", "sud" etc perchè sono difficili da risolvere nella fase successiva.

## Suggerimenti o idee per annotare le risposte del robot
0. se è l'ultimo comando deve essere "Posso eseguirlo."
1. Quando mancano informazioni nel comando fare in genere una domanda per volta
	- puoi anche fare più domande insieme ma non sempre dipende anche da quante informazioni mancano e da quante annotazioni utente puoi ancora fare 
2. Ricorda che bisogna avere queste informazioni prima di concludere: 
	- numero di blocchi
	- colore dei blocchi 
	- orientamento dei blocchi se sono più di uno (verticale, orizzontale, verso nord, sud etc)
	- disposizione dei blocchi se sono più di uno (in fila, in pila etc)
	- se il comando dice a destra o sinistra, deve chiedere est oppure ovest, le indicazioni devono essere cardinali non "destra e sinistra" (questo dovrebbe accadere solo nel primo comando)
	- posizione: se il comando è "aggiungere blocchi" devo sapere dove, se ti dice "rimuovi un blocco verde" devi sapere quale

## Annotazioni secondo paper di Claudiu. Quale informazione la domanda chiede.
### 
Utente deve chiedere una delle categorie di cui sopra mentre l'agente deve avere abbastanza elementi per poter rispondere quindi: colore, numero, posizione, distribuzione verticale/orizzontale, com'è orientato (est/ ovest...)


## Tira fuori lo stato dell'arte dei modelli multimodali
vedi se qualcuno sta facendo dialogo multimodale. E butta giù qualcosa.


## Comincia a fare un flusso/ input output.
Tu darai primo terzo quinto settimo e nono turno e gli chiedo di generare il turno pari.


Aggiungi id immagine
cambia italiano e inglese
aggiungi il flag se è stato già cambiato
Fai test e zip.

allunga il wrap, metti a destra il box

|       | 2 turni | 4 turni | 6 turni | 8 turni | 10 turni | totale |
| ----- | ------- | ------- | ------- | ------- | -------- | ------ |
| TRAIN | 4813    | 492     | 153     | 48      | 24       | 5530   |
| TEST  | 594     | 63      | 19      | 5       | 2        | 683    |
| DEV   | 531     | 59      | 18      | 5       | 2        | 615    |

|       | 2 turni | 4 turni | 6 turni | 8 turni | 10 turni | totale |
| ----- | ------- | ------- | ------- | ------- | -------- | ------ |
| TRAIN | 5303    | 645     | 153     | 48      | 24       | 5530   |
| TEST  | 594     | 63      | 19      | 5       | 2        | 683    |
| DEV   | 531     | 59      | 18      | 5       | 2        | 615    |

| 2 turni | 4 turni | 6 turni | 8 turni | 10 turni | totale |       |     |
| ------- | ------- | ------- | ------- | -------- | ------ | ----- | --- |
| 4813    | 492     | 153     | 48      | 24       | 5530   | TRAIN |     |
| 594     | 63      | 19      | 5       | 2        | 683    | TEST  |     |
| 531     | 59      | 18      | 5       | 2        | 615    | DEV   |     |
|         |         |         |         |          |        |       |     |
|         |         |         |         |          |        |       |     |
|         |         |         |         |          |        |       |     |
| TRAIN   |         |         |         |          |        |       |     |
| TEST    |         |         |         |          |        |       |     |
| DEV     |         |         |         |          |        |       |     |
|         |         |         |         |          |        |       |     |

|  |  |  |  |  |  |  |  |  |  |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| posizionare tre blocchi verdi orizzontalmente | in quale direzione devono essere posizionati i blocchi orizzontali? dove devono iniziare i blocchi orizzontali? | accanto ai blocchi viola | ci sono più colonne viola. dove esattamente vanno posizionati i verdi? | sulla sinistra | Non mi è chiaro cosa intendi per sinistra | Rivolto a nord metti a sinista | In mezzo a due colonne viola o a sinistra della costruzione? | A sinistra della costruzione | Posso eseguirlo |

| architetto | agente |
| ---- | ---- |
| posizionare tre blocchi verdi orizzontalmente | in quale direzione devono essere posizionati i blocchi orizzontali? dove devono iniziare i blocchi orizzontali? |

| architetto | agente | architetto | agente |
| ---- | ---- | ---- | ---- |
| posizionare tre blocchi verdi orizzontalmente | in quale direzione devono essere posizionati i blocchi orizzontali? dove devono iniziare i blocchi orizzontali? | accanto ai blocchi viola | ci sono più colonne viola. dove esattamente vanno posizionati i verdi? |

| architetto | agente | architetto | agente | architetto | agente |
| ---- | ---- | ---- | ---- | ---- | ---- |
| posizionare tre blocchi verdi orizzontalmente | in quale direzione devono essere posizionati i blocchi orizzontali? dove devono iniziare i blocchi orizzontali? | accanto ai blocchi viola | ci sono più colonne viola. dove esattamente vanno posizionati i verdi? | sulla sinistra | Non mi è chiaro cosa intendi per sinistra |

## oggi
1. cambia prompt: il prog


## TITOLO

-  proposta 1: 
Does history matter? Exploring the impact of dialogue history for Multimodal Interactive Grounded Language Understanding in Italian

- proposta 2: 
Exploring the impact of dialogue history for Multimodal Interactive Grounded Language Understanding in Italian

- proposta 3:
Leveraging Multimodal Large Language Models for Interactive Grounded Language Understanding in Italian


## 16 luglio
fatto oggi

1.tolto immagini e messo testo per prompt
![[Pasted image 20240716113451.png]]

2. cambiato get_prompt in pseudocodice
![[Pasted image 20240716113521.png]]

3.cambiato il file json da screenshot a testo
![[Pasted image 20240716113544.png]]
4.aggiunto menzione ai due task nell'introduzione

![[Pasted image 20240716113632.png]]

5.sistemato dicitura "Old_model" e "New_model" chiamandoli "Old prompt model" e "New prompt model" per renderli più chiari

6.Sistemato la f measure per l'altra classe "Non posso eseguirlo" ed aggiunta alla tesi
![[Pasted image 20240716113828.png]]

7.Aggiornato la misura per agreement togliendo i falsi positivi (viene molto meglio)

![[Pasted image 20240716113943.png]]

