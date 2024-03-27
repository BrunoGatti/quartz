## Titolo: Visual Grounding automatico di entità in ambienti virtuali con MLLMs

1. Overview: io parlerò di ABCDE
2. Introduzione: de che stamo a parla
	- come sono fatti gli ambienti virutali
	- cos'è un'entità nellambiente
	- cos'è il visual grounding
3. Obiettivo: qual'è l'obiettivo, fare visual grounding degli ogetti in questi ambienti . Perchè fare VG (perchè attraverso la risoluzione di questo task io potrei permettere a questi modelli di fare un focus particolare su determinate ientità e questo si posiziona in un flusso più grande di Visual Grounded interpretation  di comandi robotici fatto da Claudiu in cui c'è bisogno che il robot oltre ad interpretare una frase ti tira fuori il bounding box. E quindi la mia è una sperimentazione preliminare) più in particolare in questo progetto voglio  sperimentare k modelli che risolvono questo task e confrontarli
4. METODO: flusso. Descrivi il flusso (dati che arrivano da Mizzoni e Mastrangeli)
5. MLLMS: kosmos e cogVLM
	- che tipo di modello è: VLM 
	- che tipo di architettura c'è sotto (magneto e clip per kosmos) 
	- numero di parametri
	- dati su cui sono stati addestrati (numerosità e tipologia) che tipo di problemi risolvono senza entrare in troppi dettagli, un po' di chicche
6. Valutazione: ho valutato questi modelli a questa maniera per dimostrare questo: blah blah
7. metriche di valutazione IoU (esempio di come si calcola)
8. slide in cui metto a confronto i due modelli semplici
9. grafici simpatici etc
10. slide in cui metto a confronto i due modelli con paternità (arricchire il prompt)
11. rifaccio vedere il flusso
12. chi è meglio, e chi sceglieresti.


## Introduzione
Il progetto gira intorno al task di image recognition