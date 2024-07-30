Buonasera,
volevo fare un riassunto di quanto detto in merito alla scrittura del paper che deriverebbe dal lavoro della mia Tesi magistrale.
Abbiamo discusso della necessità di una baseline: utilizzeremo per questo scopo LLaMA2-chat in zero shot, anche se il professor Croce ha sollevato dei dubbi riguardanti la fattibilità di utilizzare questo modello, visto che il Multi Layer Perceptron projector del visual encoder non sarebbe correttamente addestrato. Potrebbe dover essere necessario utilizzare Vicuna, per il quale questo problema non sussiste.
In seguito, dovremmo effettuare un "Ablation study" sulla componente visuale del modello, per verificare che la multimodalità (nel nostro caso le immagini) effettivamente migliorano la prestazione del modello. Addestrare quindi due modelli: "Simple Model" e "Dialogue Model" senza immagini, e confrontarli con le loro controparti multimodali. Fare lo stesso poi con il modello zero shot.
Successivamente dovremmo risolvere il problema di Class unbalance tra le classi "Clear" ed "Unclear".
Per fare questo opereremo un undersampling sulla classe "Clear", tenendo fisso la quantità di comandi "Unclear" e dividendo il dataset in tre diversi campioni con tre diversi insiemi di esempi "Clear".
Infine sarebbe opportuno, risolvere le problematiche relative alle poche varianti sintattiche di "Posso eseguirlo", cioè la risposta affermativa dell'agente ad un comando chiaro. Vorremmo aggiungere varianti a questa risposta, e, possibilmente, risolvere o mitigare il problema dell' imbalance: se "Posso eseguirlo" ha molte varianti sintattiche, potrebbe non essere così necessario fare undersampling. 
Discorso simile vale anche per le risposte a comandi "Unclear": per ora il modello si è limitato a fare domande, ma potrebbe essere interessante che rispondesse spiegando perchè non può eseguire il comando: "Non posso eseguire il comando, perchè non so di che colore sono i blocchi da piazzare".
Infine sarebbe opportuno, nell'ottica di una review in un contesto internazionale, confrontare anche le performance con un modello inglese. Per questo potremmo riaddestrare sugli stessi dati, ma tradotti in inglese, il modello "Dialogue Model" per confrontarlo con i risultati ottenuti dal "Dialogue Model" in italiano.
Questo è, brevemente, il risultato del colloquio avuto lunedì mattina. 
Vi ringrazio per la disponibilità e vi prego di farmi sapere se ci sono imprecisioni o se ho dimenticato dei punti chiave che abbiamo toccato.
Cordiali saluti,
Bruno Gatti




# Documento Word

Questo è un documento riassuntivo riguardante le sperimentazioni che intendiamo fare nei prossimi giorni.
Innanzitutto è necessario addestrare un modello "baseline". Per questo motivo vogliamo utilizzare LLaMA2-chat in zero shot. Il professor croce ha espresso dei dubbi riguardanti l'utilizzo di LLaVA per questo scopo, visto che il MLP projector risulterebbe non compatibile, e potrebbe essere necessario usare Vicuna o riutilizzare i .
Successivamente, una volta confrontate le performance di questa baseline con i modelli "Simple Model" e "Dialogue Model", bisognerà procedere con l'Undersampling. L'idea è quella di generare tre versioni del dataset tenendo fissa la parte di comandi "Unclear" e campionando la parte "Clear" dei comandi in tre diversi insiemi. Dovrebbe risultare un dataset con dati "Clear" 1.2