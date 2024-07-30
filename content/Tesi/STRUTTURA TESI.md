## 1 Introduzione
### sezione 1 introduzione più generale
### struttura della tesi

##  2 Background
### LLMS
quali problemi
letteratura
paper rilevanti

### Visual model e language model multimodali

### applicazioni dell'immagine, captioning convolutional neural network
clip 
immagini
patch

### LLava 3 LLama etc

## 3 Tesi vera

### Problema: Visual question answerign/ visually aware agent user dialog

considerare la consistenza di una domanda: ma io ce l'ho gli elementi per accettare quella richiesta come consistente rispetto al modno?

seconda sez: ma le domande non sono si e no ma generano di fatt delle chiarificazioni che possono richiedere più di un turno.

Obiettivo: avere un decoder che istituisca un dialogo di chiarificazione
2. addestrarelo
3. farlo accuratamente
4. addestrare

Io ho progettato di risolvere questo problema in questo modo e poi ho sperimentato soluzioni diverse, Diversi modelli etc.

3.2 scrivo la configurazione / architettura /dataflow di quello che ho fatto.
quindi in pratica llava e clip, llama 2 chat.
(ed il mio workflow)

3.3 development training data

3.
### 4 experimentation

4.1 quali domande voglio rispondere
qual'è  il livello di qualità dei dati
4.1.1 consistency of comman
.2 qualità del dialogo
.3 

4.2 Com'è fatto il dataset e quali misure accuracy inter annotator agreement e comparative validation xxx

nelle configurazioni sperimentali dobbiamo definire gli iperparametri etc per riprodurre l'esperimento

4.3 Per ognuna delle research question avrò una sezione sperimentale

4.5- error analysis
4.5 discussione dei risultati sperimentali

5 conclusione
devi far finta che una persona non abbia letto la tesi, wrap up, + hub anchor per puntare ai punti significativi della tesi se uno vuole approfondire

5.2 problemi aperti e sviluppi futuri e sorgenti di complessità



Here's the picture transformed into a markdown table:

| ID                       | Image_path | Description                                                                                                      | Command                                                              | Is command clear   | Expected output                 |
| ------------------------ | ---------- | ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ------------------ | ------------------------------- |
| <br><br><br>CQ-game-1000 |            | there are no blue blocks, no yellow blocks, no green blocks, no orange blocks, five purple blocks, no red blocks | <br>Place four blocks to the east of the highest block horizontally. | <br><br><br><br>No | <br><br><br>Which color blocks? |

The image path column is left empty as the image cannot be directly included in a markdown table. If you have a URL for the image, you can add it like this: `![image description](image URL)`.
