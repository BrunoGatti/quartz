1. Quello che vogliamo fare è dimostrare che addestrare un modello su dialoghi lo rende più performante che se lo addestro senza dialoghi, quindi che la storia conta. History Matters
2. Per fare questo addestriamo 3 modelli, 1 su solo l'ultima parte del dialogo (spezzettato anche lui), uno sui dati con dialogo "interi", uno sui dialoghi spezzettati (o incrementali) cioè che per ogni dialogo fornisco più dati tanti quanti sono i turni.
3. Confronto in maniera comparativa baseline con storia incrementale e baseline senza dialoghi
4. Calcolo l'inter annotation agreement.

## Addestramento
1. metto su il modello
2. preparo i dati spezzeettando e lasciando solo l'ultima parte del dialogo
3. addestro