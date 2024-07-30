Per cominciare sarà necessario addestrare una baseline per confrontarla con le performance del Simple Model e del Dialogue Model.
La baseline sarà il modello LLama2chat in zero shot.
Attenzione perché il MLP projector non è effettivamente addestrato in "zero shot" e quindi bisogna usare Vicuna in quel caso.

Domanda: visti questi problemi potremmo usare invece di LLama2chat zero shot, il modello addestrato su solo dati testutali della challenge IGLU?