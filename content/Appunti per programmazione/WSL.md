---
publish: true
---

Wsl è un sottosistema Linux per Windows.
Questo significa che, sostanzialmente, potete lanciare comandi linux sul vostro sistema Windows DAL vostro sottosistema Linux.

#### Che vuol dire?
Praticamente parlando, il vostro Sistema Windows è come l'Italia, e il vostro sistema Linux è la repubblica di San marino.
In pratica userete Windows per tutto, giochi università, internet etc., ma lancerete i comandi dal sistema Linux.

## Come si installa?
1. Aprite il terminale di Windows come aministratore:
Per gli australopitechi che non sanno come si fa: dovete andare sulla barra di ricerca di Windows, digitare "Powershell" e selezionare l'opzione "esegui come amministratore".![Run PowerShell as Administrator: Multiple Methods Explored](https://adamtheautomator.com/wp-content/uploads/2020/11/FromSearch-1.png)
Questa opzione vi aprirà il terminale di windows come amministratore

2. Una volta sul terminale digitate questo **comando**:
```powershell
wsl --install
```

Queste installerà Ubuntu (una delle tante distribuzioni di Linux) sul vostro computer.

### Poi
una volta finito di installare, proprio come qualsiasi sistema nuovo che installate vi chiederà
1. Nome utente
2. Password (nuova)
una volta che glieli avete dati, aspettate un attimo e poi vi uscirà una linea di comando tipo questa

![[Pasted image 20231126110534.png]]
### Usare la linea di comando di Linux con VSCode:
Siccome molti di voi utilizzano VSCode (per non dire tutti), vi faccio pure vedere un metodo per aprire il terminale dentro VSCode.

1. Create una cartella dove da adesso in poi metterete tutti i vostri programmi in C
2. Aprite la cartella usando VSCode (File-->apri cartella)
3. Create un nuovo file e chiamatelo come vi pare basta che ci mettete .c alla fine del nome
4. in alto a sinistra su VSCode, ci dovrebbe essere scritto "Terminal", aprite un nuovo terminale.
5. Una volta aperto un nuovo terminale, accanto al "+" che vedete in figura qui sotto,
![[Pasted image 20231126105725.png]]
troverete una freccetta verso il basso (quella che vedete sopra in figura), se ci cliccate, tra le opzioni troverete "Ubuntu", cliccatelo.

### Fine
Avete installato WSL su windows e lo potete usare per VSCode