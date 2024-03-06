## Come funziona il modello

![[MicrosoftTeams-image 1.png]]

## I dati "raw"
I dati sono situati in una cartella. Ad ogni ambiente corrispondono una serie di immagini che ne catturano diverse porzioni.

Qui sotto l'esempio dell'ambiente 3486

![[Pasted image 20240305235639.png]]

Per ogni sono catturate multiple immagini da diverse posizioni:

![[Pasted image 20240305235818.png]]

Per ognuna delle posizioni vengono catturate una serie di immagini da diversi angoli:

![[Pasted image 20240305235900.png]]

![[Pasted image 20240305235921.png]]

![[Pasted image 20240305235934.png]]

Due degli angoli catturati con la telecamera in "posizione 0".

Ognuno di questi ambienti contiene un file json che contiene informazioni riguardanti l'ambiente e, in particolare le informazioni riguardanti gli oggetti presenti nell'ambiente e i loro relativi bounding box per ogni immagine.

```json
              "image": "images/LivingRoom/bounding_box/position_2/3486_LivingRoom_bounding_box_pos_2_180.jpg",
              "resolution": {
                "width": 600,
                "height": 600,
                "origin": "upper left"
              },
              "bounding_box": {
                "x1": 0,
                "y1": 293,
                "x2": 78,
                "y2": 333
              }
            }
          ]
        },
```
Qui c'è un esempio delle coordinate di un bounding box specificato nel file json

## Otput.csv

