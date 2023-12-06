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
Il voto viene gestito, come già preannunciato con una tecnologia decentralizzata basata su Ethereum blockchain.
Questa tecnologia viene utilizzata per gestire la logica di voto, le caratteristiche della blockchain technology permettono al voto di essere anonimo, decentralizzato, trasparente e scalabile.

Nello specifico, nel sistema di voto che propongo, sul nodo ethereum, gli indirizzi non corrispondono ad ogni singolo votante, ma piuttosto ad ogni indirizzo corrisponde una macchina di voto.

Questo ci permette non soltanto di garantire l'anonimato del votante il cui voto ( anche in caso di compromissione totale) non può essere ricondotto alla propria persona, ma anche di gestire con più facilità il numero di indirizzi che votano sulla blockchain, permettendo di individuare con facilità eventuali agenti esterni che tentano di compromettere il sistema.

Ovviamente questo tipo di approccio richiede che la macchina, e quindi l'indirizzo ad essa corrispondente, possa votare più di una volta. Per questo serve un metodo per permettere di controllare il numero di volte in cui uno stesso utente può emettere un voto, altrimenti si rischierebbe di lasciare agli utenti la possibilità di votare infinite volte una volta "chiusi" all'interno della cabina.

Per ovviare a questo problema si richiede che ogni macchina al momento del voto "spenda" un token. In questo modo, nel nostro sistema, l'utente viene identificato, e, una volta confermata la sua idoneità al voto, il chairperson abilita il terminale adibito al voto inviando un token.

Il voto verrà emesso dall'utente nella privacy della cabina, con la sicurezza che, quando questi esprimerà la propria preferenza, il token sarà stato trasferito, e l'utente non potrà votare di nuovo. 
## Nel complesso il progetto è strutturato due parti:

#### Applicativi python:
- [[chairperson.py]]: applicativo front end per il presidente di seggio
- [[VotingBooth.py]]: applicativo front end che gira sulle macchine per il voto
- Verify.py: applicativo front end che gira sul terminale dell'operatore che verifica il voto
#### Smart contracts:
- [[Token.sol]]: smart contract rilasciato sul nodo Ethereum che fa il mint dei token e che ne gestisce il trasferimento
- [[VotingSystem.sol]]: smart contract che gestisce la logica di voto

