Nel mio sistema di voto basato su blockchain, l'identificazione e il voto verranno completati in sede (seggio elettorale per le elezioni politiche). Per sapere il motivo di questa scelta leggere [[I problemi dei sistemi di voto|questo]].

### Dal punto di vista dell'utente il voto avverrà come segue:
1. Una volta nel seggio, l'utente verrà identificato dal presidente di seggio o chi per lui (chairperson)
2. Il presidente di seggio, attraverso un terminale, abiliterà una dei terminali usati per votare, al voto
3. Il votante verrà indirizzato ad una delle macchine per votare.
4. Le macchine potrebbero essere dotate, idealmente, di uno schermo che impedisce la visione laterale, oppure inserite in una cabina isolata.
5. Il votante esprime il suo voto ed è libero di andare.

### cosa avviene dal lato applicativo:
Dal punto di vista dell'applicazione front end, (che si relazionerà con la blockchain tramite libreria di python [web3](https://web3py.readthedocs.io/en/stable/)), l'applicazione è divisa in due parti:
1. [[chairperson.py|Chairperson]]
2. [[VotingBooth.py|Voting Booth]]

Queste applicazioni correranno rispettivamente sul terminale del presidente di seggio (chairperson) e sui terminali su cui si vota (voting booths).

### Per votare le macchine hanno bisogno di tokens
Nel sistema di voto che propongo, sul nodo ethereum, gli indirizzi non corrispondono ad ogni singolo votante (questo ne comprometterebbe l'anonimità), ma piuttosto ad ogni indirizzo corrisponde una macchina di voto, che quindi può votare infinite volte.

Per votare, però, è richiesto che la macchina trasferisca un token all'indirizzo associato allo smart contract del sistema di voto.

Quindi, per abilitare una macchina al voto, il chairperson, che ha precedentemente generato e che detiene i token in un wallet, deve inviare un token alla macchina per il voto.

Una volta inviato la macchina potrà votare senza problemi *una sola volta*!

## Nel complesso il progetto è strutturato due parti:

#### Applicativi python:
- [[chairperson.py]]: applicativo front end per il presidente di seggio
- [[VotingBooth.py]]: applicativo front end che gira sulle macchine per il voto

#### Smart contracts:
- [[Token.sol]]: smart contract rilasciato sul nodo Ethereum che fa il mint dei token e che ne gestisce il trasferimento
- [[VotingSystem.sol]]: smart contract che gestisce la logica di voto