Adesso è il momento di estrarre il file "output.csv"
Questo file contiene una entry per ogni oggetto che compare in ogni immagine.
Questo significa che contiene le informazioni di ogni oggetto che compare in ogni immagine.
Se un oggetto compare in più di un immagine, ad esempio in tre immagini, comparirà tre volte in questo file (ogni volta con un bounding box diverso, e riferito ad un'altra immagine).

![[Pasted image 20240306001249.png]]

Qui c'è un esempio delle prime righe del file "output.csv".
Per ogni entry c'è:
1. L'ambiente in cui compare l'entità
2. il tipo di entità che compare nell'ambiente
3. le lexical references di quell'entità
4. il path (relativo) all'immagine che contiene quell'oggetto (una con bounding box disegnato e una senza)
5. Il bounding box dell'entità sull'immagine

## Evaluation
Il file "output.csv" è il file necessario alla fase di evaluation.
La fase di evaluation prende come input questo file, verrà iterativamente utilizzato il modello di linguaggio Kosmos2, dato il nome di un'entità e l'immagine in cui essa appare, per individuare il bounding box dell'immagine.

L'output di questa fase è un file chiamato "zero_shot.csv".
È un file che contiene tante entry quante il file originale. Le informazioni riportate sono le stesse del primo file, ma con l'aggiunta del bounding box generato da kosmos, e l'overlapping index, che indica l'indice di sovrapposizione tra il bounding box "target" (quello estratto dal file json) e quello generato da kosmos.
Viene valutato che c'è un match tra i due bounding box se l'overlapping index è maggiore di 0.5 (se c'è almeno il 50% di sovrapposizione).

![[Pasted image 20240306001905.png]]

Qui è riportato il codice di come ho calcolato l'overlapping index:
```python

def overlap_area(box1, box2):
    """
    Calculate the overlapping area between two bounding boxes.
    The input boxes should be in the format (xmin, ymin, xmax, ymax).
    """
    x_min = max(box1[0], box2[0])
    y_min = max(box1[1], box2[1])
    x_max = min(box1[2], box2[2])
    y_max = min(box1[3], box2[3])

    width = max(0, x_max - x_min)
    height = max(0, y_max - y_min)

    return width * height

def overlapping_index(box1, box2):
    """
    Calculate the overlapping index (IoU) between two bounding boxes.
    The input boxes should be in the format (xmin, ymin, xmax, ymax).
    """
    area1 = (box1[2] - box1[0]) * (box1[3] - box1[1])
    area2 = (box2[2] - box2[0]) * (box2[3] - box2[1])

    overlap = overlap_area(box1, box2)
    union = area1 + area2 - overlap

    return overlap / union if union > 0 else 0

```
### Come funziona l'algoritmo
L'algoritmo per l'evaluation funziona, a grandi linee come segue:

Viene caricato "output.csv come dataframe":
```python
df = pd.read_csv(eval_csv_path)
```
Per ogni row del file viene chiamata la funzione "evaluate_instance()"
```python
for index, row in df.iterrows():
	result_row = eval_instance(row)
```
Questa funzione prende in input una riga del file "output.csv", o meglio i dati contenuti in una riga di output.csv e restituisce:
1. il bounding box trovato da kosmos
2. l'overlapping index
3. se c'è stato o meno un match tra i due bounding box
Questo risultato viene inserito in un dataframe (che poi verrà esportato e sarà il file zero_shot.csv)
```python
df.loc[index, ["kosmos_bounding_box", "overlap_index", "Match"]] = result_row.values()
```

#### Eval instance
La funzione eval instance è il cuore di questo algoritmo. 
Il funzionamento è il seguente:

Prende immagine e bounding box dell'entità che sta esaminando:
```python
    # Extract information from the DataFrame row
    image_path = df_row["image_normal"]
    labeled_box_str = df_row["bounding_box"]

```

Genera il prompt, che insieme all'immagine verrà dato a kosmos2 per generare il bounding box:
```python
    # Generate prompt using the "entity type" entry of the DataFrame
    entity_type = df_row["entity_type"]
    prompts = generate_prompt(entity_type)

```

La funzione "generate_prompt()" prende in input il nome dell'entità e genera un prompt adeguato che permette a kosmos di capire che deve generare il bounding box di quell'entità.

Ad esempio, per l'entità di nome:  "Sofa"
Il prompt verrà generato così:
```python
prompt = f"<grounding><phrase>{entity_type}</phrase>"
```
E quindi sarà :
```xml
<grounding><phrase>Sofa</phrase>
```
Questo prompt molto semplice istruisce kosmos a generare il "grounding di una frase che inizia con il sostantivo "sofa".

Questo non garantisce che il modello kosmos generi ESCLUSIVAMENTE il bounding box dell'entità sofa: infatti raramente è così. Genralmente kosmos genererà tre o quattro entità che si trovano nell'immagine insieme al Sofa.

![[Pasted image 20240306003829.png]]

Ad esempio, è vero che ha generato il bounding box di "Sofa"

![[Pasted image 20240306003857.png]]

ma allo stesso tempo ha generato il bounding box di altre entità come:

![[Pasted image 20240306003949.png]]

![[Pasted image 20240306004003.png]]

A questo punto l'algoritmo itera su queste entità e verifica che ci sia un match con l'entità che ci interessa

L'ouput finale di questo processo è un file come quello riportato qui:

![[Pasted image 20240306001905.png]]

Qui sotto la funzione "eval _instance"
```python
def eval_instance(df_row, debug=False):
    # Extract information from the DataFrame row
    image_path = df_row["image_normal"]
    labeled_box_str = df_row["bounding_box"]

    # Convert bounding box values from string to float
    labeled_box = tuple(map(float, re.findall(r'\d+\.\d+', labeled_box_str)))

    # Generate prompt using the "entity type" entry of the DataFrame
    entity_type = df_row["entity_type"]
    prompts = generate_prompt(entity_type)

    # Process image with Kosmos and get entities
    kosmos_entities = process_image_with_kosmos(prompts[0], image_path)
    if debug:
        print(kosmos_entities)

    # Initialize result_row with default values
    result_row = {
        "kosmos_bounding_box": np.NaN,
        "overlap_index": 0.0,
        "Match": False
    }

    # Compare entities and calculate overlapping index
    if kosmos_entities is None:
        return result_row
    for kosmos_entity in kosmos_entities:
        _, _, kosmos_boxes = kosmos_entity
        for kosmos_box in kosmos_boxes:
            # Convert Kosmos bounding box values from string to float
            #kosmos_box = tuple(map(float, re.findall(r'\d+\.\d+', kosmos_box_str)))
            overlap_index = overlapping_index(labeled_box, kosmos_box)
            result_row["kosmos_bounding_box"] = kosmos_box  # Convert bounding box back to string?
            result_row["overlap_index"] = overlap_index
            result_row["Match"] = overlap_index > 0.5
            if result_row["Match"]:
                print(f"Entity matched with an overlapping index of: {overlap_index}")
                return result_row

    return result_row

```

## Esame dei risultati dell'evaluation
Questo computando alcune statistiche sull'operazione di evaluation fatta, questi sono i risultati:

![[Pasted image 20240306095507.png]]

I risultati sono di un'accuracy totale del 52%.
Da notare alcuni fatti interessanti:
1. L'overlapping index è notevolmente maggiore del 50% per le entità per cui è stato fatto un match corretto
2. L'overlapping index è notevolmente basso per le entità giudicate non correttamente

Inoltre se la cava notevolmente meglio su bounding box molto grandi (ergo quando l'oggetto è ben visibile) mentre non è molto performante su bounding box di piccole dimensioni.

Inoltre performa significativamente male sull'entità "Room Decor", probabilmente dovuto alla generalità del termine:

![[Pasted image 20240306010529.png]]

## Alcuni esempi di valutazione di kosmos

Ho inoltre sviluppato un piccolo programma python che utilizza la libreria Computer Vision di python per esaminare le istanze in cui Kosmos ha sbagliato, disegnando il bounding box target e quello invece riportato da kosmos.
Di seguito alcuni esempi interessanti di errori:

![[Pasted image 20240306010916.png]]

Un fatto che emergeva già dalla valutazione numerica era la difficoltà del modello di individuare le sedie:

![[Pasted image 20240306011049.png]]

Come si può vedere, vengono spesse confuse
Probabilmente complice il fatto che le sedie sono spesso in secondo piano, oppure si trovano dietro ai tavoli o ad altri oggetti. Sono anche mediamente più piccole di altri oggetti.

![[Pasted image 20240306012351.png]]

![[Pasted image 20240306011857.png]]

![[Pasted image 20240306011207.png]]

### Bounding box piccoli
Per come è satato addestrato kosmos, tende a dare un bounding box "no matter what". Questo, accoppiato con la scarsa capacità di individuare oggetti piccoli, evidenzia un netto limite, e spesso specialmente per oggetti piccoli, il bounding box è totalmente sbagliato e spesso associato al pavimento o al muro.

![[Pasted image 20240306011524.png]]

## Oggetti parzialmente nell'immagine
Un chiaro limite del dataset però questa volta, per via della sua natura generativa a partire da diversi orientamenti e posizioni, è quello di avere molti oggetti parzialmente nell'immagine o orientati in modo tale da renderli difficile da riconoscere. È spesso il caso dei dipinti:
![[Pasted image 20240306012128.png]]

![[Pasted image 20240306012104.png]]

Che sono spesso classificati male.
Ma è anche il caso di altri oggetti:

![[Pasted image 20240306012207.png]]

Questo può sicuramente essere visto come un limite del dataset, ma chiaramente evidenzia l'incapacità di kosmos nell'inferire l'entità da una vista parziale dell'oggetto.

## Evaluation su nuovo dataset


![[Pasted image 20240306094153.png]]

Il nuovo dataset presenta una serie più numerosa di entità sia per numero generale che per varietà.
La performance generale è calata dal 52% al 48%. Bisogna però tenere anche conto del fatto che mediamente il nuovo dataset ha bounding box di dimensione minore.
Media dimensioni bounding box dataset vecchio:

![[Pasted image 20240306100512.png]]

Media dimensione bounding box dataset nuovo:

![[Pasted image 20240306100450.png]]