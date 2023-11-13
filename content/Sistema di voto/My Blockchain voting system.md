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
2. [[Voting Booth|VotingBooth.py]]

