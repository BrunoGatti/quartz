Nel mio sistema di voto basato su blockchain, l'identificazione e il voto verranno completati in sede (seggio elettorale per le elezioni politiche).
[[I problemi dei sistemi di voto|Qui]] una spiegazione dettagliata sul perché di questa scelta.

## Attori del sistema di voto
- Chairperson: il presidente di seggio, il responsabile dell'identificazione dell'utente, nonchè responsabile del corretto svolgimento delle votazioni, è fornito di un terminale con un'interfaccia utente su cui gira il programma [[chairperson.py]].
- Operatore di verifica: Colui che verifica che l'utente abbia effettivamente votato, è fornito di un terminale su cui gira il programma [[verify.py]]
- Votante: attore che effettua la votazione, interagisce con un terminale posto all'interno di una cabina elettorale su cui gira il programma [[VotingBooth.py]]

### Dal punto di vista del votante il voto avverrà come segue:
1. Una volta nel seggio, il votante verrà identificato dal chairperson, che richiederà un documento di identità e che confermerà la presenza del votante nella lista elettorale
2. Il presidente di seggio, attraverso un'interfaccia, abiliterà uno dei terminali nelle cabine, al voto
3. Il votante verrà indirizzato ad una delle macchine per votare. Le macchine potrebbero essere dotate, idealmente, di uno schermo che impedisce la visione laterale, oppure inserite in una cabina isolata.
4. Il votante esprime il suo voto.
5.  L'operatore di verifica controlla che il voto sia effettivamente stato effettuato.
6. Il votante è libero di andare.

## Lato front end dell'applicazione:
Dal punto di vista dell'applicazione front end, (che si relazionerà con la blockchain tramite libreria di python [web3](https://web3py.readthedocs.io/en/stable/)), l'applicazione è divisa in tre parti:
1. [[chairperson.py|Chairperson]]
2. [[VotingBooth.py|Voting Booth]]
3. [[Display di verifica]]

Queste applicazioni correranno rispettivamente sul terminale del presidente di seggio (chairperson), sui terminali su cui si vota (voting booths) e sul terminale da cui un operatore verifica che il voto sia stato effettivamente emesso.

Tutti e tre questi programmi sono stati scritti in python, per una descrizione dettagliata dell'implementazione di questi prorammi si rimanda ai link di cui sopra.

## Lato back end:
Il voto viene gestito, come già preannunciato, con una tecnologia decentralizzata basata su Ethereum blockchain.
Le caratteristiche della blockchain technology permettono al voto di essere anonimo, decentralizzato, trasparente e scalabile.

Nello specifico, nel sistema di voto che propongo, sul nodo ethereum, gli indirizzi non corrispondono ad ogni singolo votante, ma piuttosto ad ogni indirizzo corrisponde una macchina di voto.

Questo ci permette non solo di garantire l'anonimato del votante il cui voto ( anche in caso di compromissione totale) non può essere ricondotto alla propria persona, ma ci permette anche di gestire con più facilità il numero di indirizzi che votano sulla blockchain,  individuando con facilità eventuali agenti esterni che tentano di compromettere il sistema.

Ovviamente questo tipo di approccio richiede che la macchina, e quindi l'indirizzo ad essa corrispondente, possa votare più di una volta. Per questo serve un metodo per permettere di controllare il numero di volte in cui uno stesso utente può emettere un voto, altrimenti si rischierebbe di lasciare agli utenti la possibilità di votare infinite volte.

Per ovviare a questo problema si richiede che ogni macchina al momento del voto "spenda" un token. 
In questo modo, l'utente viene identificato, e, una volta confermata la sua idoneità al voto, il chairperson abilita il terminale inviando un token ed indirizza l'utente verso la cabina abilitata.

Il voto verrà emesso dall'utente nella privacy della cabina, con la sicurezza che, quando questi esprimerà la propria preferenza, il token sarà stato trasferito, e l'utente non potrà votare di nuovo. 

## Alcuni problemi e come essi vengono risolti
In questa sezione vediamo alcuni comuni problemi dei sistemi di voto elettronici e come questi vengono affrontati nel mio sistema di voto decentralizzato
### Il problema del conteggio dei voti
Il conteggio dei voti può essere fatto automaticamente dal sistema di voto. Questo è un enorme vantaggio rispetto al voto tradizionale, che necessita di una grande mano d'opera e un significativo dispiegamento delle forze dell'ordine per questo scopo.
Il sistema però, non deve rendere disponibile i voti in temo reale: questo perchè in tal modo si potrebbe associare un aumento dei voti per un candidato in un determinato momento con il voto di una determinata persona.
Se per esempio sappiamo che il votante A ha votato alle 13:53 e 12 secondi ed esattamente alle 13:53 e 12 secondi compare un voto per il "candidato 1" possiamo dire con buona probabilità che il votante A ha votato per il candidato 1.
Inoltre, si potrebbe dire che vedere i voti in tempo reale delle elezioni politiche, influenza le stesse: ad esempio se si vede che il partito A, è ampiamente sotto la soglia del 3%, i votanti potrebbero voler votare il partito B, che non è la prima scelta, ma che garantirebbe che il loro voto non venga perso.
Per questo motivo, i voti saranno criptati, e, per quanto possano essere richiesti in tempo reale, sarà premura dell'autorità competente, che per le elezioni politiche è il ministero dell'interno, fornire la chiave per decifrare il contenuto dei voti, e quindi procedere allo scrutinio.
I voti potranno essere quindi verificati da tutti, il che aumenta di molto la trasparenza, ma non prima della fine delle elezioni.
### Il problema dell'anonimato dell'utente
L'anonimato dell'utente viene gestito facendo in modo che gli indirizzi della blockchain non corrispondano ad un utente in maniera univoca, ma piuttosto, corrispondano ad una macchina di voto. Non c'è quindi modo di ricondurre l'indirizzo di voto (pubblico sul ledger della blockchain) con il votante.
### Il problema della verifica del voto
Un problema che sorge è quello di verificare che l'utente abbia effettivamente votato.
Normalmente durante le elezioni politiche, questo viene fatto visivamente, quando l'utente inserisce la scheda di voto nell'urna.
Nel nostro sistema, per verificare che il votante abbia votato, ci basta vedere che il token assegnato alla macchina sia effettivamente stato speso.
A questo proposito abbiamo sviluppato un'applicativo python [[verify.py]] che mostra in real time la balance di token di ogni macchina.
Se un utente esce da una cabina di voto, e la macchina ad esso corrispondente ha ancora un token assegnato, allora l'utente non ha correttamente espresso il suo voto.
Un addetto avrà il compito di monitorare la balance degli indirizzi associati alle macchine di voto, per evitare che vengano commesse queste irregolarità.
## Conclusioni
Per ricapitolare, la mia proposta di sistema di voto è un'applicazione decentralizzata che si basa su un [[Back end]] sviluppato in solidity e implementato su ethereum blockchain, ed un front end sviluppato in python.
Questo sistema non si pone come un cambio radicale al tradizionale sistema di voto in presenza, ma piuttosto come una soluzione tecnologica decentralizzata per migliorare il sistema di voto attuale.

Di seguito troverete la documentazione dettagliata del codice di questo progetto, a cominciare dal lato back end + testing, proseguendo con il lato front end.

prossima sezione: [[Documentazione del progetto]]
[[Sistema di voto|indice]]

