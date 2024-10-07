Flusso di lavoro per oggi si trova in questo [[31 luglio.canvas|Flusso di lavoro]] scritto in canvas

Create nuova cartella per il progetto con path: ~/Desktop/paperCOLING
L'ambiente python è "paperCOLING"


``` bash
conda activate paperCOLING
```

Primo task di oggi è verificare quanti esempi dovrei annotare perchè il dataset nuovo spezzatino usato per la tesi ed annotato con i dialoghi ha più frasi di quello di test originale di mm_iglu

![[Pasted image 20240731161912.png]]

Il file si trova in [questo progetto online ](https://github.com/crux82/MM-IGLU/blob/main/data/datasets/) sotto forma di file excel, il file è stato scaricato e messo in una cartella chiamata "file_MM_iglu"
per trasformarlo in un file csv ho utilizzato un tool chiamato xlsx2csv

```python
 xlsx2csv llava_test.xlsx llava_test.csv
 ```

Per quanto riguarda il file della tesi, si chiama monika_MMIGLU_test_dialogo_2024_06_5.csv
ed è stato rinominato 

```bash
scp -r -i ~/.ssh/cronos_rsa bgatti@160.80.223.67:/home/bgatti/file_finali_06_2024/monika_MMIGLU_test_dialogo_2024_06_5.csv 
./

mv monika_MMIGLU_test_dialogo_2024_06_5.csv llava_test_dialogo_ita.csv
```

I due file adesso sono i file "test" uno in italiano con i dialoghi e l'altro in inglese senza i dialoghi

![[Pasted image 20240731163206.png]]

Ho scritto uno script che si occupa di controllare quanti esempi devo annotare (tradurre dall'italiano all'inglese) prendendo in input i due file llava_test.csv e llava_test.xlsx

![[Pasted image 20240731175440.png]]

in totale quindi si dovrebbe fare un lavoro di annotazione su 250 frasi in totale, 124 coppie di Command-Response.
A questo punto ho espanso llava_test.csv per prepararlo alla fase di annotazione:

```
python expand_llava_test.py
```

il file espanso si chiama *llava_test_dialogue.csv* e manca ancora della traduzione dei comandi che andrebbe fatta manualmente.

Poi ho estratto tutti i dialoghi in inglese da llava_test_dialogo_ita.csv con lo script "export_phrases_to_translate.py" che sostanzialmente esporta i dialoghi dal file csv

![[Pasted image 20240801102135.png]]

Il risultato è un file con tutte le traduzioni in coppie comando-risposta

```
The columns must be yellow
How many blocks should the new columns be made of?

Four blocks each
I can do it.

I mean, add a yellow block on top of the column of purple blocks
I can do it.

To the left facing north
I can do it.

I meant, place three yellow blocks in place of the red ones just removed
I can do it.

Destroy the top green block and build three more in a column in place of the one just removed
What color should the new blocks be?

Yellow
I can do it.
```
le ho fatte tradurre a chatGPT e ho verificato che le traduzioni fossero buone

```
Le colonne devono essere di colore giallo
Di quanti blocchi devono essere composte le nuove colonne?

Quattro blocchi ciascuna
Posso eseguirlo.

Intendo aggiungi un blocco di colore giallo sul lato superiore della colonna di blocchi viola
Posso eseguirlo.

A sinistra guardando il nord
Posso eseguirlo

Intendevo posiziona tre blocchi gialli al posto di quelli rossi appena rimossi
Posso eseguirlo.

Distruggi il blocco verde più in alto e costruiscine altri tre in colonna al posto di quello appena rimosso
Di che colore devono essere i nuovi blocchi?

Di colore giallo
Posso eseguirlo.

```

A questo punto bisogna ripopolare il csv a partire dalle traduzioni sul file txt
per farlo ho dovuto modificare leggermente i file di traduzione per fare in modo che potessero essere rimappati al file csv. Per farlo quindi ho risviluppato daccapo (ouch) lo script che estrae le frasi dal csv in modo da conservare una sorta di mapping che mi permetta poi di ripopolare il csv

![[Pasted image 20240801103906.png]]

Il risultato di "extract" è un file di questo tipo

```
CQ-game-4622,Command 2,Le colonne devono essere di colore giallo
CQ-game-4622,Agent Response 2,Di quanti blocchi devono essere composte le nuove colonne?
CQ-game-4622,Command 3,Quattro blocchi ciascuna
CQ-game-4622,Agent Response 3,Posso eseguirlo.
CQ-game-6327,Command 2,Intendo aggiungi un blocco di colore giallo sul lato superiore della colonna di blocchi viola
CQ-game-6327,Agent Response 2,Posso eseguirlo.
CQ-game-5453,Command 2,A sinistra guardando il nord
CQ-game-5453,Agent Response 2,Posso eseguirlo
```

la sua controparte in inglese è stat ottenuta a partire dal file translations_italian.txt 

translations_english.txt
```
CQ-game-4622,Command 2,The columns must be yellow
CQ-game-4622,Agent Response 2,How many blocks should the new columns be made of?
CQ-game-4622,Command 3,Four blocks each
CQ-game-4622,Agent Response 3,I can do it.
CQ-game-6327,Command 2,I mean, add a yellow block on top of the column of purple blocks
CQ-game-6327,Agent Response 2,I can do it.
CQ-game-5453,Command 2,To the left facing north
CQ-game-5453,Agent Response 2,I can do it.
```

![[Pasted image 20240801110322.png]]

A questo punto ho rimappato le frasi nel csv inglese con dialogo ottenendo:
"llava_test_dialogue_eng_updated.csv" che è stato rinominato "llava_test_dialogue_eng.csv", mentre "llava_test_dialogue_eng.csv" è stato rinominato "llava_test_dialogue_eng_empty.csv"

