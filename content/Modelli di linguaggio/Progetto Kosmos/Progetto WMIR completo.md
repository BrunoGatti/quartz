---
publish: true
---

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

Gli oggetti possono essere contenuti nel campo "objects" o essere dei "figli" di un "Object" e quindi essere situati nel campo "children".

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

>[!nota]- non ci sono oggetti invisibili
>non ci sono oggetti invisibili: nonstante si possano inserire oggetti da procThor all'interno di entità chiuse come il frigorifero o i cassetti, questi non sono stati inclusi all'interno del dataset, quindi non ci dobbiamo preoccupare di oggetti che non siano visibili perchè chiusi in un'altra entità
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

Questo file viene estratto usando lo script "output_data_generator.py"
### Output_data_generator.py
Questo script prende in input il file "output.csv" ed itera su ogni file json all'interno della cartella che contiene i dati. Per ogni cartella ambiente prende il file json corrispondente ed estrae:
1. gli objects
2. i children di ogni objects

```python
import os
import json
import pandas as pd
import re

# Function to calculate normalized bounding box coordinates based on image resolution
def calculate_normalized_bbox(resolution, bbox):
    width, height = resolution['width'], resolution['height']
    x1 = bbox['x1'] / width
    y1 = bbox['y1'] / height
    x2 = bbox['x2'] / width
    y2 = bbox['y2'] / height
    return x1, y1, x2, y2

# Function to split camel case or compound words into separate words
def split_entity_type(entity_type):
    return ' '.join(filter(None, re.split(r'([A-Z][a-z]+)', entity_type)))

# Function to process a JSON file and extract relevant information
def process_json_file(directory, file, root_directory):
    with open(os.path.join(directory, file)) as f:
        data = json.load(f)
    
    objects = data.get("objects", [])
    environment = directory.split("/")[-1]
    
    rows = []
    for obj in objects:
        entity_type = obj.get("assetType", "")
        lexical_references = obj.get("lexical_reference", [])
        
        for image_info in obj.get("images", []):
            bounding_box_path = image_info.get("image", "")
            resolution = image_info.get("resolution", {})
            bounding_box = image_info.get("bounding_box", {})
            
            x1, y1, x2, y2 = calculate_normalized_bbox(resolution, bounding_box)
            
            # Modify bounding box image path
            bounding_box_dir, image_name = os.path.split(bounding_box_path)
            relative_image_path_bbox = os.path.relpath(os.path.join(directory, bounding_box_path), root_directory)
            
            # Get normal image path by replacing "bounding_box" with "normal" in the directory
            normal_dir = bounding_box_dir.replace("bounding_box", "normal")
            relative_image_path_normal = os.path.join(
                os.path.relpath(directory, root_directory),
                normal_dir,
                image_name.replace("bounding_box_", "")
            )
            
            rows.append({
                "environment": environment,
                "entity_type": split_entity_type(entity_type),
                "lexical_references": lexical_references,
                "image_bbox": relative_image_path_bbox,
                "image_normal": relative_image_path_normal,
                "bounding_box": (x1, y1, x2, y2)
            })
            
        # Process information from the "children" field
        children = obj.get("children", [])
        for child in children:
            child_entity_type = child.get("assetType", "")
            child_lexical_references = child.get("lexical_reference", [])
            
            for image_info in child.get("images", []):
                bounding_box_path = image_info.get("image", "")
                resolution = image_info.get("resolution", {})
                bounding_box = image_info.get("bounding_box", {})
                
                x1, y1, x2, y2 = calculate_normalized_bbox(resolution, bounding_box)
                
                # Modify bounding box image path
                bounding_box_dir, image_name = os.path.split(bounding_box_path)
                relative_image_path_bbox = os.path.relpath(os.path.join(directory, bounding_box_path), root_directory)
                
                # Get normal image path by replacing "bounding_box" with "normal" in the directory
                normal_dir = bounding_box_dir.replace("bounding_box", "normal")
                relative_image_path_normal = os.path.join(
                    os.path.relpath(directory, root_directory),
                    normal_dir,
                    image_name.replace("bounding_box_", "")
                )
                
                rows.append({
                    "environment": environment,
                    "entity_type": split_entity_type(child_entity_type),
                    "lexical_references": child_lexical_references,
                    "image_bbox": relative_image_path_bbox,
                    "image_normal": relative_image_path_normal,
                    "bounding_box": (x1, y1, x2, y2)
                })

    return rows

# Main function to process all JSON files in the specified directories recursively
def process_directories_recursively(root_directory):
    data_rows = []

    for root, dirs, files in os.walk(root_directory):
        json_files = [f for f in files if f.endswith(".json")]

        for json_file in json_files:
            data_rows.extend(process_json_file(root, json_file, root_directory))

    return data_rows

# Define the root directory
root_directory = "../huric/en"

# Process directories recursively and create DataFrame
data = process_directories_recursively(root_directory)
df = pd.DataFrame(data)

# Export DataFrame to CSV
csv_filename = "output_data.csv"
df.to_csv(csv_filename, index=False)

print(f"DataFrame exported to {csv_filename}")


```

Questo porta ad un file esageratamente numeroso per lo scopo di questo progetto

![[Pasted image 20240306140248.png]]
### Shuffling e selection
Per questo motivo è opportuno rimpicciolire il file rendendolo maneggiabile: utilizziamo uno script che prima esegue lo shuffle delle righe del file, e poi taglia il file alle prime 10k righe.

```python
import pandas as pd

# Read the CSV file into a DataFrame
df = pd.read_csv("output_data.csv")

# Shuffle the DataFrame
df_shuffled = df.sample(frac=1, random_state=42)

# Select the first 10000 rows
df_selected = df_shuffled.head(10000)

# Save the selected DataFrame to a new CSV file
selected_csv_filename = "shuffled_output_data.csv"
df_selected.to_csv(selected_csv_filename, index=False)

print(f"Selected DataFrame exported to {selected_csv_filename}")


```

Quindi adesso il file è di questo tipo:
![[Pasted image 20240306140539.png]]
## Evaluation
Il file "shuffled_output_data.csv" è il file necessario alla fase di evaluation.
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

![[Pasted image 20240306203613.png]]


| entity_type | Number of Occurrences | Percentage of Matches | Average Overlapping Index | Std Average Overlapping Index | Average Overlapping Index (Matched) | Std Average Overlapping Index (Matched) | Average Overlapping Index (Unmatched) | Std Average Overlapping Index (Unmatched) | Avg BBox Dimensions (Correct) | Std Avg BBox Dimensions (Correct) | Avg BBox Dimensions (Incorrect) | Std Avg BBox Dimensions (Incorrect) | Average BBox Dimensions (All) | Std Average BBox Dimensions (All) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Total | 5014 | 51.9745 | 0.4247 | 0.3987 | 0.7978 | 0.1096 | 0.0209 | 0.0651 | 0.0923 | 0.1061 | 0.0181 | 0.0353 | 0.0567 | 0.0885 |
| Painting | 924 | 42.0996 | 0.3362 | 0.3962 | 0.7927 | 0.1083 | 0.0043 | 0.0245 | 0.0841 | 0.1105 | 0.0132 | 0.0330 | 0.0431 | 0.0836 |
| Sofa | 693 | 73.5931 | 0.6256 | 0.3737 | 0.8451 | 0.0764 | 0.0137 | 0.0563 | 0.1147 | 0.1089 | 0.0249 | 0.0292 | 0.0910 | 0.1025 |
| Chair | 622 | 20.5788 | 0.1763 | 0.2915 | 0.7204 | 0.1278 | 0.0353 | 0.0777 | 0.0433 | 0.0422 | 0.0104 | 0.0134 | 0.0172 | 0.0261 |
| Dining Table | 588 | 66.8367 | 0.5339 | 0.3706 | 0.7835 | 0.1148 | 0.0309 | 0.0911 | 0.0861 | 0.0911 | 0.0142 | 0.0195 | 0.0622 | 0.0826 |
| Arm Chair | 420 | 49.0476 | 0.4136 | 0.3989 | 0.8092 | 0.1006 | 0.0329 | 0.0796 | 0.0789 | 0.0722 | 0.0234 | 0.0354 | 0.0506 | 0.0630 |
| TV Stand | 402 | 40.0498 | 0.3224 | 0.3792 | 0.7710 | 0.1260 | 0.0227 | 0.0673 | 0.0937 | 0.0795 | 0.0308 | 0.0441 | 0.0560 | 0.0681 |
| Floor Lamp | 300 | 63.3333 | 0.5032 | 0.3733 | 0.7739 | 0.1206 | 0.0356 | 0.0931 | 0.1257 | 0.1624 | 0.0356 | 0.0754 | 0.0927 | 0.1437 |
| Television | 148 | 75.0000 | 0.5976 | 0.3537 | 0.7952 | 0.0974 | 0.0047 | 0.0134 | 0.1173 | 0.1529 | 0.0271 | 0.0759 | 0.0947 | 0.1430 |
| House Plant | 144 | 68.7500 | 0.5263 | 0.3635 | 0.7608 | 0.1200 | 0.0103 | 0.0359 | 0.0589 | 0.0537 | 0.0047 | 0.0037 | 0.0419 | 0.0512 |
| Side Table | 110 | 45.4545 | 0.3623 | 0.3946 | 0.7831 | 0.1080 | 0.0117 | 0.0537 | 0.0530 | 0.0400 | 0.0203 | 0.0345 | 0.0352 | 0.0404 |
| Cart | 103 | 71.8447 | 0.5779 | 0.3698 | 0.8015 | 0.1051 | 0.0075 | 0.0179 | 0.0750 | 0.0566 | 0.0280 | 0.0431 | 0.0618 | 0.0571 |
| Shelving Unit | 102 | 54.9020 | 0.4811 | 0.4270 | 0.8607 | 0.0741 | 0.0189 | 0.0693 | 0.1817 | 0.1817 | 0.0232 | 0.0441 | 0.1102 | 0.1585 |
| Box | 102 | 32.3529 | 0.2398 | 0.3458 | 0.7319 | 0.0889 | 0.0044 | 0.0143 | 0.0300 | 0.0202 | 0.0064 | 0.0093 | 0.0140 | 0.0176 |
| Dresser | 96 | 64.5833 | 0.5571 | 0.4056 | 0.8499 | 0.0874 | 0.0231 | 0.0689 | 0.1281 | 0.0956 | 0.0245 | 0.0373 | 0.0914 | 0.0940 |
| Garbage Can | 81 | 66.6667 | 0.5185 | 0.3680 | 0.7686 | 0.1032 | 0.0185 | 0.0734 | 0.0386 | 0.0293 | 0.0055 | 0.0087 | 0.0276 | 0.0290 |
| Dog Bed | 69 | 47.8261 | 0.3880 | 0.4029 | 0.8004 | 0.0858 | 0.0099 | 0.0359 | 0.0431 | 0.0405 | 0.0115 | 0.0160 | 0.0266 | 0.0340 |
| Desk | 45 | 64.4444 | 0.5576 | 0.4010 | 0.8471 | 0.0787 | 0.0329 | 0.0662 | 0.1234 | 0.0873 | 0.0448 | 0.0554 | 0.0954 | 0.0857 |
| Coffee Table | 17 | 41.1765 | 0.3185 | 0.4032 | 0.7735 | 0.1516 | 0.0000 | 0.0000 | 0.0906 | 0.0712 | 0.0105 | 0.0145 | 0.0435 | 0.0606 |
| Room Decor | 12 | 8.3333 | 0.1109 | 0.2402 | 0.8512 | - | 0.0435 | 0.0605 | 0.1330 | - | 0.0515 | 0.0515 | 0.0583 | 0.0545 |
| Safe | 11 | 72.7273 | 0.5901 | 0.3829 | 0.8101 | 0.0818 | 0.0035 | 0.0061 | 0.0459 | 0.0278 | 0.0077 | 0.0084 | 0.0355 | 0.0295 |
| Boots | 10 | 40.0000 | 0.3299 | 0.4016 | 0.7936 | 0.0399 | 0.0207 | 0.0507 | 0.0296 | 0.0080 | 0.0024 | 0.0023 | 0.0133 | 0.0149 |
| Stool | 9 | 66.6667 | 0.4987 | 0.3845 | 0.7481 | 0.1128 | 0.0000 | 0.0000 | 0.0291 | 0.0353 | 0.0078 | 0.0034 | 0.0220 | 0.0300 |
| Ottoman | 6 | 33.3333 | 0.2842 | 0.4321 | 0.8420 | 0.0038 | 0.0053 | 0.0106 | 0.0800 | 0.0191 | 0.0062 | 0.0047 | 0.0308 | 0.0392 |

Per un dettaglio su come sono state calcolate queste statistiche si rimanda a questo documento: [[Calcolo statistiche per valutazione]]

I risultati sono di un'accuracy totale del 52%.
Da notare alcuni fatti interessanti:
1. L'overlapping index è notevolmente maggiore del 50% per le entità per cui è stato fatto un match corretto
2. L'overlapping index è notevolmente basso per le entità giudicate non correttamente

Inoltre se la cava notevolmente meglio su bounding box molto grandi (ergo quando l'oggetto è ben visibile) mentre non è molto performante su bounding box di piccole dimensioni.

Inoltre performa significativamente male sull'entità "Room Decor", probabilmente dovuto alla generalità del termine:

| Room Decor | 12 | 8.3333 |
| ---- | ---- | ---- |
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

```bash
<grounding><phrase>find the Cell on the Table</phrase>
```


## Evaluation su nuovo dataset

A differenza dell' evaluation sul dataset precedente, in questo dataset sono stati considerati anche gli oggetti di dimensione minore: i children. Questi oggetti sono normalmente trovati sopra ad altri, sono di dimensione minore rispetto all'oggetto "parent", e dunque risultano più difficili da individuare e categorizzare.
I risultati infatti sono nettamente inferiori a quelli ottenuti precedentemente

file: "zero_shot_pulito_final_statistics_dash.csv"

|   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|**entity_type**|**Number of Occurrences**|**Percentage of Matches**|**Average Overlapping Index**|**Std Average Overlapping Index**|**Average Overlapping Index (Matched)**|**Std Average Overlapping Index (Matched)**|**Average Overlapping Index (Unmatched)**|**Std Average Overlapping Index (Unmatched)**|**Avg BBox Dimensions (Correct)**|**Std Avg BBox Dimensions (Correct)**|**Avg BBox Dimensions (Incorrect)**|**Std Avg BBox Dimensions (Incorrect)**|**Average BBox Dimensions (All)**|**Std Average BBox Dimensions (All)**|
|**Total**|10000|23.0500|0.1842|0.3264|0.7680|0.1176|0.0094|0.0407|0.0748|0.1070|0.0062|0.0254|0.0220|0.0630|
|**Painting**|781|39.9488|0.3151|0.3883|0.7839|0.1029|0.0032|0.0136|0.0651|0.0868|0.0123|0.0219|0.0334|0.0630|
|**Cell Phone**|606|1.6502|0.0131|0.0783|0.6040|0.1021|0.0031|0.0107|0.0041|0.0020|0.0009|0.0039|0.0009|0.0039|
|**Remote Control**|506|0.5929|0.0071|0.0504|0.6162|0.0457|0.0034|0.0179|0.0069|0.0052|0.0008|0.0018|0.0008|0.0019|
|**Book**|466|8.7983|0.0669|0.1959|0.6832|0.1143|0.0075|0.0238|0.0160|0.0118|0.0018|0.0064|0.0030|0.0081|
|**Chair**|433|32.3326|0.2568|0.3412|0.7329|0.1137|0.0294|0.0740|0.0430|0.0364|0.0131|0.0183|0.0228|0.0292|
|**Pen**|372|0.0000|0.0012|0.0062|-|-|0.0012|0.0062|-|-|0.0003|0.0010|0.0003|0.0010|
|**Dining Table**|327|63.9144|0.5060|0.3698|0.7714|0.1157|0.0360|0.0924|0.0887|0.0896|0.0172|0.0234|0.0629|0.0806|
|**Key Chain**|219|0.0000|0.0050|0.0359|-|-|0.0050|0.0359|-|-|0.0013|0.0112|0.0013|0.0112|
|**Box**|218|12.3853|0.0989|0.2394|0.7190|0.1085|0.0113|0.0384|0.0291|0.0486|0.0049|0.0080|0.0079|0.0201|
|**Counter Top**|218|41.2844|0.3449|0.3961|0.8045|0.1200|0.0217|0.0550|0.1758|0.1508|0.0639|0.0955|0.1101|0.1331|
|**Bowl**|203|6.4039|0.0496|0.1632|0.6582|0.0830|0.0079|0.0284|0.0098|0.0059|0.0018|0.0042|0.0023|0.0048|
|**House Plant**|195|46.6667|0.3537|0.3603|0.7204|0.1218|0.0328|0.0938|0.0317|0.0323|0.0040|0.0042|0.0169|0.0261|
|**Television**|187|66.8449|0.5192|0.3705|0.7701|0.1129|0.0135|0.0614|0.0783|0.0942|0.0163|0.0331|0.0577|0.0844|
|**Bottle**|184|5.9783|0.0444|0.1656|0.6892|0.1190|0.0034|0.0081|0.0114|0.0079|0.0036|0.0330|0.0041|0.0321|
|**Sofa**|181|70.7182|0.6040|0.3848|0.8453|0.0849|0.0214|0.0750|0.1163|0.1085|0.0226|0.0273|0.0889|0.1018|
|**Plate**|176|3.4091|0.0284|0.1243|0.6761|0.0785|0.0055|0.0199|0.0111|0.0046|0.0015|0.0034|0.0018|0.0039|
|**Statue**|167|19.1617|0.1363|0.2673|0.6709|0.1044|0.0096|0.0394|0.0238|0.0259|0.0031|0.0057|0.0071|0.0148|
|**Laptop**|164|19.5122|0.1510|0.2857|0.7193|0.1112|0.0133|0.0249|0.0249|0.0209|0.0033|0.0046|0.0075|0.0132|
|**Dresser**|157|62.4204|0.5252|0.3918|0.8199|0.0967|0.0359|0.0836|0.1241|0.1146|0.0210|0.0384|0.0854|0.1059|
|**Fridge**|146|61.6438|0.5291|0.4165|0.8513|0.0868|0.0112|0.0469|0.1633|0.2260|0.0730|0.1382|0.1287|0.2013|
|**Bed**|143|60.1399|0.5043|0.4000|0.8184|0.1020|0.0304|0.0990|0.1391|0.1551|0.0283|0.0481|0.0949|0.1352|
|**Knife**|139|1.4388|0.0126|0.0843|0.6898|0.1670|0.0027|0.0126|0.0061|0.0006|0.0009|0.0029|0.0010|0.0030|
|**Fork**|138|0.7246|0.0052|0.0448|0.5245|-|0.0014|0.0051|0.0042|-|0.0005|0.0014|0.0005|0.0014|
|**Garbage Can**|132|59.0909|0.4465|0.3729|0.7485|0.0898|0.0102|0.0615|0.0251|0.0198|0.0048|0.0055|0.0168|0.0185|
|**Pillow**|132|14.3939|0.1102|0.2412|0.6783|0.1195|0.0147|0.0425|0.0178|0.0173|0.0037|0.0069|0.0057|0.0103|
|**Mug**|128|6.2500|0.0440|0.1598|0.6486|0.1223|0.0037|0.0134|0.0098|0.0032|0.0017|0.0089|0.0022|0.0089|
|**Spoon**|122|0.0000|0.0027|0.0090|-|-|0.0027|0.0090|-|-|0.0007|0.0018|0.0007|0.0018|
|**Wine Bottle**|114|7.0175|0.0599|0.1860|0.7004|0.0805|0.0115|0.0563|0.0171|0.0155|0.0058|0.0317|0.0066|0.0309|
|**Bread**|109|9.1743|0.0732|0.2092|0.7196|0.1038|0.0079|0.0163|0.0175|0.0095|0.0022|0.0038|0.0036|0.0063|
|**Arm Chair**|109|59.6330|0.4875|0.3998|0.8069|0.1086|0.0156|0.0428|0.0779|0.0747|0.0150|0.0168|0.0525|0.0662|
|**Spray Bottle**|107|17.7570|0.1273|0.2602|0.6687|0.1172|0.0104|0.0430|0.0134|0.0088|0.0014|0.0027|0.0035|0.0063|
|**Vase**|102|22.5490|0.1543|0.2855|0.6686|0.1289|0.0046|0.0137|0.0119|0.0128|0.0015|0.0020|0.0038|0.0076|
|**Cup**|94|3.1915|0.0236|0.1152|0.6423|0.1425|0.0032|0.0087|0.0069|0.0029|0.0012|0.0020|0.0014|0.0022|
|**Pencil**|89|1.1236|0.0066|0.0604|0.5701|-|0.0002|0.0009|0.0028|-|0.0001|0.0003|0.0001|0.0004|
|**Floor Lamp**|89|62.9213|0.4962|0.3785|0.7716|0.1314|0.0287|0.0782|0.1361|0.1740|0.0333|0.0718|0.0980|0.1526|
|**Toaster**|87|13.7931|0.1083|0.2482|0.7082|0.1344|0.0123|0.0350|0.0176|0.0180|0.0030|0.0055|0.0050|0.0097|
|**Kettle**|84|9.5238|0.0731|0.1991|0.6719|0.1139|0.0101|0.0193|0.0175|0.0103|0.0019|0.0040|0.0034|0.0067|
|**Spatula**|82|0.0000|0.0033|0.0156|-|-|0.0033|0.0156|-|-|0.0015|0.0057|0.0015|0.0057|
|**Credit Card**|82|0.0000|0.0071|0.0410|-|-|0.0071|0.0410|-|-|0.0047|0.0307|0.0047|0.0307|
|**Butter Knife**|76|0.0000|0.0020|0.0090|-|-|0.0020|0.0090|-|-|0.0003|0.0005|0.0003|0.0005|
|**Toilet**|75|62.6667|0.5214|0.3612|0.7804|0.1027|0.0865|0.1634|0.0951|0.0937|0.0177|0.0330|0.0662|0.0853|
|**Washing Machine**|74|62.1622|0.5168|0.3934|0.8132|0.1003|0.0299|0.0788|0.0841|0.0787|0.0166|0.0209|0.0586|0.0712|
|**Shelving Unit**|73|52.0548|0.4445|0.4278|0.8483|0.0805|0.0061|0.0209|0.1415|0.1837|0.0326|0.0637|0.0893|0.1492|
|**TV Stand**|69|17.3913|0.1519|0.2956|0.7661|0.1297|0.0226|0.0703|0.0722|0.0580|0.0254|0.0376|0.0336|0.0450|
|**Lettuce**|69|10.1449|0.0757|0.2079|0.6755|0.1088|0.0080|0.0327|0.0087|0.0030|0.0014|0.0022|0.0021|0.0032|
|**Sink**|69|75.3623|0.5726|0.3368|0.7575|0.0983|0.0070|0.0184|0.0595|0.0633|0.0360|0.0345|0.0537|0.0582|
|**Dish Sponge**|68|0.0000|0.0048|0.0204|-|-|0.0048|0.0204|-|-|0.0008|0.0015|0.0008|0.0015|
|**Newspaper**|68|2.9412|0.0208|0.1095|0.6335|0.1640|0.0023|0.0066|0.0165|0.0101|0.0013|0.0024|0.0017|0.0037|
|**Potato**|66|0.0000|0.0086|0.0351|-|-|0.0086|0.0351|-|-|0.0020|0.0092|0.0020|0.0092|
|**Apple**|64|1.5625|0.0115|0.0708|0.5575|-|0.0028|0.0143|0.0049|-|0.0010|0.0030|0.0011|0.0030|
|**Soap Bottle**|64|12.5000|0.0935|0.2353|0.6968|0.1143|0.0073|0.0351|0.0098|0.0039|0.0017|0.0029|0.0027|0.0040|
|**Watch**|63|0.0000|0.0005|0.0013|-|-|0.0005|0.0013|-|-|0.0002|0.0004|0.0002|0.0004|
|**Side Table**|60|35.0000|0.2818|0.3785|0.7796|0.1144|0.0137|0.0700|0.0520|0.0393|0.0142|0.0277|0.0274|0.0367|
|**Tomato**|59|6.7797|0.0487|0.1738|0.6856|0.0577|0.0023|0.0050|0.0088|0.0036|0.0006|0.0011|0.0012|0.0025|
|**Garbage Bag**|59|67.7966|0.4957|0.3523|0.7286|0.1075|0.0054|0.0220|0.0200|0.0196|0.0047|0.0048|0.0151|0.0178|
|**Pan**|54|5.5556|0.0489|0.1767|0.7234|0.1435|0.0092|0.0580|0.0195|0.0129|0.0017|0.0038|0.0027|0.0060|
|**Salt Shaker**|53|1.8868|0.0166|0.0960|0.6962|-|0.0035|0.0128|0.0040|-|0.0007|0.0014|0.0008|0.0014|
|**Faucet**|52|3.8462|0.0408|0.1367|0.6788|0.1187|0.0152|0.0435|0.0170|0.0181|0.0069|0.0130|0.0073|0.0131|
|**Pepper Shaker**|50|2.0000|0.0163|0.1039|0.7354|-|0.0016|0.0041|0.0064|-|0.0007|0.0009|0.0008|0.0012|
|**Teddy Bear**|46|50.0000|0.3567|0.3610|0.7036|0.1219|0.0099|0.0148|0.0181|0.0203|0.0034|0.0039|0.0108|0.0163|
|**Toilet Paper**|46|6.5217|0.0541|0.1602|0.6389|0.0499|0.0133|0.0352|0.0124|0.0072|0.0015|0.0033|0.0022|0.0045|
|**Stool**|44|36.3636|0.2859|0.3823|0.7780|0.1126|0.0046|0.0146|0.0342|0.0296|0.0043|0.0036|0.0151|0.0229|
|**Candle**|43|9.3023|0.0747|0.2113|0.6845|0.1623|0.0121|0.0639|0.0079|0.0037|0.0006|0.0013|0.0013|0.0027|
|**Baseball Bat**|43|16.2791|0.1341|0.2721|0.7279|0.1132|0.0186|0.0492|0.0296|0.0260|0.0063|0.0091|0.0101|0.0155|
|**Cart**|42|57.1429|0.4828|0.4147|0.8287|0.0973|0.0217|0.0887|0.0946|0.0742|0.0172|0.0222|0.0614|0.0693|
|**Microwave**|40|10.0000|0.0871|0.2202|0.7242|0.1147|0.0164|0.0373|0.0291|0.0171|0.0068|0.0064|0.0090|0.0103|
|**Desk Lamp**|40|17.5000|0.1530|0.2923|0.7626|0.0971|0.0237|0.0618|0.0351|0.0213|0.0075|0.0134|0.0123|0.0182|
|**Plunger**|39|17.9487|0.1315|0.2656|0.6755|0.0900|0.0125|0.0588|0.0117|0.0030|0.0030|0.0027|0.0046|0.0043|
|**Basket Ball**|37|35.1351|0.2735|0.3310|0.6874|0.1077|0.0493|0.1269|0.0091|0.0076|0.0022|0.0019|0.0046|0.0057|
|**Dog Bed**|34|32.3529|0.2709|0.3929|0.8290|0.0518|0.0040|0.0108|0.0407|0.0240|0.0055|0.0070|0.0169|0.0221|
|**Ladle**|33|0.0000|0.0052|0.0185|-|-|0.0052|0.0185|-|-|0.0013|0.0037|0.0013|0.0037|
|**Pot**|33|21.2121|0.1585|0.2923|0.6994|0.1389|0.0129|0.0283|0.0299|0.0170|0.0056|0.0136|0.0108|0.0173|
|**Paper Towel Roll**|32|6.2500|0.0492|0.1809|0.7362|0.0770|0.0034|0.0079|0.0169|0.0065|0.0023|0.0032|0.0032|0.0049|
|**Alarm Clock**|29|24.1379|0.1772|0.2615|0.6059|0.0602|0.0408|0.0970|0.0105|0.0072|0.0021|0.0030|0.0041|0.0056|
|**Tissue Box**|21|0.0000|0.0045|0.0087|-|-|0.0045|0.0087|-|-|0.0033|0.0044|0.0033|0.0044|
|**Egg**|20|0.0000|0.0007|0.0015|-|-|0.0007|0.0015|-|-|0.0004|0.0006|0.0004|0.0006|
|**Cloth**|17|0.0000|0.0084|0.0146|-|-|0.0084|0.0146|-|-|0.0019|0.0026|0.0019|0.0026|
|**Safe**|16|25.0000|0.1975|0.3535|0.7878|0.0726|0.0008|0.0019|0.0281|0.0279|0.0061|0.0056|0.0116|0.0166|
|**Desk**|15|46.6667|0.3720|0.4063|0.7874|0.0857|0.0085|0.0177|0.0747|0.0570|0.0342|0.0463|0.0531|0.0538|
|**Coffee Machine**|14|42.8571|0.2948|0.3490|0.6791|0.0803|0.0066|0.0100|0.0098|0.0040|0.0065|0.0093|0.0079|0.0075|
|**Tennis Racket**|13|7.6923|0.0771|0.2312|0.8443|-|0.0131|0.0184|0.0571|-|0.0021|0.0021|0.0063|0.0154|
|**Laundry Hamper**|7|57.1429|0.3849|0.3520|0.6623|0.0889|0.0150|0.0260|0.0138|0.0114|0.0091|0.0087|0.0118|0.0098|
|**Table Top Decor**|6|0.0000|0.0497|0.0501|-|-|0.0497|0.0501|-|-|0.0050|0.0070|0.0050|0.0070|
|**Vacuum Cleaner**|5|60.0000|0.4002|0.3662|0.6669|0.0366|0.0000|0.0000|0.0108|0.0007|0.0016|0.0020|0.0071|0.0052|
|**Soap Bar**|4|0.0000|0.0014|0.0012|-|-|0.0014|0.0012|-|-|0.0001|0.0000|0.0001|0.0000|
|**Room Decor**|4|0.0000|0.0021|0.0042|-|-|0.0021|0.0042|-|-|0.0100|0.0067|0.0100|0.0067|
|**Dumbbell**|2|50.0000|0.4110|0.5812|0.8220|-|0.0000|-|0.0295|-|0.0001|-|0.0148|0.0208|
|**Coffee Table**|1|100.0000|0.7247|-|0.7247|-|-|-|0.0194|-|-|-|0.0194|-|
|**Ottoman**|1|100.0000|0.8790|-|0.8790|-|-|-|0.0872|-|-|-|0.0872|-|


### Perché è andata così male

È chiaro che la dimensione dei bounding box ha nettamente influito sulle prestazioni del modello.

Prima la media dei bounding box per le entità non correttamente stimate era: 0,056
Adesso invece è: 0.0222

Quindi più della metà.
Curiosamente di un valore molto simile è diminuita la precisione:

| **entity_type** | **Number of Occurrences** | **Percentage of Matches** |
| ---- | ---- | ---- |
| **Total** | 10000 | 23.0500 |
Rispetto a quella precedente:

| entity_type | Number of Occurrences | Percentage of Matches |
| ---- | ---- | ---- |
| Total | 5014 | 51.9744 |
Un risultato che evidenzia chiaramente la correlazione che c'è tra dimensioni del bounding box e precisione.
Ho indagato questa relazione facendo una rappresentazione grafica tra la precisione sulle entità e la dimensione del loro bounding box:

La relazione sembra essere lineare per una buona parte del grafico:

![[plot 1.html]]

![[Pasted image 20240307121852.png]]

Poi con l'aumentare dei valori della dimensione media dei bounding box tende ad "appiattirsi" intorno al 60%.

![[Pasted image 20240307121826.png]]
Questo plot è stato fatto con il seguente codice: [[How i plot statistics, an example]]
In breve i punti sono le coppie di valori "Average BBox Dimension" e "Percentage od Matches" per ogni entità.
Un punto rosso indica un entità con poche occorrenze nel dataset e un punto verde indica un'entità con molte occorrenze.

Questo grafo secondo me evidenzia bene il limite di questo modello nel trovare un match quando l'entità è piccola. Ed evidenzia anche una certa predisposizione di questo modello a non superare una precisione del 60/70%, con la maggior parte dei punti che superano una certa dimensione (0.05 che ricordiamo essere la dimensione media dell'altro dataset) che adagiano sul 50% di precisione.

![[Pasted image 20240307124837.png]]

### Alcuni esempi

Qui sotto ci sono alcuni esempi commentati di "fallimenti" di kosmos2 sui nuovi dati

![[Pasted image 20240308152626.png]]

![[Pasted image 20240308152655.png]]

In entrambi questi casi il bounding box è completamente sbagliato (e non di poco). È chiaro che Kosmos ha difficoltà con bounding box molto piccoli, il risultato è simile a quando non vede proprio l'oggetto, cerca di fare il grounding con qualsiasi cosa riesca a trovare.


![[Pasted image 20240308152837.png]]

Quando invece l'oggetto è in primo piano ed è abbastanza riconoscibile non ha problemi

![[Pasted image 20240308152930.png]]

C'è sicuramente da dire che bisogna spezzare una lancia a favore di Kosmos: alcuni bounding box sono veramente troppo piccoli:

![[Pasted image 20240308153114.png]]

## Conclusioni
A mio parere questo modello, in zero shot, ha una precisione che si aggira intorno al 50-60% in condizioni ottimali (bounding box di una dimensione considerevole) e che rapidamente approccia valori di precisione bassi quando le dimensioni dei bounding box diminuiscono.

## Paternity test

Un'idea che è venuta fuori è stata quella di utilizzare le informazioni di parentela nel prompt: invece che passare al modello la richiesta di individuare un oggetto, si potrebbe passare l'oggetto e indicarne la posizione come "sopra" all'oggetto.
Per fare ciò ho dovuto modificare anche il file "output_data.csv" in modo tale che contenga le informazioni sull'entità dell'oggetto "parent".

Il risultato è questo:

| environment | entity_type | lexical_references | ... | bounding_box | parent_entity |
| ---- | ---- | ---- | ---- | ---- | ---- |
| 2336 | Spatula | ['spatula', 'wire', 'lanyard'] | ... | (0.5016666666666667, 0.6066666666666667, 0.6716666666666666, 0.6333333333333333) | Counter Top |
| 2355 | Fork | ['fork', 'napkin', 'scissors', 'glasses'] | ... | (0.82, 0.31, 0.8216666666666667, 0.31) | Counter Top |
| 3043 | Mug | ['mug', 'pocket', 'paperback'] | ... | (0.195, 0.345, 0.21666666666666667, 0.3616666666666667) | Dining Table |
Ho aggiunto al prompt l'informazione riguardante il padre dell'oggetto.

```python
def generate_prompt(entity_type, parent_entity=None):

	if isinstance(parent_entity, str):
		prompt = f"<grounding><phrase>{entity_type} on the {parent_entity}</phrase>"
	else:
		prompt = f"t<grounding><phrase>{entity_type}</phrase>"
	return [prompt]
```

Ho fatto l'evaluation.

| environment | entity_type | lexical_references | image_bbox | image_normal | bounding_box | parent_entity | kosmos_bounding_box | overlap_index | Match |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2336 | Spatula | ['spatula', 'wire', 'lanyard'] | Robocup/2336/images/Kitchen/bounding_box/position_1/2336_Kitchen_bounding_box_pos_1_90.jpg | Robocup/2336/images/Kitchen/normal/position_1/2336_Kitchen_pos_1_90.jpg | (0.5016666666666667, 0.6066666666666667, 0.6716666666666666, 0.6333333333333333) | Counter Top | (0.078125, 0.578125, 0.234375, 0.703125) | 0.0 | False |
| 2355 | Fork | ['fork', 'napkin', 'scissors', 'glasses'] | Robocup/2355/images/Kitchen/bounding_box/position_2/2355_Kitchen_bounding_box_pos_2_0.jpg | Robocup/2355/images/Kitchen/normal/position_2/2355_Kitchen_pos_2_0.jpg | (0.82, 0.31, 0.8216666666666667, 0.31) | Counter Top | (0.796875, 0.296875, 0.859375, 0.359375) | 0.0 | False |
| 3043 | Mug | ['mug', 'pocket', 'paperback'] | Rockin1/3043/images/Bathroom/bounding_box/position_0/3043_Bathroom_bounding_box_pos_0_270.jpg | Rockin1/3043/images/Bathroom/normal/position_0/3043_Bathroom_pos_0_270.jpg | (0.195, 0.345, 0.21666666666666667, 0.3616666666666667) | Dining Table | (0.140625, 0.296875, 0.203125, 0.359375) | 0.028139999372575285 | False |
| 2288 | Bed | ['bed', 'bedstand', 'nightstand', 'bedside', 'night'] | Robocup/2288/images/Bedroom/bounding_box/position_3/2288_Bedroom_bounding_box_pos_3_90.jpg | Robocup/2288/images/Bedroom/normal/position_3/2288_Bedroom_pos_3_90.jpg | (0.41, 0.29833333333333334, 0.6766666666666666, 0.41833333333333333) |  | (0.390625, 0.296875, 0.671875, 0.421875) | 0.8794822459331818 | True |

Ed infine ho computato le statistiche su questo file:

file: "zero_shot_pulito_paternity_final_statistics_dash.csv"

|   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|**entity_type**|**Number of Occurrences**|**Percentage of Matches**|**Average Overlapping Index**|**Std Average Overlapping Index**|**Average Overlapping Index (Matched)**|**Std Average Overlapping Index (Matched)**|**Average Overlapping Index (Unmatched)**|**Std Average Overlapping Index (Unmatched)**|**Avg BBox Dimensions (Correct)**|**Std Avg BBox Dimensions (Correct)**|**Avg BBox Dimensions (Incorrect)**|**Std Avg BBox Dimensions (Incorrect)**|**Average BBox Dimensions (All)**|**Std Average BBox Dimensions (All)**|
|**Total**|10000|22.5200|0.1884|0.3239|0.7697|0.1180|0.0194|0.0678|0.0753|0.1078|0.0066|0.0262|0.0220|0.0630|
|**Painting**|781|37.7721|0.3013|0.3851|0.7881|0.0992|0.0058|0.0302|0.0671|0.0885|0.0129|0.0227|0.0334|0.0630|
|**Cell Phone**|606|1.9802|0.0210|0.0990|0.6069|0.0917|0.0092|0.0525|0.0045|0.0018|0.0008|0.0039|0.0009|0.0039|
|**Remote Control**|506|0.5929|0.0115|0.0599|0.6356|0.0678|0.0078|0.0354|0.0069|0.0052|0.0008|0.0018|0.0008|0.0019|
|**Book**|466|8.5837|0.0697|0.1982|0.6927|0.1162|0.0113|0.0422|0.0160|0.0118|0.0018|0.0065|0.0030|0.0081|
|**Chair**|433|31.6397|0.2641|0.3349|0.7325|0.1178|0.0473|0.0940|0.0437|0.0365|0.0131|0.0182|0.0228|0.0292|
|**Pen**|372|0.0000|0.0029|0.0160|-|-|0.0029|0.0160|-|-|0.0003|0.0010|0.0003|0.0010|
|**Dining Table**|327|64.8318|0.5240|0.3645|0.7781|0.1134|0.0556|0.1216|0.0878|0.0893|0.0170|0.0236|0.0629|0.0806|
|**Key Chain**|219|0.0000|0.0104|0.0494|-|-|0.0104|0.0494|-|-|0.0013|0.0112|0.0013|0.0112|
|**Box**|218|11.9266|0.1090|0.2473|0.7379|0.1039|0.0239|0.0834|0.0293|0.0496|0.0050|0.0080|0.0079|0.0201|
|**Counter Top**|218|39.4495|0.3344|0.3904|0.8045|0.1182|0.0281|0.0618|0.1757|0.1554|0.0675|0.0949|0.1101|0.1331|
|**Bowl**|203|6.8966|0.0649|0.1757|0.6517|0.1006|0.0214|0.0701|0.0097|0.0057|0.0018|0.0042|0.0023|0.0048|
|**House Plant**|195|46.1538|0.3660|0.3541|0.7204|0.1213|0.0621|0.1393|0.0318|0.0324|0.0042|0.0046|0.0169|0.0261|
|**Television**|187|65.7754|0.5208|0.3634|0.7708|0.1083|0.0403|0.1022|0.0780|0.0946|0.0187|0.0366|0.0577|0.0844|
|**Bottle**|184|4.3478|0.0442|0.1489|0.6846|0.1194|0.0151|0.0549|0.0118|0.0084|0.0037|0.0327|0.0041|0.0321|
|**Sofa**|181|69.6133|0.5935|0.3902|0.8451|0.0868|0.0171|0.0640|0.1177|0.1089|0.0229|0.0269|0.0889|0.1018|
|**Plate**|176|3.9773|0.0396|0.1355|0.6528|0.0946|0.0142|0.0498|0.0100|0.0051|0.0014|0.0034|0.0018|0.0039|
|**Statue**|167|17.3653|0.1469|0.2635|0.6822|0.1108|0.0344|0.0905|0.0249|0.0270|0.0034|0.0058|0.0071|0.0148|
|**Laptop**|164|19.5122|0.1915|0.2828|0.7009|0.1212|0.0680|0.1315|0.0230|0.0201|0.0038|0.0070|0.0075|0.0132|
|**Dresser**|157|59.2357|0.4990|0.4026|0.8249|0.0920|0.0254|0.0662|0.1277|0.1162|0.0239|0.0399|0.0854|0.1059|
|**Fridge**|146|60.2740|0.5196|0.4203|0.8548|0.0846|0.0112|0.0454|0.1722|0.2312|0.0627|0.1189|0.1287|0.2013|
|**Bed**|143|57.3427|0.4903|0.3938|0.8145|0.1125|0.0546|0.1156|0.1351|0.1490|0.0410|0.0901|0.0949|0.1352|
|**Knife**|139|1.4388|0.0225|0.1018|0.6898|0.1670|0.0128|0.0606|0.0061|0.0006|0.0009|0.0029|0.0010|0.0030|
|**Fork**|138|0.0000|0.0019|0.0076|-|-|0.0019|0.0076|-|-|0.0005|0.0014|0.0005|0.0014|
|**Garbage Can**|132|58.3333|0.4425|0.3744|0.7509|0.0887|0.0109|0.0595|0.0254|0.0198|0.0048|0.0054|0.0168|0.0185|
|**Pillow**|132|15.9091|0.1420|0.2629|0.7005|0.1219|0.0363|0.0936|0.0193|0.0179|0.0032|0.0052|0.0057|0.0103|
|**Mug**|128|5.4688|0.0388|0.1534|0.6619|0.1256|0.0028|0.0125|0.0095|0.0033|0.0018|0.0089|0.0022|0.0089|
|**Spoon**|122|0.0000|0.0011|0.0044|-|-|0.0011|0.0044|-|-|0.0007|0.0018|0.0007|0.0018|
|**Wine Bottle**|114|7.0175|0.0908|0.1944|0.6969|0.0838|0.0451|0.1005|0.0158|0.0164|0.0059|0.0317|0.0066|0.0309|
|**Bread**|109|10.0917|0.0997|0.2176|0.7027|0.0940|0.0320|0.0769|0.0134|0.0090|0.0025|0.0049|0.0036|0.0063|
|**Arm Chair**|109|57.7982|0.4810|0.4042|0.8164|0.1005|0.0217|0.0710|0.0799|0.0750|0.0150|0.0164|0.0525|0.0662|
|**Spray Bottle**|107|19.6262|0.1631|0.2651|0.6603|0.1141|0.0417|0.0928|0.0132|0.0085|0.0012|0.0021|0.0035|0.0063|
|**Vase**|102|19.6078|0.1644|0.2747|0.6673|0.1324|0.0418|0.1110|0.0121|0.0137|0.0018|0.0027|0.0038|0.0076|
|**Cup**|94|2.1277|0.0320|0.1185|0.7036|0.1344|0.0174|0.0635|0.0081|0.0028|0.0012|0.0020|0.0014|0.0022|
|**Pencil**|89|1.1236|0.0067|0.0605|0.5701|-|0.0003|0.0029|0.0028|-|0.0001|0.0003|0.0001|0.0004|
|**Floor Lamp**|89|61.7978|0.4860|0.3805|0.7691|0.1368|0.0282|0.0770|0.1384|0.1747|0.0325|0.0708|0.0980|0.1526|
|**Toaster**|87|18.3908|0.1560|0.2738|0.6885|0.1159|0.0360|0.0991|0.0153|0.0161|0.0027|0.0054|0.0050|0.0097|
|**Kettle**|84|7.1429|0.0625|0.1750|0.6602|0.1200|0.0165|0.0457|0.0179|0.0116|0.0022|0.0047|0.0034|0.0067|
|**Spatula**|82|0.0000|0.0045|0.0232|-|-|0.0045|0.0232|-|-|0.0015|0.0057|0.0015|0.0057|
|**Credit Card**|82|0.0000|0.0086|0.0410|-|-|0.0086|0.0410|-|-|0.0047|0.0307|0.0047|0.0307|
|**Butter Knife**|76|0.0000|0.0019|0.0070|-|-|0.0019|0.0070|-|-|0.0003|0.0005|0.0003|0.0005|
|**Toilet**|75|65.3333|0.5309|0.3521|0.7695|0.1140|0.0814|0.1424|0.0914|0.0934|0.0187|0.0341|0.0662|0.0853|
|**Washing Machine**|74|63.5135|0.5266|0.3893|0.8113|0.1000|0.0311|0.0799|0.0825|0.0787|0.0170|0.0212|0.0586|0.0712|
|**Shelving Unit**|73|52.0548|0.4378|0.4235|0.8349|0.1044|0.0067|0.0219|0.1341|0.1834|0.0406|0.0764|0.0893|0.1492|
|**TV Stand**|69|23.1884|0.1998|0.3306|0.7658|0.1391|0.0289|0.0951|0.0666|0.0569|0.0236|0.0358|0.0336|0.0450|
|**Lettuce**|69|10.1449|0.0988|0.2191|0.6755|0.1088|0.0337|0.0995|0.0087|0.0030|0.0014|0.0022|0.0021|0.0032|
|**Sink**|69|69.5652|0.5407|0.3556|0.7671|0.0967|0.0234|0.0646|0.0615|0.0638|0.0361|0.0385|0.0537|0.0582|
|**Dish Sponge**|68|0.0000|0.0093|0.0547|-|-|0.0093|0.0547|-|-|0.0008|0.0015|0.0008|0.0015|
|**Newspaper**|68|4.4118|0.0417|0.1458|0.6690|0.1313|0.0127|0.0492|0.0149|0.0076|0.0011|0.0020|0.0017|0.0037|
|**Potato**|66|0.0000|0.0041|0.0141|-|-|0.0041|0.0141|-|-|0.0020|0.0092|0.0020|0.0092|
|**Apple**|64|0.0000|0.0122|0.0555|-|-|0.0122|0.0555|-|-|0.0011|0.0030|0.0011|0.0030|
|**Soap Bottle**|64|10.9375|0.1200|0.2333|0.6978|0.1274|0.0490|0.1125|0.0091|0.0038|0.0019|0.0033|0.0027|0.0040|
|**Watch**|63|0.0000|0.0007|0.0015|-|-|0.0007|0.0015|-|-|0.0002|0.0004|0.0002|0.0004|
|**Side Table**|60|40.0000|0.3206|0.3791|0.7661|0.1191|0.0236|0.0783|0.0471|0.0390|0.0143|0.0288|0.0274|0.0367|
|**Tomato**|59|8.4746|0.0765|0.1912|0.6491|0.0956|0.0235|0.0742|0.0083|0.0033|0.0005|0.0008|0.0012|0.0025|
|**Garbage Bag**|59|66.1017|0.4893|0.3549|0.7320|0.1067|0.0161|0.0714|0.0203|0.0198|0.0049|0.0047|0.0151|0.0178|
|**Pan**|54|3.7037|0.0383|0.1550|0.8005|0.0746|0.0089|0.0348|0.0246|0.0131|0.0019|0.0039|0.0027|0.0060|
|**Salt Shaker**|53|0.0000|0.0229|0.0814|-|-|0.0229|0.0814|-|-|0.0008|0.0014|0.0008|0.0014|
|**Faucet**|52|5.7692|0.0912|0.1475|0.5853|0.0740|0.0609|0.0818|0.0067|0.0053|0.0073|0.0134|0.0073|0.0131|
|**Pepper Shaker**|50|0.0000|0.0117|0.0493|-|-|0.0117|0.0493|-|-|0.0008|0.0012|0.0008|0.0012|
|**Teddy Bear**|46|45.6522|0.3469|0.3639|0.7233|0.1136|0.0307|0.0975|0.0190|0.0211|0.0039|0.0040|0.0108|0.0163|
|**Toilet Paper**|46|6.5217|0.0557|0.1522|0.6058|0.0315|0.0173|0.0405|0.0167|0.0021|0.0012|0.0023|0.0022|0.0045|
|**Stool**|44|36.3636|0.2857|0.3824|0.7780|0.1126|0.0044|0.0133|0.0342|0.0296|0.0043|0.0036|0.0151|0.0229|
|**Candle**|43|4.6512|0.0636|0.1724|0.7045|0.2633|0.0323|0.0890|0.0058|0.0005|0.0011|0.0025|0.0013|0.0027|
|**Baseball Bat**|43|16.2791|0.1384|0.2740|0.7279|0.1132|0.0238|0.0698|0.0296|0.0260|0.0063|0.0091|0.0101|0.0155|
|**Cart**|42|50.0000|0.4287|0.4264|0.8448|0.0776|0.0125|0.0549|0.1035|0.0752|0.0194|0.0219|0.0614|0.0693|
|**Microwave**|40|10.0000|0.0869|0.2193|0.7068|0.1428|0.0180|0.0551|0.0257|0.0207|0.0072|0.0068|0.0090|0.0103|
|**Desk Lamp**|40|20.0000|0.1696|0.3078|0.7659|0.0904|0.0205|0.0514|0.0344|0.0199|0.0068|0.0130|0.0123|0.0182|
|**Plunger**|39|17.9487|0.1324|0.2670|0.6787|0.0948|0.0129|0.0590|0.0107|0.0030|0.0032|0.0033|0.0046|0.0043|
|**Basket Ball**|37|35.1351|0.2669|0.3340|0.6902|0.1031|0.0376|0.1137|0.0092|0.0075|0.0021|0.0017|0.0046|0.0057|
|**Dog Bed**|34|26.4706|0.2237|0.3752|0.8383|0.0529|0.0025|0.0070|0.0401|0.0237|0.0085|0.0143|0.0169|0.0221|
|**Ladle**|33|0.0000|0.0016|0.0064|-|-|0.0016|0.0064|-|-|0.0013|0.0037|0.0013|0.0037|
|**Pot**|33|21.2121|0.1657|0.3035|0.7177|0.1475|0.0171|0.0660|0.0299|0.0170|0.0056|0.0136|0.0108|0.0173|
|**Paper Towel Roll**|32|6.2500|0.0724|0.2024|0.8065|0.0556|0.0235|0.0635|0.0169|0.0065|0.0023|0.0032|0.0032|0.0049|
|**Alarm Clock**|29|27.5862|0.2029|0.2673|0.6032|0.0778|0.0503|0.0967|0.0094|0.0073|0.0021|0.0031|0.0041|0.0056|
|**Tissue Box**|21|0.0000|0.0018|0.0037|-|-|0.0018|0.0037|-|-|0.0033|0.0044|0.0033|0.0044|
|**Egg**|20|0.0000|0.0104|0.0464|-|-|0.0104|0.0464|-|-|0.0004|0.0006|0.0004|0.0006|
|**Cloth**|17|0.0000|0.0167|0.0262|-|-|0.0167|0.0262|-|-|0.0019|0.0026|0.0019|0.0026|
|**Safe**|16|25.0000|0.2072|0.3482|0.7878|0.0726|0.0136|0.0214|0.0281|0.0279|0.0061|0.0056|0.0116|0.0166|
|**Desk**|15|33.3333|0.2923|0.3701|0.7829|0.0850|0.0470|0.0966|0.0792|0.0673|0.0401|0.0440|0.0531|0.0538|
|**Coffee Machine**|14|35.7143|0.2668|0.3322|0.6839|0.0884|0.0351|0.0791|0.0091|0.0040|0.0073|0.0090|0.0079|0.0075|
|**Tennis Racket**|13|7.6923|0.1319|0.2542|0.8443|-|0.0726|0.1432|0.0571|-|0.0021|0.0021|0.0063|0.0154|
|**Laundry Hamper**|7|28.5714|0.1892|0.3237|0.6591|0.1022|0.0012|0.0020|0.0204|0.0135|0.0084|0.0068|0.0118|0.0098|
|**Table Top Decor**|6|0.0000|0.0538|0.0385|-|-|0.0538|0.0385|-|-|0.0050|0.0070|0.0050|0.0070|
|**Vacuum Cleaner**|5|60.0000|0.4002|0.3662|0.6669|0.0366|0.0000|0.0000|0.0108|0.0007|0.0016|0.0020|0.0071|0.0052|
|**Soap Bar**|4|0.0000|0.0013|0.0018|-|-|0.0013|0.0018|-|-|0.0001|0.0000|0.0001|0.0000|
|**Room Decor**|4|0.0000|0.0110|0.0219|-|-|0.0110|0.0219|-|-|0.0100|0.0067|0.0100|0.0067|
|**Dumbbell**|2|50.0000|0.4224|0.5651|0.8220|-|0.0228|-|0.0295|-|0.0001|-|0.0148|0.0208|
|**Coffee Table**|1|100.0000|0.7769|-|0.7769|-|-|-|0.0194|-|-|-|0.0194|-|
|**Ottoman**|1|100.0000|0.8790|-|0.8790|-|-|-|0.0872|-|-|-|0.0872|-|
Come si può evincere, questo risultato è stato un fallimento. Le prestazioni sono addirittura leggermente inferiori all'esperimento precedente. Inoltre il problema non sembra essere la formulazione del prompt: ho effettuato alcuni esperimenti su piccoli batch di dati con prompt leggermente differenti, e il risultato è pressochè lo stesso. Chiaramente il problema non è risolvibile con un po' di prompt engineering.

### Alcuni esempi dei tipi di prompt che ho sperimentato:

```python
def generate_prompt(entity_type, parent_entity=None):

	if isinstance(parent_entity, str):
		prompt = f"<grounding><phrase>there is a {entity_type} on the {parent_entity}</phrase>"
	else:
		prompt = f"t<grounding><phrase>there is a {entity_type}</phrase>"
	return [prompt]
```

```python
def generate_prompt(entity_type, parent_entity=None):

	if isinstance(parent_entity, str):
		prompt = f"<grounding><phrase>this is a {entity_type} on the {parent_entity}</phrase>"
	else:
		prompt = f"t<grounding><phrase>this is a {entity_type}</phrase>"
	return [prompt]
```

ottenendo risultati equivalenti al prompt che ho utilizzato infine già riportato precedentemente:

```python
def generate_prompt(entity_type, parent_entity=None):

	if isinstance(parent_entity, str):
		prompt = f"<grounding><phrase>{entity_type} on the {parent_entity}</phrase>"
	else:
		prompt = f"t<grounding><phrase>{entity_type}</phrase>"
	return [prompt]
```
### Alcuni esempi di paternità

Qui ci sono alcuni esempi rilevanti in cui paternità ha fatto meglio:
![[Pasted image 20240314112440.png]]

![[Pasted image 20240314112530.png]]
In questi due casi "virtuosi", kosmos è stato in grado di trovare l'entità che non era riuscito a trovare senza aiuto da parte della relazione di "parent entity".

Non sempre però questo avviene:

![[Pasted image 20240314112815.png]]

![[Pasted image 20240314112609.png]]

![[Pasted image 20240314112856.png]]

![[Pasted image 20240314113113.png]]

Molte di queste "divergenze" sono su dipinti, in effetti questo torna con i dati (con paternity la percentuale di match è leggermente minore)

| **entity_type** | **Percentage of Matches** |
| ---- | ---- |
| **Total** | 22.5200 |
| Painting | 39.9457 |

| **entity_type** | **Percentage of Matches** |
| ---- | ---- |
| **Total** | 23.0500 |
| Painting | 40.3462 |
## Lexical references

Un altro esperimento che abbiamo portato avanti è stato di utilizzare, invece del nome dell'entità, le lexical references.
Questo esperimento è stato fatto non tanto per vedere se le lexical refereneces potessero risolvere il problema di prestazioni, ma piuttosto per vedere quanto decadono le prestazioni se ci riferiamo agli oggetti con i termini più disparati

Attraverso uno [[script per modificare output_data.csv per sostituire entity type con le lexical references| script]] ho creato un file che invece del nome dell'entità ha una delle lexical references

| **environment** | **entity_type** | **image_bbox** | **image_normal** | **bounding_box** |
| ---- | ---- | ---- | ---- | ---- |
| **2380** | phone | Robocup/2380/images/LivingRoom/bounding_box/position_1/2380_LivingRoom_bounding_box_pos_1_180.jpg | Robocup/2380/images/LivingRoom/normal/position_1/2380_LivingRoom_pos_1_180.jpg | (0.465, 0.31333333333333335, 0.475, 0.31333333333333335) |
| **2304** | keys | Robocup/2304/images/Bedroom/bounding_box/position_1/2304_Bedroom_bounding_box_pos_1_90.jpg | Robocup/2304/images/Bedroom/normal/position_1/2304_Bedroom_pos_1_90.jpg | (0.0, 0.425, 0.006666666666666667, 0.43) |
| **3489** | jar | Release1/3489/images/Kitchen/bounding_box/position_6/3489_Kitchen_bounding_box_pos_6_0.jpg | Release1/3489/images/Kitchen/normal/position_6/3489_Kitchen_pos_6_0.jpg | (0.5583333333333333, 0.2683333333333333, 0.575, 0.29) |
| **2192** | jam | Robocup/2192/images/Kitchen/bounding_box/position_1/2192_Kitchen_bounding_box_pos_1_90.jpg | Robocup/2192/images/Kitchen/normal/position_1/2192_Kitchen_pos_1_90.jpg | (0.49166666666666664, 0.375, 0.52, 0.39) |

Risultati precedenti:

| Total | 10000 | 22.1100 | 0.1864 | 0.3211 | 0.7676 | 0.1178 | 0.0215 | 0.0731 | 0.0752 | 0.1074 | 0.0070 | 0.0279 | 0.0221 | 0.0629 |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
Quindi ho avviato l'evaluation. Il risultato è stato il seguente:

file: lexical_reference_zero_shot_final_statistics_dash.csv

| **entity_type** | **Number of Occurrences** | **Percentage of Matches** | **Average Overlapping Index** | **Std Average Overlapping Index** | **Average Overlapping Index (Matched)** | **Std Average Overlapping Index (Matched)** | **Average Overlapping Index (Unmatched)** | **Std Average Overlapping Index (Unmatched)** | **Avg BBox Dimensions (Correct)** | **Std Avg BBox Dimensions (Correct)** | **Avg BBox Dimensions (Incorrect)** | **Std Avg BBox Dimensions (Incorrect)** | **Average BBox Dimensions (All)** | **Std Average BBox Dimensions (All)** |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| **Total** | 10000 | 19.2300 | 0.1557 | 0.3062 | 0.7696 | 0.1170 | 0.0096 | 0.0412 | 0.0772 | 0.1134 | 0.0063 | 0.0258 | 0.0199 | 0.0616 |
| **picture** | 224 | 44.1964 | 0.3646 | 0.3881 | 0.7866 | 0.0940 | 0.0305 | 0.0962 | 0.0613 | 0.0879 | 0.0189 | 0.0297 | 0.0376 | 0.0658 |
| **poster** | 219 | 46.1187 | 0.3548 | 0.3887 | 0.7667 | 0.1064 | 0.0022 | 0.0088 | 0.0496 | 0.0765 | 0.0130 | 0.0197 | 0.0299 | 0.0568 |
| **painting** | 217 | 48.8479 | 0.3806 | 0.3894 | 0.7707 | 0.1005 | 0.0081 | 0.0375 | 0.0680 | 0.1015 | 0.0187 | 0.0277 | 0.0427 | 0.0775 |
| **message** | 209 | 0.0000 | 0.0029 | 0.0178 | - | - | 0.0029 | 0.0178 | - | - | 0.0006 | 0.0015 | 0.0006 | 0.0015 |
| **cellphone** | 205 | 0.9756 | 0.0083 | 0.0633 | 0.6406 | 0.0173 | 0.0021 | 0.0073 | 0.0079 | 0.0004 | 0.0007 | 0.0016 | 0.0008 | 0.0017 |
| **answer machine** | 204 | 0.4902 | 0.0058 | 0.0480 | 0.6255 | - | 0.0028 | 0.0202 | 0.0052 | - | 0.0014 | 0.0125 | 0.0014 | 0.0125 |
| **radio** | 203 | 1.4778 | 0.0127 | 0.0826 | 0.6725 | 0.0373 | 0.0028 | 0.0161 | 0.0072 | 0.0028 | 0.0014 | 0.0126 | 0.0015 | 0.0125 |
| **answer** | 189 | 0.5291 | 0.0072 | 0.0434 | 0.5248 | - | 0.0044 | 0.0213 | 0.0031 | - | 0.0016 | 0.0130 | 0.0016 | 0.0130 |
| **cell** | 184 | 0.0000 | 0.0036 | 0.0262 | - | - | 0.0036 | 0.0262 | - | - | 0.0007 | 0.0017 | 0.0007 | 0.0017 |
| **telephone** | 178 | 2.2472 | 0.0170 | 0.0998 | 0.6697 | 0.0594 | 0.0020 | 0.0071 | 0.0058 | 0.0016 | 0.0015 | 0.0135 | 0.0016 | 0.0133 |
| **phone** | 173 | 1.1561 | 0.0101 | 0.0787 | 0.7343 | 0.0286 | 0.0016 | 0.0040 | 0.0066 | 0.0026 | 0.0007 | 0.0019 | 0.0008 | 0.0020 |
| **controller** | 173 | 1.1561 | 0.0102 | 0.0775 | 0.7217 | 0.0799 | 0.0019 | 0.0043 | 0.0126 | 0.0042 | 0.0009 | 0.0021 | 0.0010 | 0.0025 |
| **stereo** | 167 | 0.5988 | 0.0091 | 0.0617 | 0.6290 | - | 0.0054 | 0.0385 | 0.0056 | - | 0.0008 | 0.0018 | 0.0009 | 0.0018 |
| **remote** | 161 | 3.1056 | 0.0236 | 0.1164 | 0.6449 | 0.1333 | 0.0036 | 0.0261 | 0.0081 | 0.0054 | 0.0007 | 0.0017 | 0.0009 | 0.0023 |
| **book** | 153 | 7.8431 | 0.0576 | 0.1840 | 0.6752 | 0.1167 | 0.0050 | 0.0143 | 0.0218 | 0.0154 | 0.0019 | 0.0046 | 0.0035 | 0.0081 |
| **remote control** | 145 | 1.3793 | 0.0113 | 0.0716 | 0.5985 | 0.0983 | 0.0030 | 0.0141 | 0.0116 | 0.0071 | 0.0009 | 0.0027 | 0.0010 | 0.0031 |
| **reading** | 136 | 7.3529 | 0.0540 | 0.1854 | 0.6991 | 0.1231 | 0.0028 | 0.0102 | 0.0170 | 0.0084 | 0.0019 | 0.0042 | 0.0031 | 0.0061 |
| **catalogue** | 131 | 6.1069 | 0.0462 | 0.1725 | 0.7152 | 0.0806 | 0.0027 | 0.0087 | 0.0209 | 0.0101 | 0.0019 | 0.0037 | 0.0030 | 0.0063 |
| **chair** | 129 | 19.3798 | 0.2090 | 0.2904 | 0.7516 | 0.1082 | 0.0786 | 0.1159 | 0.0509 | 0.0471 | 0.0132 | 0.0179 | 0.0205 | 0.0300 |
| **seat** | 113 | 23.8938 | 0.2142 | 0.2911 | 0.6997 | 0.1268 | 0.0618 | 0.0914 | 0.0415 | 0.0329 | 0.0109 | 0.0120 | 0.0183 | 0.0231 |
| **table** | 107 | 54.2056 | 0.4279 | 0.3834 | 0.7672 | 0.1153 | 0.0264 | 0.0720 | 0.0742 | 0.0610 | 0.0277 | 0.0480 | 0.0529 | 0.0599 |
| **cake** | 104 | 0.0000 | 0.0016 | 0.0067 | - | - | 0.0016 | 0.0067 | - | - | 0.0004 | 0.0019 | 0.0004 | 0.0019 |
| **pen** | 97 | 0.0000 | 0.0006 | 0.0019 | - | - | 0.0006 | 0.0019 | - | - | 0.0003 | 0.0009 | 0.0003 | 0.0009 |
| **dining table** | 95 | 64.2105 | 0.5055 | 0.3784 | 0.7748 | 0.1215 | 0.0224 | 0.0810 | 0.0766 | 0.0661 | 0.0189 | 0.0211 | 0.0559 | 0.0610 |
| **laptop** | 84 | 21.4286 | 0.1696 | 0.3103 | 0.7455 | 0.1434 | 0.0125 | 0.0260 | 0.0274 | 0.0243 | 0.0029 | 0.0044 | 0.0081 | 0.0154 |
| **television** | 71 | 60.5634 | 0.4648 | 0.3888 | 0.7674 | 0.1191 | 0.0000 | 0.0001 | 0.1123 | 0.1547 | 0.0138 | 0.0239 | 0.0734 | 0.1301 |
| **worktop** | 69 | 43.4783 | 0.3635 | 0.4140 | 0.8244 | 0.1099 | 0.0089 | 0.0280 | 0.1538 | 0.1280 | 0.0569 | 0.0891 | 0.0990 | 0.1173 |
| **keys** | 69 | 0.0000 | 0.0006 | 0.0017 | - | - | 0.0006 | 0.0017 | - | - | 0.0003 | 0.0007 | 0.0003 | 0.0007 |
| **glass** | 69 | 4.3478 | 0.0336 | 0.1289 | 0.6170 | 0.0342 | 0.0071 | 0.0304 | 0.0124 | 0.0062 | 0.0029 | 0.0133 | 0.0033 | 0.0132 |
| **juice** | 65 | 6.1538 | 0.0464 | 0.1555 | 0.5982 | 0.1291 | 0.0102 | 0.0577 | 0.0137 | 0.0164 | 0.0018 | 0.0033 | 0.0026 | 0.0056 |
| **coke** | 63 | 1.5873 | 0.0198 | 0.0850 | 0.5014 | - | 0.0121 | 0.0590 | 0.0062 | - | 0.0017 | 0.0030 | 0.0018 | 0.0031 |
| **key chain** | 63 | 0.0000 | 0.0004 | 0.0015 | - | - | 0.0004 | 0.0015 | - | - | 0.0004 | 0.0008 | 0.0004 | 0.0008 |
| **indoor plant** | 63 | 44.4444 | 0.3195 | 0.3531 | 0.7008 | 0.1092 | 0.0144 | 0.0485 | 0.0265 | 0.0209 | 0.0056 | 0.0128 | 0.0149 | 0.0198 |
| **bag** | 62 | 8.0645 | 0.0683 | 0.1846 | 0.6655 | 0.1333 | 0.0159 | 0.0347 | 0.0111 | 0.0129 | 0.0042 | 0.0055 | 0.0048 | 0.0065 |
| **handbag** | 61 | 13.1148 | 0.0963 | 0.2172 | 0.6361 | 0.0973 | 0.0148 | 0.0393 | 0.0184 | 0.0148 | 0.0051 | 0.0094 | 0.0068 | 0.0111 |
| **case** | 61 | 1.6393 | 0.0286 | 0.1104 | 0.8421 | - | 0.0151 | 0.0315 | 0.0338 | - | 0.0055 | 0.0065 | 0.0059 | 0.0074 |
| **bottle of water** | 60 | 6.6667 | 0.0491 | 0.1803 | 0.7060 | 0.1499 | 0.0021 | 0.0051 | 0.0181 | 0.0145 | 0.0016 | 0.0024 | 0.0027 | 0.0058 |
| **drink** | 59 | 6.7797 | 0.0571 | 0.1757 | 0.6546 | 0.1324 | 0.0136 | 0.0616 | 0.0102 | 0.0057 | 0.0024 | 0.0056 | 0.0029 | 0.0059 |
| **bottle** | 59 | 3.3898 | 0.0291 | 0.1398 | 0.7680 | 0.0041 | 0.0032 | 0.0075 | 0.0080 | 0.0034 | 0.0009 | 0.0010 | 0.0011 | 0.0017 |
| **statue** | 59 | 20.3390 | 0.1436 | 0.2762 | 0.6732 | 0.1286 | 0.0084 | 0.0208 | 0.0173 | 0.0130 | 0.0021 | 0.0030 | 0.0052 | 0.0088 |
| **utensil** | 59 | 0.0000 | 0.0057 | 0.0148 | - | - | 0.0057 | 0.0148 | - | - | 0.0019 | 0.0060 | 0.0019 | 0.0060 |
| **cigarettes** | 58 | 13.7931 | 0.0952 | 0.2121 | 0.6105 | 0.0919 | 0.0127 | 0.0291 | 0.0109 | 0.0099 | 0.0053 | 0.0079 | 0.0060 | 0.0083 |
| **box** | 58 | 10.3448 | 0.0881 | 0.2222 | 0.7107 | 0.1366 | 0.0163 | 0.0497 | 0.0140 | 0.0060 | 0.0049 | 0.0079 | 0.0058 | 0.0082 |
| **pack** | 57 | 8.7719 | 0.0818 | 0.2065 | 0.7116 | 0.1436 | 0.0213 | 0.0507 | 0.0133 | 0.0066 | 0.0063 | 0.0097 | 0.0069 | 0.0096 |
| **tv** | 57 | 75.4386 | 0.5937 | 0.3485 | 0.7812 | 0.1187 | 0.0181 | 0.0677 | 0.0902 | 0.1229 | 0.0145 | 0.0254 | 0.0716 | 0.1120 |
| **flower** | 56 | 42.8571 | 0.3119 | 0.3665 | 0.7193 | 0.1331 | 0.0063 | 0.0179 | 0.0352 | 0.0358 | 0.0069 | 0.0134 | 0.0190 | 0.0290 |
| **plant** | 56 | 42.8571 | 0.3083 | 0.3660 | 0.7176 | 0.1202 | 0.0013 | 0.0037 | 0.0362 | 0.0441 | 0.0032 | 0.0034 | 0.0174 | 0.0331 |
| **telly** | 56 | 26.7857 | 0.2075 | 0.3384 | 0.7395 | 0.1537 | 0.0128 | 0.0645 | 0.1180 | 0.1694 | 0.0363 | 0.0821 | 0.0582 | 0.1164 |
| **water** | 55 | 3.6364 | 0.0274 | 0.1277 | 0.6582 | 0.2218 | 0.0036 | 0.0105 | 0.0222 | 0.0226 | 0.0023 | 0.0043 | 0.0030 | 0.0064 |
| **power** | 53 | 5.6604 | 0.0640 | 0.1848 | 0.7745 | 0.1058 | 0.0213 | 0.0549 | 0.0604 | 0.0486 | 0.0057 | 0.0082 | 0.0088 | 0.0178 |
| **couch** | 52 | 63.4615 | 0.5305 | 0.3982 | 0.8229 | 0.0876 | 0.0227 | 0.0822 | 0.0928 | 0.0782 | 0.0283 | 0.0619 | 0.0692 | 0.0785 |
| **drawer unit** | 51 | 72.5490 | 0.6118 | 0.3843 | 0.8415 | 0.0862 | 0.0046 | 0.0133 | 0.1055 | 0.0904 | 0.0222 | 0.0234 | 0.0826 | 0.0862 |
| **wifi** | 51 | 3.9216 | 0.0447 | 0.1270 | 0.6410 | 0.0515 | 0.0204 | 0.0365 | 0.0100 | 0.0001 | 0.0044 | 0.0057 | 0.0046 | 0.0057 |
| **cutlery** | 51 | 0.0000 | 0.0058 | 0.0171 | - | - | 0.0058 | 0.0171 | - | - | 0.0017 | 0.0039 | 0.0017 | 0.0039 |
| **bowl** | 51 | 7.8431 | 0.0596 | 0.1785 | 0.6555 | 0.0886 | 0.0088 | 0.0250 | 0.0082 | 0.0027 | 0.0015 | 0.0028 | 0.0020 | 0.0033 |
| **pasta** | 50 | 10.0000 | 0.0771 | 0.2163 | 0.7123 | 0.0785 | 0.0065 | 0.0250 | 0.0145 | 0.0083 | 0.0015 | 0.0040 | 0.0028 | 0.0060 |
| **spoon** | 50 | 0.0000 | 0.0013 | 0.0046 | - | - | 0.0013 | 0.0046 | - | - | 0.0005 | 0.0010 | 0.0005 | 0.0010 |
| **computer** | 49 | 10.2041 | 0.0911 | 0.2202 | 0.7233 | 0.1044 | 0.0192 | 0.0366 | 0.0216 | 0.0158 | 0.0047 | 0.0089 | 0.0065 | 0.0109 |
| **counter** | 49 | 51.0204 | 0.4184 | 0.4165 | 0.8153 | 0.1075 | 0.0049 | 0.0162 | 0.1520 | 0.1596 | 0.0644 | 0.1058 | 0.1091 | 0.1416 |
| **plate** | 48 | 4.1667 | 0.0413 | 0.1723 | 0.8550 | 0.0246 | 0.0059 | 0.0165 | 0.0254 | 0.0269 | 0.0017 | 0.0030 | 0.0027 | 0.0069 |
| **refrigerator** | 48 | 60.4167 | 0.4946 | 0.4124 | 0.8186 | 0.1037 | 0.0000 | 0.0000 | 0.1476 | 0.1635 | 0.0482 | 0.0855 | 0.1082 | 0.1454 |
| **sofa** | 47 | 63.8298 | 0.5491 | 0.3965 | 0.8332 | 0.0939 | 0.0477 | 0.1327 | 0.1213 | 0.1252 | 0.0181 | 0.0228 | 0.0840 | 0.1122 |
| **notebook** | 46 | 17.3913 | 0.1349 | 0.2879 | 0.7485 | 0.1053 | 0.0057 | 0.0129 | 0.0224 | 0.0198 | 0.0021 | 0.0023 | 0.0056 | 0.0112 |
| **knife** | 46 | 4.3478 | 0.0370 | 0.1580 | 0.7653 | 0.0851 | 0.0039 | 0.0123 | 0.0223 | 0.0136 | 0.0014 | 0.0029 | 0.0023 | 0.0056 |
| **garbage bucket** | 45 | 62.2222 | 0.4763 | 0.3802 | 0.7649 | 0.0829 | 0.0009 | 0.0033 | 0.0285 | 0.0218 | 0.0076 | 0.0186 | 0.0206 | 0.0228 |
| **bottle of wine** | 45 | 6.6667 | 0.0553 | 0.1827 | 0.7230 | 0.1104 | 0.0076 | 0.0173 | 0.0102 | 0.0023 | 0.0090 | 0.0475 | 0.0090 | 0.0459 |
| **beer** | 45 | 11.1111 | 0.0968 | 0.2171 | 0.6320 | 0.1139 | 0.0299 | 0.1027 | 0.0067 | 0.0019 | 0.0117 | 0.0512 | 0.0112 | 0.0483 |
| **wine** | 44 | 13.6364 | 0.0954 | 0.2368 | 0.6811 | 0.0726 | 0.0030 | 0.0052 | 0.0078 | 0.0022 | 0.0042 | 0.0177 | 0.0047 | 0.0165 |
| **fork** | 44 | 0.0000 | 0.0032 | 0.0106 | - | - | 0.0032 | 0.0106 | - | - | 0.0010 | 0.0034 | 0.0010 | 0.0034 |
| **spraybottle** | 44 | 15.9091 | 0.1027 | 0.2360 | 0.6307 | 0.1094 | 0.0028 | 0.0057 | 0.0077 | 0.0064 | 0.0009 | 0.0020 | 0.0020 | 0.0039 |
| **pc** | 43 | 18.6047 | 0.1327 | 0.2673 | 0.6741 | 0.1170 | 0.0089 | 0.0269 | 0.0229 | 0.0209 | 0.0044 | 0.0093 | 0.0078 | 0.0140 |
| **bucket** | 43 | 67.4419 | 0.5368 | 0.3690 | 0.7861 | 0.0622 | 0.0203 | 0.0759 | 0.0280 | 0.0223 | 0.0059 | 0.0080 | 0.0208 | 0.0215 |
| **napkin** | 43 | 0.0000 | 0.0011 | 0.0021 | - | - | 0.0011 | 0.0021 | - | - | 0.0003 | 0.0006 | 0.0003 | 0.0006 |
| **horse** | 43 | 9.3023 | 0.0697 | 0.1839 | 0.6166 | 0.1013 | 0.0136 | 0.0428 | 0.0229 | 0.0165 | 0.0034 | 0.0059 | 0.0052 | 0.0092 |
| **bottle of beer** | 42 | 14.2857 | 0.1061 | 0.2383 | 0.6634 | 0.1139 | 0.0132 | 0.0507 | 0.0086 | 0.0026 | 0.0135 | 0.0539 | 0.0128 | 0.0498 |
| **drawer** | 42 | 45.2381 | 0.3991 | 0.4245 | 0.8578 | 0.0508 | 0.0202 | 0.0437 | 0.1077 | 0.0740 | 0.0209 | 0.0267 | 0.0602 | 0.0686 |
| **beer bottle** | 42 | 11.9048 | 0.0814 | 0.2211 | 0.6663 | 0.1240 | 0.0024 | 0.0049 | 0.0086 | 0.0037 | 0.0012 | 0.0011 | 0.0021 | 0.0029 |
| **socket** | 42 | 14.2857 | 0.1057 | 0.2269 | 0.6442 | 0.0924 | 0.0159 | 0.0331 | 0.0222 | 0.0228 | 0.0046 | 0.0057 | 0.0071 | 0.0114 |
| **web** | 41 | 9.7561 | 0.0741 | 0.2166 | 0.7109 | 0.1502 | 0.0052 | 0.0181 | 0.0216 | 0.0082 | 0.0043 | 0.0085 | 0.0060 | 0.0099 |
| **power socket** | 40 | 7.5000 | 0.0569 | 0.1800 | 0.6691 | 0.1215 | 0.0072 | 0.0231 | 0.0283 | 0.0334 | 0.0028 | 0.0042 | 0.0047 | 0.0109 |
| **closet** | 40 | 52.5000 | 0.4683 | 0.4358 | 0.8739 | 0.0572 | 0.0200 | 0.0614 | 0.1541 | 0.1164 | 0.0330 | 0.0516 | 0.0965 | 0.1092 |
| **garbage can** | 40 | 67.5000 | 0.5218 | 0.3629 | 0.7656 | 0.0821 | 0.0153 | 0.0411 | 0.0265 | 0.0213 | 0.0188 | 0.0279 | 0.0240 | 0.0236 |
| **building** | 39 | 46.1538 | 0.4220 | 0.4577 | 0.9090 | 0.0433 | 0.0046 | 0.0144 | 0.3431 | 0.3018 | 0.0343 | 0.0271 | 0.1768 | 0.2558 |
| **bedstand** | 39 | 46.1538 | 0.4148 | 0.4026 | 0.8235 | 0.0836 | 0.0646 | 0.1513 | 0.1244 | 0.1429 | 0.0404 | 0.0484 | 0.0792 | 0.1103 |
| **bread** | 38 | 0.0000 | 0.0099 | 0.0340 | - | - | 0.0099 | 0.0340 | - | - | 0.0014 | 0.0026 | 0.0014 | 0.0026 |
| **tablet** | 38 | 10.5263 | 0.0880 | 0.2128 | 0.6895 | 0.0948 | 0.0173 | 0.0306 | 0.0309 | 0.0259 | 0.0033 | 0.0051 | 0.0062 | 0.0123 |
| **pillow** | 38 | 18.4211 | 0.1429 | 0.2887 | 0.7278 | 0.1480 | 0.0108 | 0.0227 | 0.0223 | 0.0168 | 0.0047 | 0.0109 | 0.0080 | 0.0138 |
| **dresser** | 38 | 63.1579 | 0.5679 | 0.4061 | 0.8678 | 0.0446 | 0.0538 | 0.1229 | 0.1089 | 0.0626 | 0.0261 | 0.0328 | 0.0784 | 0.0667 |
| **mouse** | 37 | 8.1081 | 0.0740 | 0.1992 | 0.7125 | 0.1570 | 0.0177 | 0.0381 | 0.0195 | 0.0187 | 0.0044 | 0.0063 | 0.0056 | 0.0086 |
| **fridge** | 37 | 67.5676 | 0.5470 | 0.3987 | 0.8094 | 0.1313 | 0.0003 | 0.0009 | 0.2202 | 0.3047 | 0.0499 | 0.0436 | 0.1650 | 0.2627 |
| **yogurt** | 37 | 0.0000 | 0.0061 | 0.0107 | - | - | 0.0061 | 0.0107 | - | - | 0.0021 | 0.0037 | 0.0021 | 0.0037 |
| **bed** | 37 | 45.9459 | 0.3818 | 0.4229 | 0.8280 | 0.1053 | 0.0026 | 0.0072 | 0.1307 | 0.1154 | 0.0202 | 0.0256 | 0.0710 | 0.0968 |
| **armchair** | 37 | 59.4595 | 0.4718 | 0.4010 | 0.7926 | 0.0988 | 0.0014 | 0.0053 | 0.0625 | 0.0652 | 0.0205 | 0.0385 | 0.0455 | 0.0591 |
| **bedside** | 37 | 32.4324 | 0.2927 | 0.3903 | 0.8366 | 0.0659 | 0.0317 | 0.0878 | 0.1073 | 0.0967 | 0.0477 | 0.0657 | 0.0670 | 0.0809 |
| **pocket** | 36 | 0.0000 | 0.0022 | 0.0053 | - | - | 0.0022 | 0.0053 | - | - | 0.0014 | 0.0043 | 0.0014 | 0.0043 |
| **wine bottle** | 36 | 11.1111 | 0.0697 | 0.1921 | 0.6010 | 0.0824 | 0.0033 | 0.0072 | 0.0060 | 0.0025 | 0.0022 | 0.0038 | 0.0026 | 0.0038 |
| **soap** | 36 | 8.3333 | 0.0618 | 0.1878 | 0.6719 | 0.0803 | 0.0064 | 0.0102 | 0.0069 | 0.0057 | 0.0032 | 0.0059 | 0.0036 | 0.0059 |
| **bin** | 36 | 72.2222 | 0.5696 | 0.3515 | 0.7732 | 0.1095 | 0.0404 | 0.1275 | 0.0325 | 0.0257 | 0.0032 | 0.0025 | 0.0244 | 0.0255 |
| **nightstand** | 35 | 42.8571 | 0.3671 | 0.4110 | 0.8188 | 0.1221 | 0.0283 | 0.0970 | 0.1936 | 0.2130 | 0.0427 | 0.0683 | 0.1074 | 0.1644 |
| **bench** | 35 | 54.2857 | 0.4386 | 0.4147 | 0.8068 | 0.1085 | 0.0013 | 0.0052 | 0.0579 | 0.0418 | 0.0215 | 0.0425 | 0.0413 | 0.0454 |
| **aspirin** | 35 | 0.0000 | 0.0010 | 0.0020 | - | - | 0.0010 | 0.0020 | - | - | 0.0004 | 0.0012 | 0.0004 | 0.0012 |
| **stove** | 34 | 5.8824 | 0.0474 | 0.1720 | 0.7223 | 0.0228 | 0.0052 | 0.0152 | 0.0263 | 0.0118 | 0.0043 | 0.0066 | 0.0056 | 0.0085 |
| **mug** | 34 | 8.8235 | 0.0504 | 0.1621 | 0.5624 | 0.0453 | 0.0008 | 0.0021 | 0.0130 | 0.0101 | 0.0009 | 0.0032 | 0.0019 | 0.0053 |
| **spatula** | 33 | 0.0000 | 0.0024 | 0.0110 | - | - | 0.0024 | 0.0110 | - | - | 0.0016 | 0.0054 | 0.0016 | 0.0054 |
| **mustard** | 33 | 0.0000 | 0.0007 | 0.0019 | - | - | 0.0007 | 0.0019 | - | - | 0.0002 | 0.0006 | 0.0002 | 0.0006 |
| **jar** | 32 | 6.2500 | 0.0385 | 0.1369 | 0.5572 | 0.0321 | 0.0039 | 0.0141 | 0.0042 | 0.0029 | 0.0009 | 0.0015 | 0.0011 | 0.0018 |
| **cushion** | 32 | 9.3750 | 0.0638 | 0.1832 | 0.6204 | 0.0735 | 0.0063 | 0.0121 | 0.0139 | 0.0080 | 0.0023 | 0.0034 | 0.0033 | 0.0052 |
| **vase** | 32 | 9.3750 | 0.0633 | 0.1903 | 0.6418 | 0.0797 | 0.0034 | 0.0094 | 0.0128 | 0.0019 | 0.0015 | 0.0027 | 0.0025 | 0.0042 |
| **shelf** | 32 | 62.5000 | 0.5334 | 0.4087 | 0.8421 | 0.0617 | 0.0187 | 0.0442 | 0.1481 | 0.1462 | 0.1275 | 0.2756 | 0.1404 | 0.2004 |
| **paperback** | 32 | 3.1250 | 0.0218 | 0.1049 | 0.5953 | - | 0.0033 | 0.0071 | 0.0093 | - | 0.0008 | 0.0020 | 0.0010 | 0.0025 |
| **wire** | 32 | 0.0000 | 0.0003 | 0.0010 | - | - | 0.0003 | 0.0010 | - | - | 0.0003 | 0.0008 | 0.0003 | 0.0008 |
| **toilet** | 31 | 77.4194 | 0.5891 | 0.3218 | 0.7526 | 0.1042 | 0.0283 | 0.0456 | 0.0665 | 0.0820 | 0.0126 | 0.0187 | 0.0543 | 0.0758 |
| **scissors** | 31 | 0.0000 | 0.0009 | 0.0020 | - | - | 0.0009 | 0.0020 | - | - | 0.0003 | 0.0004 | 0.0003 | 0.0004 |
| **lanyard** | 31 | 0.0000 | 0.0027 | 0.0081 | - | - | 0.0027 | 0.0081 | - | - | 0.0013 | 0.0032 | 0.0013 | 0.0032 |
| **bookshelf** | 30 | 66.6667 | 0.5584 | 0.3919 | 0.8258 | 0.0828 | 0.0237 | 0.0613 | 0.1170 | 0.1177 | 0.0302 | 0.0425 | 0.0881 | 0.1066 |
| **tvstand** | 30 | 13.3333 | 0.0909 | 0.1901 | 0.5222 | 0.0159 | 0.0245 | 0.0868 | 0.1208 | 0.0846 | 0.0324 | 0.0431 | 0.0441 | 0.0572 |
| **butter knife** | 30 | 0.0000 | 0.0002 | 0.0008 | - | - | 0.0002 | 0.0008 | - | - | 0.0002 | 0.0006 | 0.0002 | 0.0006 |
| **night** | 29 | 20.6897 | 0.2176 | 0.3609 | 0.8978 | 0.0295 | 0.0402 | 0.0804 | 0.2885 | 0.2608 | 0.0747 | 0.1279 | 0.1190 | 0.1810 |
| **soap dispenser** | 29 | 0.0000 | 0.0184 | 0.0552 | - | - | 0.0184 | 0.0552 | - | - | 0.0030 | 0.0057 | 0.0030 | 0.0057 |
| **kettle** | 29 | 10.3448 | 0.0759 | 0.2015 | 0.6534 | 0.0674 | 0.0092 | 0.0217 | 0.0141 | 0.0073 | 0.0022 | 0.0031 | 0.0034 | 0.0051 |
| **cabinet** | 29 | 48.2759 | 0.4266 | 0.4268 | 0.8513 | 0.1097 | 0.0301 | 0.0656 | 0.1840 | 0.1707 | 0.0501 | 0.0578 | 0.1147 | 0.1409 |
| **jam** | 29 | 0.0000 | 0.0120 | 0.0554 | - | - | 0.0120 | 0.0554 | - | - | 0.0015 | 0.0033 | 0.0015 | 0.0033 |
| **milk** | 29 | 6.8966 | 0.0516 | 0.1514 | 0.5929 | 0.0016 | 0.0115 | 0.0216 | 0.0066 | 0.0005 | 0.0027 | 0.0037 | 0.0030 | 0.0037 |
| **cup of coffee** | 29 | 3.4483 | 0.0289 | 0.1224 | 0.6619 | - | 0.0063 | 0.0131 | 0.0075 | - | 0.0014 | 0.0015 | 0.0016 | 0.0019 |
| **glasses** | 29 | 0.0000 | 0.0005 | 0.0014 | - | - | 0.0005 | 0.0014 | - | - | 0.0003 | 0.0006 | 0.0003 | 0.0006 |
| **cup** | 29 | 6.8966 | 0.0588 | 0.1730 | 0.6595 | 0.0034 | 0.0143 | 0.0493 | 0.0050 | 0.0035 | 0.0038 | 0.0077 | 0.0039 | 0.0074 |
| **mirror** | 28 | 0.0000 | 0.0128 | 0.0339 | - | - | 0.0128 | 0.0339 | - | - | 0.0059 | 0.0191 | 0.0059 | 0.0191 |
| **magazine** | 27 | 7.4074 | 0.0567 | 0.1831 | 0.6724 | 0.2046 | 0.0074 | 0.0214 | 0.0207 | 0.0174 | 0.0014 | 0.0026 | 0.0028 | 0.0067 |
| **shelving** | 27 | 77.7778 | 0.6515 | 0.3588 | 0.8352 | 0.0885 | 0.0086 | 0.0134 | 0.1286 | 0.2022 | 0.0607 | 0.1161 | 0.1135 | 0.1868 |
| **washer** | 26 | 69.2308 | 0.5761 | 0.3916 | 0.8278 | 0.0856 | 0.0097 | 0.0186 | 0.1109 | 0.0997 | 0.0356 | 0.0424 | 0.0877 | 0.0923 |
| **pantry** | 25 | 60.0000 | 0.4948 | 0.4006 | 0.8085 | 0.0991 | 0.0243 | 0.0531 | 0.1491 | 0.1517 | 0.0343 | 0.0561 | 0.1032 | 0.1338 |
| **toaster** | 25 | 12.0000 | 0.0885 | 0.2354 | 0.7092 | 0.0883 | 0.0039 | 0.0061 | 0.0234 | 0.0281 | 0.0037 | 0.0073 | 0.0061 | 0.0125 |
| **cupboard** | 24 | 70.8333 | 0.6105 | 0.3704 | 0.8383 | 0.0752 | 0.0572 | 0.0810 | 0.1469 | 0.1416 | 0.0623 | 0.0530 | 0.1222 | 0.1274 |
| **coffee** | 24 | 4.1667 | 0.0289 | 0.1349 | 0.6619 | - | 0.0014 | 0.0040 | 0.0075 | - | 0.0014 | 0.0019 | 0.0016 | 0.0023 |
| **fruit** | 24 | 0.0000 | 0.0005 | 0.0014 | - | - | 0.0005 | 0.0014 | - | - | 0.0005 | 0.0008 | 0.0005 | 0.0008 |
| **stand** | 24 | 25.0000 | 0.2564 | 0.3521 | 0.8184 | 0.1464 | 0.0690 | 0.1132 | 0.1528 | 0.1314 | 0.0301 | 0.0337 | 0.0608 | 0.0868 |
| **credit card** | 24 | 0.0000 | 0.0016 | 0.0050 | - | - | 0.0016 | 0.0050 | - | - | 0.0002 | 0.0006 | 0.0002 | 0.0006 |
| **eyeglasses** | 24 | 0.0000 | 0.0072 | 0.0157 | - | - | 0.0072 | 0.0157 | - | - | 0.0006 | 0.0011 | 0.0006 | 0.0011 |
| **recorder** | 24 | 45.8333 | 0.3930 | 0.3778 | 0.7736 | 0.1160 | 0.0709 | 0.1312 | 0.0959 | 0.1197 | 0.0161 | 0.0140 | 0.0527 | 0.0893 |
| **cereal** | 23 | 4.3478 | 0.0436 | 0.1729 | 0.8251 | - | 0.0081 | 0.0303 | 0.0058 | - | 0.0044 | 0.0129 | 0.0045 | 0.0126 |
| **pencil** | 23 | 0.0000 | 0.0001 | 0.0003 | - | - | 0.0001 | 0.0003 | - | - | 0.0001 | 0.0001 | 0.0001 | 0.0001 |
| **loo** | 23 | 65.2174 | 0.4962 | 0.3798 | 0.7597 | 0.1133 | 0.0021 | 0.0060 | 0.0785 | 0.0666 | 0.0087 | 0.0057 | 0.0542 | 0.0632 |
| **mayo** | 23 | 0.0000 | 0.0011 | 0.0022 | - | - | 0.0011 | 0.0022 | - | - | 0.0008 | 0.0010 | 0.0008 | 0.0010 |
| **wrench** | 23 | 0.0000 | 0.0023 | 0.0104 | - | - | 0.0023 | 0.0104 | - | - | 0.0006 | 0.0025 | 0.0006 | 0.0025 |
| **washing machine** | 23 | 73.9130 | 0.6089 | 0.3593 | 0.8112 | 0.0920 | 0.0357 | 0.0868 | 0.0850 | 0.0997 | 0.0044 | 0.0041 | 0.0640 | 0.0924 |
| **newspaper** | 23 | 8.6957 | 0.0636 | 0.2013 | 0.6894 | 0.1805 | 0.0040 | 0.0073 | 0.0182 | 0.0210 | 0.0018 | 0.0033 | 0.0032 | 0.0072 |
| **tap** | 22 | 63.6364 | 0.4865 | 0.3793 | 0.7583 | 0.1147 | 0.0108 | 0.0273 | 0.0859 | 0.0754 | 0.0431 | 0.0607 | 0.0703 | 0.0721 |
| **bath** | 22 | 63.6364 | 0.5218 | 0.3915 | 0.8032 | 0.1098 | 0.0293 | 0.0425 | 0.1070 | 0.0850 | 0.0468 | 0.0498 | 0.0851 | 0.0786 |
| **apple** | 22 | 9.0909 | 0.0607 | 0.1938 | 0.6565 | 0.0876 | 0.0011 | 0.0024 | 0.0037 | 0.0003 | 0.0010 | 0.0022 | 0.0013 | 0.0022 |
| **light** | 21 | 47.6190 | 0.4009 | 0.4020 | 0.7953 | 0.0911 | 0.0423 | 0.1367 | 0.0855 | 0.1216 | 0.0718 | 0.1027 | 0.0783 | 0.1095 |
| **washing** | 21 | 66.6667 | 0.5874 | 0.3464 | 0.8104 | 0.1241 | 0.1414 | 0.1365 | 0.1163 | 0.1223 | 0.0280 | 0.0201 | 0.0869 | 0.1080 |
| **dishwasher** | 19 | 73.6842 | 0.5869 | 0.3599 | 0.7930 | 0.0722 | 0.0095 | 0.0213 | 0.0930 | 0.1067 | 0.0214 | 0.0298 | 0.0742 | 0.0973 |
| **storage** | 19 | 31.5789 | 0.2740 | 0.3970 | 0.8354 | 0.0971 | 0.0149 | 0.0468 | 0.1385 | 0.1147 | 0.0450 | 0.0643 | 0.0746 | 0.0917 |
| **bathtub** | 19 | 57.8947 | 0.4527 | 0.4074 | 0.7819 | 0.1246 | 0.0000 | 0.0000 | 0.0866 | 0.0718 | 0.0118 | 0.0088 | 0.0551 | 0.0658 |
| **floorlamp** | 18 | 66.6667 | 0.5229 | 0.3960 | 0.7844 | 0.1366 | 0.0000 | 0.0000 | 0.0772 | 0.1012 | 0.0144 | 0.0138 | 0.0563 | 0.0873 |
| **sink** | 18 | 77.7778 | 0.5835 | 0.3108 | 0.7288 | 0.1372 | 0.0750 | 0.1500 | 0.0671 | 0.0741 | 0.0095 | 0.0067 | 0.0543 | 0.0694 |
| **sidetable** | 18 | 50.0000 | 0.3717 | 0.3792 | 0.7350 | 0.0916 | 0.0084 | 0.0139 | 0.0539 | 0.0375 | 0.0102 | 0.0222 | 0.0321 | 0.0374 |
| **candle** | 18 | 0.0000 | 0.0005 | 0.0015 | - | - | 0.0005 | 0.0015 | - | - | 0.0007 | 0.0010 | 0.0007 | 0.0010 |
| **salt shaker** | 18 | 0.0000 | 0.0015 | 0.0030 | - | - | 0.0015 | 0.0030 | - | - | 0.0004 | 0.0005 | 0.0004 | 0.0005 |
| **garbage bag** | 18 | 61.1111 | 0.4482 | 0.3671 | 0.7294 | 0.0720 | 0.0062 | 0.0165 | 0.0188 | 0.0160 | 0.0022 | 0.0011 | 0.0124 | 0.0148 |
| **bath-tub** | 18 | 50.0000 | 0.3864 | 0.3995 | 0.7629 | 0.1390 | 0.0099 | 0.0298 | 0.0793 | 0.0743 | 0.0197 | 0.0184 | 0.0495 | 0.0608 |
| **wristwatch** | 18 | 0.0000 | 0.0002 | 0.0004 | - | - | 0.0002 | 0.0004 | - | - | 0.0002 | 0.0005 | 0.0002 | 0.0005 |
| **floor lamp** | 17 | 52.9412 | 0.4549 | 0.4065 | 0.8128 | 0.1095 | 0.0522 | 0.1179 | 0.1238 | 0.1499 | 0.0206 | 0.0266 | 0.0752 | 0.1198 |
| **corn** | 17 | 11.7647 | 0.0762 | 0.2099 | 0.6329 | 0.0496 | 0.0020 | 0.0043 | 0.0085 | 0.0011 | 0.0007 | 0.0006 | 0.0016 | 0.0027 |
| **toilet paper** | 17 | 0.0000 | 0.0229 | 0.0562 | - | - | 0.0229 | 0.0562 | - | - | 0.0011 | 0.0017 | 0.0011 | 0.0017 |
| **lettuce** | 17 | 17.6471 | 0.1321 | 0.2974 | 0.7433 | 0.1649 | 0.0011 | 0.0039 | 0.0141 | 0.0132 | 0.0007 | 0.0006 | 0.0031 | 0.0071 |
| **cereals** | 17 | 0.0000 | 0.0011 | 0.0024 | - | - | 0.0011 | 0.0024 | - | - | 0.0038 | 0.0139 | 0.0038 | 0.0139 |
| **tomato** | 16 | 6.2500 | 0.0392 | 0.1534 | 0.6146 | - | 0.0008 | 0.0018 | 0.0043 | - | 0.0005 | 0.0006 | 0.0007 | 0.0011 |
| **pepper shaker** | 16 | 6.2500 | 0.0400 | 0.1579 | 0.6322 | - | 0.0005 | 0.0010 | 0.0019 | - | 0.0004 | 0.0007 | 0.0005 | 0.0007 |
| **toiletpaper** | 15 | 0.0000 | 0.0310 | 0.1073 | - | - | 0.0310 | 0.1073 | - | - | 0.0018 | 0.0024 | 0.0018 | 0.0024 |
| **desk lamp** | 15 | 0.0000 | 0.0042 | 0.0132 | - | - | 0.0042 | 0.0132 | - | - | 0.0031 | 0.0030 | 0.0031 | 0.0030 |
| **potato** | 15 | 0.0000 | 0.0007 | 0.0015 | - | - | 0.0007 | 0.0015 | - | - | 0.0042 | 0.0148 | 0.0042 | 0.0148 |
| **screwdriver** | 15 | 6.6667 | 0.0798 | 0.2322 | 0.8946 | - | 0.0216 | 0.0577 | 0.0851 | - | 0.0169 | 0.0271 | 0.0214 | 0.0315 |
| **lamp** | 15 | 66.6667 | 0.5118 | 0.3730 | 0.7598 | 0.1051 | 0.0159 | 0.0322 | 0.0815 | 0.1204 | 0.0206 | 0.0345 | 0.0612 | 0.1027 |
| **tray** | 15 | 13.3333 | 0.0784 | 0.1940 | 0.5556 | 0.0121 | 0.0050 | 0.0103 | 0.0082 | 0.0027 | 0.0034 | 0.0077 | 0.0040 | 0.0074 |
| **roll of paper towel** | 15 | 6.6667 | 0.0503 | 0.1746 | 0.6801 | - | 0.0053 | 0.0114 | 0.0042 | - | 0.0020 | 0.0034 | 0.0021 | 0.0034 |
| **microwave** | 15 | 6.6667 | 0.0868 | 0.2030 | 0.7724 | - | 0.0378 | 0.0750 | 0.0136 | - | 0.0089 | 0.0088 | 0.0092 | 0.0086 |
| **pan** | 15 | 20.0000 | 0.1395 | 0.2711 | 0.6506 | 0.1424 | 0.0117 | 0.0274 | 0.0105 | 0.0037 | 0.0044 | 0.0089 | 0.0056 | 0.0084 |
| **oven** | 14 | 21.4286 | 0.1835 | 0.3001 | 0.7107 | 0.1717 | 0.0397 | 0.0713 | 0.0284 | 0.0260 | 0.0079 | 0.0103 | 0.0123 | 0.0162 |
| **router** | 14 | 0.0000 | 0.0182 | 0.0314 | - | - | 0.0182 | 0.0314 | - | - | 0.0049 | 0.0055 | 0.0049 | 0.0055 |
| **basketball** | 14 | 35.7143 | 0.2195 | 0.3056 | 0.6113 | 0.0708 | 0.0019 | 0.0033 | 0.0076 | 0.0044 | 0.0011 | 0.0008 | 0.0034 | 0.0041 |
| **folder** | 14 | 14.2857 | 0.1081 | 0.2579 | 0.7155 | 0.0267 | 0.0069 | 0.0175 | 0.0144 | 0.0028 | 0.0027 | 0.0022 | 0.0044 | 0.0048 |
| **sponge** | 14 | 0.0000 | 0.0020 | 0.0052 | - | - | 0.0020 | 0.0052 | - | - | 0.0002 | 0.0004 | 0.0002 | 0.0004 |
| **baseball bat** | 13 | 23.0769 | 0.1700 | 0.3224 | 0.7352 | 0.0315 | 0.0005 | 0.0015 | 0.0223 | 0.0154 | 0.0017 | 0.0022 | 0.0064 | 0.0112 |
| **garbage** | 13 | 84.6154 | 0.6587 | 0.3041 | 0.7785 | 0.0917 | 0.0000 | 0.0000 | 0.0234 | 0.0154 | 0.0031 | 0.0015 | 0.0203 | 0.0160 |
| **orange** | 13 | 0.0000 | 0.0006 | 0.0011 | - | - | 0.0006 | 0.0011 | - | - | 0.0004 | 0.0003 | 0.0004 | 0.0003 |
| **watch** | 13 | 0.0000 | 0.0005 | 0.0014 | - | - | 0.0005 | 0.0014 | - | - | 0.0001 | 0.0001 | 0.0001 | 0.0001 |
| **teddy bear** | 13 | 46.1538 | 0.3591 | 0.3999 | 0.7713 | 0.0693 | 0.0058 | 0.0152 | 0.0215 | 0.0172 | 0.0014 | 0.0008 | 0.0107 | 0.0152 |
| **dishsponge** | 13 | 0.0000 | 0.0009 | 0.0023 | - | - | 0.0009 | 0.0023 | - | - | 0.0002 | 0.0003 | 0.0002 | 0.0003 |
| **postcard** | 13 | 0.0000 | 0.0004 | 0.0009 | - | - | 0.0004 | 0.0009 | - | - | 0.0002 | 0.0006 | 0.0002 | 0.0006 |
| **baseball** | 12 | 16.6667 | 0.1075 | 0.2522 | 0.6427 | 0.1105 | 0.0004 | 0.0013 | 0.0146 | 0.0171 | 0.0029 | 0.0038 | 0.0048 | 0.0077 |
| **board** | 12 | 0.0000 | 0.0011 | 0.0031 | - | - | 0.0011 | 0.0031 | - | - | 0.0014 | 0.0036 | 0.0014 | 0.0036 |
| **plunger** | 11 | 54.5455 | 0.3439 | 0.3297 | 0.6296 | 0.0437 | 0.0011 | 0.0024 | 0.0079 | 0.0035 | 0.0034 | 0.0036 | 0.0058 | 0.0041 |
| **paper** | 11 | 0.0000 | 0.0047 | 0.0100 | - | - | 0.0047 | 0.0100 | - | - | 0.0020 | 0.0023 | 0.0020 | 0.0023 |
| **clock** | 11 | 0.0000 | 0.0002 | 0.0004 | - | - | 0.0002 | 0.0004 | - | - | 0.0001 | 0.0002 | 0.0001 | 0.0002 |
| **pot** | 11 | 9.0909 | 0.0711 | 0.2269 | 0.7550 | - | 0.0027 | 0.0059 | 0.0129 | - | 0.0012 | 0.0012 | 0.0023 | 0.0037 |
| **cart** | 11 | 45.4545 | 0.3899 | 0.4209 | 0.8238 | 0.0803 | 0.0283 | 0.0635 | 0.0892 | 0.0449 | 0.0582 | 0.0744 | 0.0723 | 0.0619 |
| **wallet** | 10 | 40.0000 | 0.3033 | 0.3841 | 0.7462 | 0.0804 | 0.0081 | 0.0137 | 0.0143 | 0.0056 | 0.0044 | 0.0039 | 0.0084 | 0.0067 |
| **dogbed** | 10 | 70.0000 | 0.5247 | 0.3764 | 0.7495 | 0.1260 | 0.0000 | 0.0000 | 0.0280 | 0.0191 | 0.0053 | 0.0083 | 0.0212 | 0.0195 |
| **corner** | 10 | 30.0000 | 0.2730 | 0.4141 | 0.8704 | 0.0526 | 0.0169 | 0.0369 | 0.1670 | 0.1025 | 0.0423 | 0.0321 | 0.0797 | 0.0816 |
| **ball** | 9 | 33.3333 | 0.1942 | 0.2927 | 0.5826 | 0.0575 | 0.0000 | 0.0000 | 0.0076 | 0.0055 | 0.0030 | 0.0035 | 0.0045 | 0.0045 |
| **stool** | 9 | 77.7778 | 0.5870 | 0.3468 | 0.7547 | 0.1127 | 0.0000 | 0.0000 | 0.0276 | 0.0193 | 0.0038 | 0.0005 | 0.0223 | 0.0198 |
| **paper towel roll** | 9 | 11.1111 | 0.1021 | 0.2408 | 0.7293 | - | 0.0237 | 0.0553 | 0.0109 | - | 0.0018 | 0.0031 | 0.0028 | 0.0042 |
| **bat** | 9 | 0.0000 | 0.0003 | 0.0009 | - | - | 0.0003 | 0.0009 | - | - | 0.0080 | 0.0112 | 0.0080 | 0.0112 |
| **faucet** | 9 | 11.1111 | 0.0985 | 0.2613 | 0.7912 | - | 0.0119 | 0.0302 | 0.0384 | - | 0.0014 | 0.0014 | 0.0055 | 0.0124 |
| **ladle** | 9 | 0.0000 | 0.0069 | 0.0136 | - | - | 0.0069 | 0.0136 | - | - | 0.0010 | 0.0016 | 0.0010 | 0.0016 |
| **alarm clock** | 8 | 25.0000 | 0.1911 | 0.3526 | 0.7613 | 0.0577 | 0.0011 | 0.0021 | 0.0105 | 0.0048 | 0.0039 | 0.0072 | 0.0055 | 0.0070 |
| **roll** | 8 | 0.0000 | 0.0002 | 0.0007 | - | - | 0.0002 | 0.0007 | - | - | 0.0018 | 0.0031 | 0.0018 | 0.0031 |
| **dinner** | 8 | 0.0000 | 0.0003 | 0.0005 | - | - | 0.0003 | 0.0005 | - | - | 0.0003 | 0.0003 | 0.0003 | 0.0003 |
| **handkerchief holder** | 7 | 0.0000 | 0.0017 | 0.0046 | - | - | 0.0017 | 0.0046 | - | - | 0.0017 | 0.0024 | 0.0017 | 0.0024 |
| **machine** | 7 | 28.5714 | 0.1912 | 0.3284 | 0.6692 | 0.0866 | 0.0000 | 0.0000 | 0.0112 | 0.0057 | 0.0110 | 0.0203 | 0.0110 | 0.0167 |
| **egg** | 6 | 0.0000 | 0.0004 | 0.0010 | - | - | 0.0004 | 0.0010 | - | - | 0.0002 | 0.0002 | 0.0002 | 0.0002 |
| **crate** | 6 | 16.6667 | 0.1141 | 0.2783 | 0.6821 | - | 0.0005 | 0.0010 | 0.0240 | - | 0.0026 | 0.0022 | 0.0062 | 0.0089 |
| **tennis racket** | 6 | 16.6667 | 0.1267 | 0.2710 | 0.6774 | - | 0.0166 | 0.0286 | 0.0099 | - | 0.0051 | 0.0070 | 0.0059 | 0.0065 |
| **hat** | 5 | 0.0000 | 0.0234 | 0.0469 | - | - | 0.0234 | 0.0469 | - | - | 0.0045 | 0.0056 | 0.0045 | 0.0056 |
| **desk** | 5 | 60.0000 | 0.5604 | 0.4522 | 0.8887 | 0.0149 | 0.0680 | 0.0961 | 0.1588 | 0.0581 | 0.0292 | 0.0273 | 0.1070 | 0.0832 |
| **coffee machine** | 5 | 40.0000 | 0.2878 | 0.3558 | 0.6742 | 0.0795 | 0.0303 | 0.0351 | 0.0349 | 0.0278 | 0.0199 | 0.0240 | 0.0259 | 0.0234 |
| **tissue** | 5 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0004 | 0.0007 | 0.0004 | 0.0007 |
| **pants** | 4 | 0.0000 | 0.0023 | 0.0046 | - | - | 0.0023 | 0.0046 | - | - | 0.0056 | 0.0058 | 0.0056 | 0.0058 |
| **console** | 4 | 0.0000 | 0.0635 | 0.1270 | - | - | 0.0635 | 0.1270 | - | - | 0.0196 | 0.0238 | 0.0196 | 0.0238 |
| **shelving unit** | 4 | 50.0000 | 0.4014 | 0.4394 | 0.7776 | 0.1097 | 0.0253 | 0.0358 | 0.1064 | 0.0805 | 0.0124 | 0.0046 | 0.0594 | 0.0715 |
| **cloth** | 4 | 0.0000 | 0.1191 | 0.2382 | - | - | 0.1191 | 0.2382 | - | - | 0.0034 | 0.0062 | 0.0034 | 0.0062 |
| **handkerchiefs** | 4 | 0.0000 | 0.0039 | 0.0077 | - | - | 0.0039 | 0.0077 | - | - | 0.0003 | 0.0003 | 0.0003 | 0.0003 |
| **racket** | 4 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0048 | 0.0082 | 0.0048 | 0.0082 |
| **coat** | 3 | 0.0000 | 0.0653 | 0.1130 | - | - | 0.0653 | 0.1130 | - | - | 0.0048 | 0.0068 | 0.0048 | 0.0068 |
| **cell phone** | 3 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0018 | 0.0015 | 0.0018 | 0.0015 |
| **laundry hamper** | 3 | 100.0000 | 0.7998 | 0.0853 | 0.7998 | 0.0853 | - | - | 0.0350 | 0.0209 | - | - | 0.0350 | 0.0209 |
| **coffeemachine** | 3 | 33.3333 | 0.2444 | 0.4209 | 0.7304 | - | 0.0014 | 0.0020 | 0.0152 | - | 0.0070 | 0.0084 | 0.0097 | 0.0076 |
| **freshwater** | 3 | 0.0000 | 0.0029 | 0.0049 | - | - | 0.0029 | 0.0049 | - | - | 0.0132 | 0.0125 | 0.0132 | 0.0125 |
| **press** | 3 | 33.3333 | 0.2679 | 0.4114 | 0.7416 | - | 0.0310 | 0.0439 | 0.0345 | - | 0.0073 | 0.0029 | 0.0164 | 0.0158 |
| **bunk** | 3 | 66.6667 | 0.5992 | 0.5203 | 0.8987 | 0.0535 | 0.0000 | - | 0.0986 | 0.0318 | 0.0015 | - | 0.0662 | 0.0604 |
| **coffee cup** | 2 | 0.0000 | 0.0150 | 0.0212 | - | - | 0.0150 | 0.0212 | - | - | 0.0112 | 0.0150 | 0.0112 | 0.0150 |
| **fabric** | 2 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0040 | 0.0057 | 0.0040 | 0.0057 |
| **journal** | 2 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0001 | 0.0001 | 0.0001 | 0.0001 |
| **futon** | 2 | 100.0000 | 0.8653 | 0.1288 | 0.8653 | 0.1288 | - | - | 0.1109 | 0.0686 | - | - | 0.1109 | 0.0686 |
| **booklet** | 2 | 50.0000 | 0.3147 | 0.2972 | 0.5248 | - | 0.1046 | - | 0.0055 | - | 0.0152 | - | 0.0103 | 0.0068 |
| **cap** | 2 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0040 | 0.0057 | 0.0040 | 0.0057 |
| **boiler** | 2 | 100.0000 | 0.7188 | 0.0363 | 0.7188 | 0.0363 | - | - | 0.0138 | 0.0023 | - | - | 0.0138 | 0.0023 |
| **side table** | 2 | 100.0000 | 0.7365 | 0.2572 | 0.7365 | 0.2572 | - | - | 0.1157 | 0.0987 | - | - | 0.1157 | 0.0987 |
| **pillowcase** | 2 | 0.0000 | 0.0006 | 0.0008 | - | - | 0.0006 | 0.0008 | - | - | 0.0008 | 0.0004 | 0.0008 | 0.0004 |
| **slippers** | 2 | 0.0000 | 0.0096 | 0.0007 | - | - | 0.0096 | 0.0007 | - | - | 0.0064 | 0.0089 | 0.0064 | 0.0089 |
| **settee** | 2 | 50.0000 | 0.4121 | 0.5829 | 0.8243 | - | 0.0000 | - | 0.0468 | - | 0.0013 | - | 0.0240 | 0.0322 |
| **soapbar** | 2 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | 0.0000 | 0.0000 |
| **fourposter** | 2 | 50.0000 | 0.4113 | 0.5817 | 0.8226 | - | 0.0000 | - | 0.0933 | - | 0.0112 | - | 0.0523 | 0.0581 |
| **sofa_bed** | 2 | 100.0000 | 0.8476 | 0.0803 | 0.8476 | 0.0803 | - | - | 0.1177 | 0.1375 | - | - | 0.1177 | 0.1375 |
| **servery** | 2 | 50.0000 | 0.3762 | 0.5320 | 0.7524 | - | 0.0000 | - | 0.0536 | - | 0.0391 | - | 0.0463 | 0.0102 |
| **safe** | 2 | 50.0000 | 0.3479 | 0.4895 | 0.6940 | - | 0.0017 | - | 0.0081 | - | 0.0016 | - | 0.0049 | 0.0046 |
| **novel** | 2 | 0.0000 | 0.0000 | 0.0000 | - | - | 0.0000 | 0.0000 | - | - | 0.0014 | 0.0014 | 0.0014 | 0.0014 |
| **polaroid** | 1 | 100.0000 | 0.6181 | - | 0.6181 | - | - | - | 0.0121 | - | - | - | 0.0121 | - |
| **volume** | 1 | 0.0000 | 0.0007 | - | - | - | 0.0007 | - | - | - | 0.0002 | - | 0.0002 | - |
| **ballpoint** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0000 | - | 0.0000 | - |
| **boots** | 1 | 0.0000 | 0.0192 | - | - | - | 0.0192 | - | - | - | 0.0019 | - | 0.0019 | - |
| **hoodie** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0016 | - | 0.0016 | - |
| **rose** | 1 | 100.0000 | 0.6884 | - | 0.6884 | - | - | - | 0.0161 | - | - | - | 0.0161 | - |
| **boot** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0008 | - | 0.0008 | - |
| **pocketpc** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0016 | - | 0.0016 | - |
| **guidebook** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0002 | - | 0.0002 | - |
| **container** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0007 | - | 0.0007 | - |
| **shoe** | 1 | 0.0000 | 0.0192 | - | - | - | 0.0192 | - | - | - | 0.0019 | - | 0.0019 | - |
| **t-shirt** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0022 | - | 0.0022 | - |
| **cola** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0010 | - | 0.0010 | - |
| **shoes** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0019 | - | 0.0019 | - |
| **clothes** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0016 | - | 0.0016 | - |
| **locker** | 1 | 100.0000 | 0.7127 | - | 0.7127 | - | - | - | 0.0156 | - | - | - | 0.0156 | - |
| **freezer** | 1 | 100.0000 | 0.9152 | - | 0.9152 | - | - | - | 0.4093 | - | - | - | 0.4093 | - |
| **cellular** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0009 | - | 0.0009 | - |
| **textbook** | 1 | 0.0000 | 0.0128 | - | - | - | 0.0128 | - | - | - | 0.0005 | - | 0.0005 | - |
| **microwave_oven** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0008 | - | 0.0008 | - |
| **cloakroom** | 1 | 0.0000 | 0.0476 | - | - | - | 0.0476 | - | - | - | 0.0084 | - | 0.0084 | - |
| **cloth horse** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0022 | - | 0.0022 | - |
| **teeshirt** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0010 | - | 0.0010 | - |
| **furniture** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0027 | - | 0.0027 | - |
| **furnishing** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0027 | - | 0.0027 | - |
| **table decorations** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0027 | - | 0.0027 | - |
| **bathroom** | 1 | 0.0000 | 0.0000 | - | - | - | 0.0000 | - | - | - | 0.0106 | - | 0.0106 | - |

La performance è minore rispetto a prima, prevedibilmente, ma non significativamente peggiore se si pensa che ci stiamo riferendo agli oggetti con i termini più disparati. Certo è che questo non ha risolto il problema.

## CogVLM

A questo punto è il caso di testare nuovi modelli di linguaggio per vedere come performano in zero shot su questo dataset.
Un modello su cui ho indagato è [CogVLM](https://github.com/THUDM/CogVLM)/CogAgent

### Alcuni esempi
Ho testato CogVLM su alcuni esempi su cui Kosmos ha fallito, per se valesse la pena tentare con questo nuovo modello di linguaggio:

#### Esempio 1

In questo esempio era stato chiesto a kosmos2 di individuare il cellulare.
Kosmos2 non è stato in grado di individuarlo (addirittura overlapping index 0)
Questo fa parte del dataset con lexical references, quindi la performancd di kosmos2 era di meno del 20% di accuratezza.

| **environment** | entity_type | image_bbox | image_normal | bounding_box | kosmos_bounding_box | overlap_index | Match |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| ... |  |  |  |  |  |  |  |
| **3548** | cell | Release1/3548/images/Bedroom/bounding_box/position_2/3548_Bedroom_bounding_box_pos_2_270.jpg | Release1/3548/images/Bedroom/normal/position_2/3548_Bedroom_pos_2_270.jpg | (0.6833333333333333, 0.565, 0.74, 0.6166666666666667) | (0.328125, 0.328125, 0.578125, 0.515625) | 0.0 | False |

CogVLM, invece, è riuscito facilmente a localizzarlo e a fare il grounding:

![[Pasted image 20240311105834.png]]

![[Pasted image 20240311105853.png]]


![[Pasted image 20240311105449.png]]

## Esempio 2

![[Pasted image 20240311110748.png]]


Ho intenzionalmente dato al modello in input un'immagine impossibile, per vedere cogVLM come reagisce.
In questa immagine era chiesto a kosmos2 di trovare la bottiglia di vino (la bottiglia di vino si trova sul tavolo dietro al frigorifero, impossibile da vedere ad occhio nudo).

Ed effettivamente Kosmos2 non era stato in grado di individuarla:

| ... |  |  |  |  |  |  |  |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| **2433** | bottle of wine | Robocup/2433/images/Kitchen/bounding_box/position_3/2433_Kitchen_bounding_box_pos_3_180.jpg | Robocup/2433/images/Kitchen/normal/position_3/2433_Kitchen_pos_3_180.jpg | (0.43333333333333335, 0.26666666666666666, 0.44166666666666665, 0.3016666666666667) | (0.265625, 0.484375, 0.984375, 0.984375) | 0.0 | False |
CogVLM in effetti non è in grado di trovarla ed azzarda un oggetto sul tavolo in primo piano

![[Pasted image 20240311111600.png]]

Risposta molto più interessante la da CogAgent, che effettivamente, non riuscendo a trovare la bottiglia, fornisce una serie di istruzioni per cercarla.

![[Pasted image 20240311111938.png]]

Questo si adatta perfettamente allo scopo finale di questi esperimenti: cioè modellare le azioni di un robot. Fornisce anche un a grounded operation, che suggerisce di ruotare a destra di 30 gradi.
Da notare che CogAGENT non fornisce solamente istruzioni, è assolutamente in grado di fare il grounding delle immagini.

![[Pasted image 20240311112137.png]]

### Evaluation con cogVLM

Anche per cogVLM abbiamo scritto uno script ad hoc per fare la valutazione, ma l'input e l'output di questa evaluation è equivalente a quello di Kosmos2.
L'input di questa fase è il file già utilizzato: "output_data.csv" e il risultato è un file di output che chiameremo "output_evaluation_cogVLM.csv"

### Risultati evaluation

Dopodichè sul risultato dell'evaluation abbiamo computato le solite statistiche:

|   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|**entity_type**|**Number of Occurrences**|**Percentage of matches**|**Average Overlapping Index**|**Std Average Overlapping Index**|**Average Overlapping Index (matched)**|**Std Average Overlapping Index (matched)**|**Average Overlapping Index (Unmatched)**|**Std Average Overlapping Index (Unmatched)**|**Avg BBox Dimensions (Correct)**|**Std Avg BBox Dimensions (Correct)**|**Avg BBox Dimensions (Incorrect)**|**Std Avg BBox Dimensions (Incorrect)**|**Average BBox Dimensions (All)**|**Std Average BBox Dimensions (All)**|
|**Total**|10000|39.9300|0.3690|0.4221|0.8694|0.1195|0.0364|0.1000|0.0461|0.0864|0.0060|0.0317|0.0220|0.0630|
|**Painting**|781|64.1485|0.5915|0.4377|0.9145|0.0741|0.0136|0.0566|0.0442|0.0726|0.0142|0.0326|0.0334|0.0630|
|**Cell Phone**|606|9.9010|0.0912|0.2328|0.7512|0.1175|0.0187|0.0737|0.0030|0.0024|0.0007|0.0040|0.0009|0.0039|
|**Remote Control**|506|10.2767|0.0977|0.2298|0.7211|0.1220|0.0263|0.0864|0.0038|0.0037|0.0004|0.0012|0.0008|0.0019|
|**Book**|466|23.6052|0.2049|0.3332|0.7762|0.1286|0.0284|0.0893|0.0080|0.0090|0.0015|0.0072|0.0030|0.0081|
|**Chair**|433|45.2656|0.4262|0.4248|0.8740|0.1226|0.0559|0.1168|0.0338|0.0354|0.0137|0.0183|0.0228|0.0292|
|**Pen**|372|2.4194|0.0331|0.1234|0.6983|0.1255|0.0166|0.0632|0.0027|0.0014|0.0002|0.0009|0.0003|0.0010|
|**Dining Table**|327|82.5688|0.7702|0.3230|0.9107|0.0823|0.1048|0.1696|0.0726|0.0848|0.0169|0.0259|0.0629|0.0806|
|**Key Chain**|219|10.5023|0.1047|0.2230|0.6698|0.1135|0.0384|0.1099|0.0021|0.0011|0.0012|0.0118|0.0013|0.0112|
|**Box**|218|44.9541|0.3799|0.4148|0.8285|0.1074|0.0136|0.0587|0.0129|0.0275|0.0038|0.0090|0.0079|0.0201|
|**Counter Top**|218|52.2936|0.5682|0.3661|0.8942|0.1138|0.2109|0.1473|0.1184|0.1525|0.1011|0.1079|0.1101|0.1331|
|**Bowl**|203|25.1232|0.2173|0.3542|0.8110|0.1218|0.0181|0.0629|0.0067|0.0069|0.0008|0.0024|0.0023|0.0048|
|**House Plant**|195|70.7692|0.6215|0.3507|0.8283|0.1222|0.1208|0.1699|0.0223|0.0290|0.0038|0.0079|0.0169|0.0261|
|**Television**|187|87.1658|0.7925|0.2840|0.8925|0.0968|0.1127|0.1819|0.0645|0.0882|0.0121|0.0182|0.0577|0.0844|
|**Bottle**|184|9.7826|0.1104|0.2439|0.7804|0.1160|0.0377|0.1015|0.0048|0.0065|0.0040|0.0337|0.0041|0.0321|
|**Sofa**|181|86.7403|0.8379|0.3157|0.9589|0.0380|0.0461|0.1272|0.1006|0.1043|0.0122|0.0118|0.0889|0.1018|
|**Plate**|176|10.7955|0.1162|0.2463|0.7539|0.1345|0.0390|0.1021|0.0049|0.0038|0.0014|0.0037|0.0018|0.0039|
|**Statue**|167|41.9162|0.3358|0.3538|0.7208|0.1439|0.0580|0.1243|0.0126|0.0202|0.0031|0.0068|0.0071|0.0148|
|**Laptop**|164|46.9512|0.4106|0.3852|0.7909|0.1467|0.0740|0.1350|0.0129|0.0170|0.0028|0.0052|0.0075|0.0132|
|**Dresser**|157|78.9809|0.7551|0.3630|0.9376|0.0593|0.0693|0.1213|0.0964|0.1013|0.0438|0.1140|0.0854|0.1059|
|**Fridge**|146|82.8767|0.7917|0.3530|0.9497|0.0535|0.0273|0.0626|0.1363|0.2024|0.0915|0.1955|0.1287|0.2013|
|**Bed**|143|81.1189|0.7451|0.3611|0.9118|0.1069|0.0292|0.0753|0.1101|0.1431|0.0296|0.0607|0.0949|0.1352|
|**Knife**|139|5.0360|0.0468|0.1647|0.7285|0.1265|0.0107|0.0413|0.0039|0.0026|0.0008|0.0029|0.0010|0.0030|
|**Fork**|138|1.4493|0.0199|0.1069|0.7991|0.0108|0.0085|0.0497|0.0060|0.0024|0.0004|0.0012|0.0005|0.0014|
|**Garbage Can**|132|81.0606|0.7448|0.3629|0.9179|0.0552|0.0041|0.0156|0.0199|0.0191|0.0036|0.0065|0.0168|0.0185|
|**Pillow**|132|56.8182|0.4998|0.3808|0.8099|0.1210|0.0918|0.1472|0.0091|0.0126|0.0013|0.0020|0.0057|0.0103|
|**Mug**|128|19.5312|0.1760|0.3227|0.8042|0.1162|0.0235|0.0794|0.0053|0.0058|0.0015|0.0093|0.0022|0.0089|
|**Spoon**|122|5.7377|0.0463|0.1688|0.7016|0.1391|0.0064|0.0351|0.0042|0.0036|0.0005|0.0015|0.0007|0.0018|
|**Wine Bottle**|114|40.3509|0.3485|0.3776|0.7775|0.1384|0.0582|0.1256|0.0050|0.0086|0.0076|0.0395|0.0066|0.0309|
|**Bread**|109|34.8624|0.3035|0.3790|0.7954|0.1300|0.0402|0.1048|0.0071|0.0080|0.0017|0.0042|0.0036|0.0063|
|**Arm Chair**|109|71.5596|0.6809|0.4283|0.9473|0.0642|0.0104|0.0290|0.0663|0.0717|0.0177|0.0289|0.0525|0.0662|
|**Spray Bottle**|107|37.3832|0.3540|0.3751|0.7966|0.1436|0.0898|0.1557|0.0072|0.0079|0.0013|0.0039|0.0035|0.0063|
|**Vase**|102|38.2353|0.3273|0.3992|0.8159|0.1307|0.0248|0.0772|0.0073|0.0110|0.0017|0.0029|0.0038|0.0076|
|**Cup**|94|14.8936|0.1313|0.2858|0.7940|0.1148|0.0153|0.0503|0.0041|0.0038|0.0009|0.0014|0.0014|0.0022|
|**Pencil**|89|3.3708|0.0443|0.1505|0.7644|0.1111|0.0192|0.0649|0.0018|0.0011|0.0001|0.0002|0.0001|0.0004|
|**Floor Lamp**|89|78.6517|0.7528|0.3460|0.9239|0.0785|0.1223|0.1678|0.0931|0.1386|0.1160|0.1994|0.0980|0.1526|
|**Toaster**|87|43.6782|0.3807|0.4027|0.8191|0.1152|0.0407|0.1008|0.0093|0.0133|0.0017|0.0022|0.0050|0.0097|
|**Kettle**|84|16.6667|0.1552|0.3044|0.8129|0.0848|0.0237|0.0691|0.0120|0.0118|0.0016|0.0031|0.0034|0.0067|
|**Spatula**|82|3.6585|0.0368|0.1500|0.7579|0.1365|0.0094|0.0460|0.0072|0.0057|0.0012|0.0057|0.0015|0.0057|
|**Credit Card**|82|6.0976|0.0533|0.1621|0.6410|0.0718|0.0152|0.0595|0.0012|0.0005|0.0049|0.0317|0.0047|0.0307|
|**Butter Knife**|76|2.6316|0.0232|0.1078|0.6336|0.0647|0.0067|0.0373|0.0020|0.0001|0.0002|0.0004|0.0003|0.0005|
|**Toilet**|75|92.0000|0.8310|0.2360|0.8940|0.0970|0.1060|0.1040|0.0715|0.0869|0.0052|0.0051|0.0662|0.0853|
|**Washing Machine**|74|89.1892|0.8306|0.2763|0.9203|0.0819|0.0908|0.1803|0.0634|0.0731|0.0193|0.0354|0.0586|0.0712|
|**Shelving Unit**|73|76.7123|0.7211|0.3979|0.9357|0.0701|0.0140|0.0553|0.1070|0.1634|0.0310|0.0608|0.0893|0.1492|
|**TV Stand**|69|66.6667|0.6719|0.3783|0.9255|0.0494|0.1647|0.1844|0.0462|0.0498|0.0084|0.0136|0.0336|0.0450|
|**Lettuce**|69|39.1304|0.3706|0.3891|0.8272|0.1214|0.0771|0.1273|0.0048|0.0037|0.0004|0.0005|0.0021|0.0032|
|**Sink**|69|84.0580|0.7987|0.2857|0.9140|0.0807|0.1902|0.1828|0.0568|0.0611|0.0374|0.0377|0.0537|0.0582|
|**Dish Sponge**|68|5.8824|0.0570|0.1934|0.7909|0.1531|0.0112|0.0481|0.0019|0.0007|0.0008|0.0016|0.0008|0.0015|
|**Newspaper**|68|11.7647|0.1208|0.2682|0.7954|0.1185|0.0308|0.1003|0.0087|0.0068|0.0008|0.0017|0.0017|0.0037|
|**Potato**|66|3.0303|0.0303|0.1158|0.6424|0.1140|0.0112|0.0370|0.0016|0.0015|0.0020|0.0093|0.0020|0.0092|
|**Apple**|64|15.6250|0.1554|0.2871|0.7465|0.1305|0.0459|0.1302|0.0030|0.0033|0.0008|0.0029|0.0011|0.0030|
|**Soap Bottle**|64|23.4375|0.2198|0.3575|0.8397|0.1066|0.0300|0.0871|0.0061|0.0052|0.0017|0.0029|0.0027|0.0040|
|**Watch**|63|1.5873|0.0456|0.1303|0.5674|-|0.0372|0.1128|0.0010|-|0.0002|0.0004|0.0002|0.0004|
|**Side Table**|60|61.6667|0.5547|0.4351|0.8888|0.0969|0.0173|0.0521|0.0322|0.0364|0.0198|0.0368|0.0274|0.0367|
|**Tomato**|59|32.2034|0.2962|0.3583|0.7749|0.1410|0.0689|0.1306|0.0032|0.0036|0.0002|0.0003|0.0012|0.0025|
|**Garbage Bag**|59|89.8305|0.7961|0.2546|0.8754|0.0828|0.0964|0.1631|0.0156|0.0180|0.0106|0.0176|0.0151|0.0178|
|**Pan**|54|14.8148|0.1149|0.2507|0.6868|0.1181|0.0154|0.0598|0.0094|0.0110|0.0016|0.0039|0.0027|0.0060|
|**Salt Shaker**|53|13.2075|0.1400|0.2938|0.8538|0.0482|0.0314|0.0902|0.0031|0.0013|0.0005|0.0011|0.0008|0.0014|
|**Faucet**|52|57.6923|0.5421|0.3210|0.7871|0.1294|0.2079|0.1559|0.0041|0.0033|0.0116|0.0192|0.0073|0.0131|
|**Pepper Shaker**|50|16.0000|0.1490|0.2959|0.7712|0.1307|0.0305|0.1087|0.0024|0.0018|0.0005|0.0007|0.0008|0.0012|
|**Teddy Bear**|46|86.9565|0.7473|0.3072|0.8578|0.1129|0.0106|0.0260|0.0122|0.0170|0.0009|0.0004|0.0108|0.0163|
|**Toilet Paper**|46|30.4348|0.3009|0.3591|0.7981|0.1302|0.0833|0.1402|0.0063|0.0065|0.0004|0.0006|0.0022|0.0045|
|**Stool**|44|77.2727|0.6852|0.3732|0.8812|0.0826|0.0189|0.0432|0.0185|0.0251|0.0037|0.0040|0.0151|0.0229|
|**Candle**|43|23.2558|0.2166|0.3226|0.7499|0.1299|0.0549|0.1267|0.0037|0.0041|0.0006|0.0015|0.0013|0.0027|
|**Baseball Bat**|43|60.4651|0.4955|0.4066|0.8094|0.1266|0.0155|0.0638|0.0130|0.0175|0.0055|0.0107|0.0101|0.0155|
|**Cart**|42|78.5714|0.7546|0.3983|0.9595|0.0370|0.0036|0.0108|0.0753|0.0711|0.0105|0.0257|0.0614|0.0693|
|**Microwave**|40|52.5000|0.4511|0.4393|0.8570|0.1095|0.0024|0.0090|0.0120|0.0115|0.0057|0.0078|0.0090|0.0103|
|**Desk Lamp**|40|55.0000|0.5072|0.4109|0.8519|0.1324|0.0858|0.1547|0.0197|0.0212|0.0033|0.0069|0.0123|0.0182|
|**Plunger**|39|76.9231|0.6370|0.3052|0.7852|0.1114|0.1433|0.2023|0.0055|0.0045|0.0015|0.0012|0.0046|0.0043|
|**Basket Ball**|37|78.3784|0.6547|0.3585|0.8353|0.0949|0.0000|0.0000|0.0056|0.0061|0.0011|0.0012|0.0046|0.0057|
|**Dog Bed**|34|44.1176|0.4362|0.4570|0.9249|0.0746|0.0504|0.1500|0.0313|0.0257|0.0054|0.0081|0.0169|0.0221|
|**Ladle**|33|6.0606|0.0792|0.1730|0.6110|0.0784|0.0449|0.1080|0.0028|0.0032|0.0012|0.0038|0.0013|0.0037|
|**Pot**|33|36.3636|0.3331|0.4078|0.8351|0.1488|0.0463|0.1280|0.0159|0.0169|0.0078|0.0173|0.0108|0.0173|
|**Paper Towel Roll**|32|21.8750|0.1852|0.3565|0.8422|0.1089|0.0013|0.0039|0.0077|0.0072|0.0020|0.0033|0.0032|0.0049|
|**Alarm Clock**|29|44.8276|0.3814|0.3895|0.7795|0.1501|0.0579|0.1276|0.0064|0.0068|0.0023|0.0038|0.0041|0.0056|
|**Tissue Box**|21|33.3333|0.3139|0.4052|0.8521|0.0663|0.0448|0.1289|0.0078|0.0049|0.0010|0.0011|0.0033|0.0044|
|**Egg**|20|15.0000|0.1340|0.2716|0.7144|0.0349|0.0316|0.1148|0.0015|0.0008|0.0002|0.0003|0.0004|0.0006|
|**Cloth**|17|23.5294|0.2139|0.3595|0.8380|0.0392|0.0219|0.0469|0.0051|0.0025|0.0010|0.0017|0.0019|0.0026|
|**Safe**|16|50.0000|0.4540|0.4605|0.8985|0.0488|0.0094|0.0178|0.0184|0.0216|0.0047|0.0041|0.0116|0.0166|
|**Desk**|15|73.3333|0.6542|0.4167|0.8891|0.1243|0.0083|0.0167|0.0637|0.0555|0.0239|0.0415|0.0531|0.0538|
|**Coffee Machine**|14|64.2857|0.6091|0.3808|0.8598|0.1366|0.1579|0.1955|0.0084|0.0049|0.0070|0.0115|0.0079|0.0075|
|**Tennis Racket**|13|23.0769|0.2256|0.3658|0.8259|0.1356|0.0455|0.1347|0.0226|0.0299|0.0014|0.0015|0.0063|0.0154|
|**Laundry Hamper**|7|85.7143|0.8010|0.3543|0.9345|0.0308|0.0000|-|0.0131|0.0100|0.0039|-|0.0118|0.0098|
|**Table Top Decor**|6|33.3333|0.2601|0.3049|0.6341|0.1830|0.0732|0.0628|0.0034|0.0011|0.0058|0.0088|0.0050|0.0070|
|**Vacuum Cleaner**|5|80.0000|0.7059|0.3987|0.8824|0.0655|0.0000|-|0.0089|0.0039|0.0002|-|0.0071|0.0052|
|**Soap Bar**|4|0.0000|0.0365|0.0723|-|-|0.0365|0.0723|-|-|0.0001|0.0000|0.0001|0.0000|
|**Room Decor**|4|25.0000|0.2043|0.4086|0.8172|-|0.0000|0.0000|0.0191|-|0.0070|0.0034|0.0100|0.0067|
|**Dumbbell**|2|50.0000|0.4734|0.6694|0.9467|-|0.0000|-|0.0295|-|0.0001|-|0.0148|0.0208|
|**Coffee Table**|1|100.0000|0.9273|-|0.9273|-|-|-|0.0194|-|-|-|0.0194|-|
|**Ottoman**|1|100.0000|0.9822|-|0.9822|-|-|-|0.0872|-|-|-|0.0872|-|
I risultati dell'evaluation in zero shot sono molto promettenti: abbiamo una precisione del 39.9% che indica un miglioramento sostanziale rispetto alle performance di kosmos2:

|Performance Kosmos2 | | |
| ---- | ---- | ---- |
| **entity_type** | **Number of Occurrences** | **Percentage of Matches** |
| **Total** | 10000 | 22.2700 |

| Performance cogVLM |  |  |
| ---- | ---- | ---- |
| **entity_type** | **Number of Occurrences** | **Percentage of matches** |
| **Total** | 10000 | 39.9300 |
Un miglioramento che si avvicina al doppio della percentuale di match su tutte le istanze.

| **entity_type** | **Percentage of matches cogVLM** | Percentage of matches Kosmos2 |  |
| ---- | ---- | ---- | ---- |
| **Total** | 39.9300 | 23.0500 | 1 |
| **Painting** | 64.1485 | 39.9488 | 1 |
| **Cell Phone** | 9.9010 | 1.6502 | 1 |
| **Remote Control** | 10.2767 | 0.5929 | 1 |
| **Book** | 23.6052 | 8.7983 | 1 |
| **Chair** | 45.2656 | 32.3326 | 1 |
| **Pen** | 2.4194 | 0.0000 | 1 |
| **Dining Table** | 82.5688 | 63.9144 | 1 |
| **Key Chain** | 10.5023 | 0.0000 | 1 |
| **Box** | 44.9541 | 12.3853 | 1 |
| **Counter Top** | 52.2936 | 41.2844 | 1 |
| **Bowl** | 25.1232 | 6.4039 | 1 |
| **House Plant** | 70.7692 | 46.6667 | 1 |
| **Television** | 87.1658 | 66.8449 | 1 |
| **Bottle** | 9.7826 | 5.9783 | 1 |
| **Sofa** | 86.7403 | 70.7182 | 1 |
| **Plate** | 10.7955 | 3.4091 | 1 |
| **Statue** | 41.9162 | 19.1617 | 1 |
| **Laptop** | 46.9512 | 19.5122 | 1 |
| **Dresser** | 78.9809 | 62.4204 | 1 |
| **Fridge** | 82.8767 | 61.6438 | 1 |
| **Bed** | 81.1189 | 60.1399 | 1 |
| **Knife** | 5.0360 | 1.4388 | 1 |
| **Fork** | 1.4493 | 0.7246 | 1 |
| **Garbage Can** | 81.0606 | 59.0909 | 1 |
| **Pillow** | 56.8182 | 14.3939 | 1 |
| **Mug** | 19.5312 | 6.2500 | 1 |
| **Spoon** | 5.7377 | 0.0000 | 1 |
| **Wine Bottle** | 40.3509 | 7.0175 | 1 |
| **Bread** | 34.8624 | 9.1743 | 1 |
| **Arm Chair** | 71.5596 | 59.6330 | 1 |
| **Spray Bottle** | 37.3832 | 17.7570 | 1 |
| **Vase** | 38.2353 | 22.5490 | 1 |
| **Cup** | 14.8936 | 3.1915 | 1 |
| **Pencil** | 3.3708 | 1.1236 | 1 |
| **Floor Lamp** | 78.6517 | 62.9213 | 1 |
| **Toaster** | 43.6782 | 13.7931 | 1 |
| **Kettle** | 16.6667 | 9.5238 | 1 |
| **Spatula** | 3.6585 | 0.0000 | 1 |
| **Credit Card** | 6.0976 | 0.0000 | 1 |
| **Butter Knife** | 2.6316 | 0.0000 | 1 |
| **Toilet** | 92.0000 | 62.6667 | 1 |
| **Washing Machine** | 89.1892 | 62.1622 | 1 |
| **Shelving Unit** | 76.7123 | 52.0548 | 1 |
| **TV Stand** | 66.6667 | 17.3913 | 1 |
| **Lettuce** | 39.1304 | 10.1449 | 1 |
| **Sink** | 84.0580 | 75.3623 | 1 |
| **Dish Sponge** | 5.8824 | 0.0000 | 1 |
| **Newspaper** | 11.7647 | 2.9412 | 1 |
| **Potato** | 3.0303 | 0.0000 | 1 |
| **Apple** | 15.6250 | 1.5625 | 1 |
| **Soap Bottle** | 23.4375 | 12.5000 | 1 |
| **Watch** | 1.5873 | 0.0000 | 1 |
| **Side Table** | 61.6667 | 35.0000 | 1 |
| **Tomato** | 32.2034 | 6.7797 | 1 |
| **Garbage Bag** | 89.8305 | 67.7966 | 1 |
| **Pan** | 14.8148 | 5.5556 | 1 |
| **Salt Shaker** | 13.2075 | 1.8868 | 1 |
| **Faucet** | 57.6923 | 3.8462 | 1 |
| **Pepper Shaker** | 16.0000 | 2.0000 | 1 |
| **Teddy Bear** | 86.9565 | 50.0000 | 1 |
| **Toilet Paper** | 30.4348 | 6.5217 | 1 |
| **Stool** | 77.2727 | 36.3636 | 1 |
| **Candle** | 23.2558 | 9.3023 | 1 |
| **Baseball Bat** | 60.4651 | 16.2791 | 1 |
| **Cart** | 78.5714 | 57.1429 | 1 |
| **Microwave** | 52.5000 | 10.0000 | 1 |
| **Desk Lamp** | 55.0000 | 17.5000 | 1 |
| **Plunger** | 76.9231 | 17.9487 | 1 |
| **Basket Ball** | 78.3784 | 35.1351 | 1 |
| **Dog Bed** | 44.1176 | 32.3529 | 1 |
| **Ladle** | 6.0606 | 0.0000 | 1 |
| **Pot** | 36.3636 | 21.2121 | 1 |
| **Paper Towel Roll** | 21.8750 | 6.2500 | 1 |
| **Alarm Clock** | 44.8276 | 24.1379 | 1 |
| **Tissue Box** | 33.3333 | 0.0000 | 1 |
| **Egg** | 15.0000 | 0.0000 | 1 |
| **Cloth** | 23.5294 | 0.0000 | 1 |
| **Safe** | 50.0000 | 25.0000 | 1 |
| **Desk** | 73.3333 | 46.6667 | 1 |
| **Coffee Machine** | 64.2857 | 42.8571 | 1 |
| **Tennis Racket** | 23.0769 | 7.6923 | 1 |
| **Laundry Hamper** | 85.7143 | 57.1429 | 1 |
| **Table Top Decor** | 33.3333 | 0.0000 | 1 |
| **Vacuum Cleaner** | 80.0000 | 60.0000 | 1 |
| **Soap Bar** | 0.0000 | 0.0000 | X |
| **Room Decor** | 25.0000 | 0.0000 | 1 |
| **Dumbbell** | 50.0000 | 50.0000 | X |
| **Coffee Table** | 100.0000 | 100.0000 | 1 |
| **Ottoman** | 100.0000 | 100.0000 | 1 |
|  |  |  |  |

C'è un miglioramento evidente: in tutte le istanze cogVLM performa meglio di kosmos.
### Alcuni esempi 

Qui sotto ho riportato alcuni esempi di confronto tra la performance di cogVLM e di kosmos2.

![[Pasted image 20240323101257.png]]

In questo esempio è chiaro che cogVLM riesca a trovare l'entità "carrello" anche in una situazione in cui è parzialmente visibile, mentre kosmos non riusciva ad individuarlo, trovando invece un lavandino.

![[Pasted image 20240323101403.png]]

![[Pasted image 20240323101519.png]]


Anche questi esempi illustrano le capacità superiori di cogVLM nel trovare oggetti più piccoli e parzialmente ostruiti alla vista, in questo caso una cassettiera e una mela.

![[Pasted image 20240323101605.png]]

Un problema ricorrente di kosmos era quello di confondere sedie e tavoli, sembra che questo problema non sia presente, anche alla luce dell'ottima performance che kosmos ha sell'entità sedia:

| **entity_type** | **Percentage of matches cogVLM** | **Percentage of Matches kosmos** |
| ---- | ---- | ---- |
| **Chair** | 45.2656 | 25.0564 |

Un'altra cosa interessante è che cogVLM riesce a distinguere bene tra poltrona e Sofa. Cosa che invece kosmos faceva con difficoltà:

![[Pasted image 20240323103457.png]]

Inoltre qui abbiamo alcuni esempi di oggetti di piccole dimensioni correttamente riconosciuti da kosmos:

![[Pasted image 20240323103623.png]]

![[Pasted image 20240323103650.png]]

![[Pasted image 20240323103714.png]]

![[Pasted image 20240323103737.png]]

![[Pasted image 20240323103826.png]]

### Analisi delle performance su bounding box di piccole dimensioni

Come per kosmos ho analizzato la performance del modello al dipendere dalle dimensioni medie del bounding box.

![[Pasted image 20240323104815.png]]

Anche in questo caso sembra esserci una dipendenza lineare tra la dimensione del bounding box e percentuale di match, almeno per la prima parte del grafico:

![[Pasted image 20240323105352.png]]

Anche se migliora molto più rapidamente di kosmos: cogVLM supera una percentuale di match del 40% già per valori inferiori allo 0.01
Mentre per kosmos, alla stessa dimensione, superavano appena il 20%.

![[Pasted image 20240307121852.png]]

Inoltre ricordiamo che kosmos la curva si appiattiva su valori di match del 60% circa. Mentre per Kosmos questi valori raggiungono quasi il 90% anche per entità con molte istanze ( e quindi molto affidabili )

![[Pasted image 20240323105641.png]]

![[Pasted image 20240307121826.png]]


## Paternity Test cogVLM

Anche con cogVLM abbiamo provato a sfruttare la paternità delle entità per migliorare la performance.
A differenza di quanto visto con Kosmos i risultati sono effettivamente migliorati, anche se marginalmente.

|   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|**entity_type**|**Number of Occurrences**|**Percentage of matches**|**Average Overlapping Index**|**Std Average Overlapping Index**|**Average Overlapping Index (matched)**|**Std Average Overlapping Index (matched)**|**Average Overlapping Index (Unmatched)**|**Std Average Overlapping Index (Unmatched)**|**Avg BBox Dimensions (Correct)**|**Std Avg BBox Dimensions (Correct)**|**Avg BBox Dimensions (Incorrect)**|**Std Avg BBox Dimensions (Incorrect)**|**Average BBox Dimensions (All)**|**Std Average BBox Dimensions (All)**|
|**Total**|10000|40.6400|0.3786|0.4202|0.8677|0.1200|0.0437|0.1077|0.0453|0.0858|0.0061|0.0320|0.0220|0.0630|
|**Painting**|781|63.5083|0.5853|0.4380|0.9128|0.0740|0.0153|0.0632|0.0447|0.0729|0.0138|0.0319|0.0334|0.0630|
|**Cell Phone**|606|10.3960|0.1002|0.2405|0.7635|0.1156|0.0232|0.0773|0.0031|0.0025|0.0007|0.0040|0.0009|0.0039|
|**Remote Control**|506|10.0791|0.1025|0.2288|0.7231|0.1285|0.0329|0.0910|0.0037|0.0037|0.0005|0.0013|0.0008|0.0019|
|**Book**|466|24.6781|0.2182|0.3342|0.7725|0.1290|0.0366|0.0945|0.0074|0.0087|0.0016|0.0074|0.0030|0.0081|
|**Chair**|433|44.8037|0.4235|0.4236|0.8737|0.1214|0.0580|0.1199|0.0339|0.0356|0.0138|0.0183|0.0228|0.0292|
|**Pen**|372|2.9570|0.0399|0.1405|0.7442|0.1253|0.0184|0.0655|0.0028|0.0013|0.0002|0.0009|0.0003|0.0010|
|**Dining Table**|327|82.5688|0.7677|0.3242|0.9086|0.0839|0.1003|0.1702|0.0726|0.0848|0.0169|0.0259|0.0629|0.0806|
|**Key Chain**|219|10.9589|0.1091|0.2261|0.6697|0.1155|0.0401|0.1105|0.0019|0.0011|0.0012|0.0119|0.0013|0.0112|
|**Box**|218|53.2110|0.4594|0.4110|0.8343|0.1028|0.0332|0.0778|0.0124|0.0265|0.0027|0.0039|0.0079|0.0201|
|**Counter Top**|218|53.6697|0.5766|0.3644|0.8918|0.1138|0.2115|0.1493|0.1163|0.1511|0.1030|0.1089|0.1101|0.1331|
|**Bowl**|203|27.5862|0.2395|0.3554|0.7922|0.1344|0.0289|0.0782|0.0055|0.0059|0.0011|0.0036|0.0023|0.0048|
|**House Plant**|195|70.7692|0.6328|0.3374|0.8289|0.1228|0.1581|0.1822|0.0221|0.0291|0.0044|0.0083|0.0169|0.0261|
|**Television**|187|86.6310|0.7889|0.2900|0.8937|0.0979|0.1099|0.1813|0.0648|0.0884|0.0121|0.0178|0.0577|0.0844|
|**Bottle**|184|12.5000|0.1330|0.2638|0.7676|0.1309|0.0423|0.1051|0.0043|0.0059|0.0040|0.0343|0.0041|0.0321|
|**Sofa**|181|86.7403|0.8370|0.3153|0.9579|0.0368|0.0461|0.1272|0.1006|0.1043|0.0122|0.0118|0.0889|0.1018|
|**Plate**|176|14.7727|0.1493|0.2752|0.7559|0.1366|0.0442|0.1025|0.0049|0.0038|0.0012|0.0036|0.0018|0.0039|
|**Statue**|167|48.5030|0.3958|0.3422|0.7120|0.1457|0.0981|0.1541|0.0114|0.0193|0.0030|0.0065|0.0071|0.0148|
|**Laptop**|164|49.3902|0.4403|0.3761|0.7885|0.1486|0.1005|0.1515|0.0127|0.0167|0.0025|0.0046|0.0075|0.0132|
|**Dresser**|157|77.7070|0.7430|0.3708|0.9368|0.0594|0.0674|0.1174|0.0963|0.1013|0.0474|0.1142|0.0854|0.1059|
|**Fridge**|146|82.8767|0.7932|0.3524|0.9514|0.0421|0.0273|0.0626|0.1363|0.2024|0.0915|0.1955|0.1287|0.2013|
|**Bed**|143|79.7203|0.7359|0.3668|0.9135|0.1017|0.0375|0.0831|0.1117|0.1439|0.0292|0.0589|0.0949|0.1352|
|**Knife**|139|5.7554|0.0542|0.1759|0.7214|0.1134|0.0135|0.0557|0.0036|0.0026|0.0008|0.0029|0.0010|0.0030|
|**Fork**|138|1.4493|0.0216|0.1094|0.8112|0.0279|0.0100|0.0525|0.0060|0.0024|0.0004|0.0012|0.0005|0.0014|
|**Garbage Can**|132|81.0606|0.7441|0.3626|0.9170|0.0557|0.0041|0.0156|0.0199|0.0191|0.0036|0.0065|0.0168|0.0185|
|**Pillow**|132|57.5758|0.5121|0.3814|0.8192|0.1117|0.0953|0.1494|0.0089|0.0125|0.0014|0.0022|0.0057|0.0103|
|**Mug**|128|20.3125|0.1912|0.3296|0.8100|0.1155|0.0335|0.0979|0.0051|0.0058|0.0015|0.0094|0.0022|0.0089|
|**Spoon**|122|5.7377|0.0482|0.1727|0.7210|0.1369|0.0073|0.0346|0.0042|0.0036|0.0005|0.0015|0.0007|0.0018|
|**Wine Bottle**|114|42.1053|0.3673|0.3826|0.7859|0.1383|0.0629|0.1308|0.0048|0.0085|0.0079|0.0401|0.0066|0.0309|
|**Bread**|109|30.2752|0.2904|0.3698|0.8179|0.1245|0.0613|0.1213|0.0080|0.0083|0.0017|0.0041|0.0036|0.0063|
|**Arm Chair**|109|71.5596|0.6804|0.4285|0.9467|0.0683|0.0104|0.0290|0.0663|0.0717|0.0177|0.0289|0.0525|0.0662|
|**Spray Bottle**|107|36.4486|0.3581|0.3709|0.8036|0.1439|0.1025|0.1552|0.0073|0.0079|0.0014|0.0038|0.0035|0.0063|
|**Vase**|102|36.2745|0.3294|0.3955|0.8261|0.1278|0.0467|0.1181|0.0075|0.0112|0.0017|0.0029|0.0038|0.0076|
|**Cup**|94|18.0851|0.1563|0.2988|0.7734|0.1191|0.0201|0.0480|0.0038|0.0035|0.0009|0.0014|0.0014|0.0022|
|**Pencil**|89|3.3708|0.0465|0.1479|0.7464|0.1116|0.0221|0.0669|0.0018|0.0011|0.0001|0.0002|0.0001|0.0004|
|**Floor Lamp**|89|78.6517|0.7511|0.3459|0.9218|0.0823|0.1223|0.1678|0.0931|0.1386|0.1160|0.1994|0.0980|0.1526|
|**Toaster**|87|45.9770|0.4084|0.3915|0.8075|0.1201|0.0687|0.1337|0.0089|0.0131|0.0017|0.0022|0.0050|0.0097|
|**Kettle**|84|16.6667|0.1662|0.3106|0.8230|0.1096|0.0349|0.0938|0.0122|0.0116|0.0016|0.0031|0.0034|0.0067|
|**Spatula**|82|3.6585|0.0483|0.1718|0.8034|0.1775|0.0196|0.0841|0.0072|0.0057|0.0012|0.0057|0.0015|0.0057|
|**Credit Card**|82|6.0976|0.0581|0.1702|0.6703|0.0787|0.0183|0.0654|0.0012|0.0005|0.0049|0.0317|0.0047|0.0307|
|**Butter Knife**|76|2.6316|0.0243|0.1068|0.6189|0.0854|0.0082|0.0408|0.0020|0.0001|0.0002|0.0004|0.0003|0.0005|
|**Toilet**|75|92.0000|0.8294|0.2295|0.8899|0.0980|0.1339|0.1331|0.0715|0.0869|0.0052|0.0051|0.0662|0.0853|
|**Washing Machine**|74|87.8378|0.8330|0.2732|0.9289|0.0499|0.1411|0.2194|0.0624|0.0733|0.0309|0.0481|0.0586|0.0712|
|**Shelving Unit**|73|76.7123|0.7211|0.3980|0.9358|0.0707|0.0140|0.0553|0.1070|0.1634|0.0310|0.0608|0.0893|0.1492|
|**TV Stand**|69|65.2174|0.6624|0.3751|0.9211|0.0502|0.1773|0.1865|0.0429|0.0453|0.0160|0.0396|0.0336|0.0450|
|**Lettuce**|69|40.5797|0.3796|0.3871|0.8160|0.1430|0.0816|0.1289|0.0046|0.0038|0.0004|0.0005|0.0021|0.0032|
|**Sink**|69|84.0580|0.7973|0.2853|0.9124|0.0815|0.1903|0.1829|0.0568|0.0611|0.0374|0.0377|0.0537|0.0582|
|**Dish Sponge**|68|4.4118|0.0557|0.1741|0.7583|0.1250|0.0233|0.0840|0.0019|0.0008|0.0008|0.0015|0.0008|0.0015|
|**Newspaper**|68|14.7059|0.1403|0.2836|0.7772|0.1488|0.0305|0.0874|0.0077|0.0064|0.0007|0.0016|0.0017|0.0037|
|**Potato**|66|6.0606|0.0545|0.1623|0.6492|0.1431|0.0162|0.0488|0.0010|0.0011|0.0020|0.0095|0.0020|0.0092|
|**Apple**|64|17.1875|0.1912|0.2999|0.7541|0.1264|0.0743|0.1580|0.0027|0.0033|0.0008|0.0029|0.0011|0.0030|
|**Soap Bottle**|64|28.1250|0.2647|0.3705|0.8283|0.1127|0.0442|0.1028|0.0051|0.0043|0.0018|0.0035|0.0027|0.0040|
|**Watch**|63|1.5873|0.0400|0.1200|0.6040|-|0.0309|0.0967|0.0010|-|0.0002|0.0004|0.0002|0.0004|
|**Side Table**|60|60.0000|0.5390|0.4378|0.8872|0.0978|0.0166|0.0511|0.0327|0.0367|0.0195|0.0360|0.0274|0.0367|
|**Tomato**|59|32.2034|0.3035|0.3649|0.7903|0.1433|0.0722|0.1352|0.0032|0.0036|0.0002|0.0003|0.0012|0.0025|
|**Garbage Bag**|59|88.1356|0.7839|0.2741|0.8779|0.0803|0.0854|0.1597|0.0159|0.0180|0.0094|0.0164|0.0151|0.0178|
|**Pan**|54|16.6667|0.1493|0.2809|0.7379|0.1415|0.0316|0.0799|0.0103|0.0111|0.0012|0.0028|0.0027|0.0060|
|**Salt Shaker**|53|13.2075|0.1559|0.3000|0.8630|0.0554|0.0483|0.1182|0.0031|0.0013|0.0005|0.0011|0.0008|0.0014|
|**Faucet**|52|59.6154|0.5551|0.2976|0.7685|0.1391|0.2400|0.1483|0.0038|0.0033|0.0124|0.0193|0.0073|0.0131|
|**Pepper Shaker**|50|16.0000|0.1620|0.2981|0.7829|0.1413|0.0437|0.1150|0.0024|0.0018|0.0005|0.0007|0.0008|0.0012|
|**Teddy Bear**|46|84.7826|0.7539|0.2947|0.8682|0.0992|0.1173|0.1767|0.0125|0.0171|0.0009|0.0003|0.0108|0.0163|
|**Toilet Paper**|46|26.0870|0.2734|0.3593|0.8388|0.1099|0.0738|0.1210|0.0073|0.0065|0.0004|0.0006|0.0022|0.0045|
|**Stool**|44|77.2727|0.6814|0.3721|0.8759|0.0921|0.0202|0.0439|0.0185|0.0251|0.0037|0.0040|0.0151|0.0229|
|**Candle**|43|25.5814|0.2614|0.3217|0.7347|0.1422|0.0987|0.1639|0.0035|0.0040|0.0006|0.0015|0.0013|0.0027|
|**Baseball Bat**|43|60.4651|0.4969|0.4072|0.8117|0.1235|0.0155|0.0638|0.0130|0.0175|0.0055|0.0107|0.0101|0.0155|
|**Cart**|42|78.5714|0.7536|0.3996|0.9591|0.0368|0.0000|0.0000|0.0753|0.0711|0.0105|0.0257|0.0614|0.0693|
|**Microwave**|40|67.5000|0.5876|0.4008|0.8509|0.1071|0.0409|0.1327|0.0115|0.0116|0.0039|0.0035|0.0090|0.0103|
|**Desk Lamp**|40|60.0000|0.5407|0.4093|0.8552|0.1219|0.0691|0.1312|0.0193|0.0207|0.0018|0.0020|0.0123|0.0182|
|**Plunger**|39|76.9231|0.6340|0.3056|0.7836|0.1110|0.1351|0.1871|0.0055|0.0045|0.0015|0.0012|0.0046|0.0043|
|**Basket Ball**|37|78.3784|0.6569|0.3596|0.8362|0.1107|0.0070|0.0199|0.0056|0.0061|0.0009|0.0009|0.0046|0.0057|
|**Dog Bed**|34|41.1765|0.4078|0.4525|0.9204|0.0763|0.0491|0.1501|0.0318|0.0266|0.0064|0.0090|0.0169|0.0221|
|**Ladle**|33|3.0303|0.0822|0.1707|0.6664|-|0.0639|0.1368|0.0050|-|0.0012|0.0037|0.0013|0.0037|
|**Pot**|33|48.4848|0.4207|0.4039|0.8027|0.1463|0.0611|0.1512|0.0154|0.0176|0.0064|0.0163|0.0108|0.0173|
|**Paper Towel Roll**|32|25.0000|0.2118|0.3745|0.8438|0.1121|0.0011|0.0035|0.0074|0.0067|0.0019|0.0033|0.0032|0.0049|
|**Alarm Clock**|29|48.2759|0.4041|0.3880|0.7770|0.1297|0.0560|0.1291|0.0060|0.0067|0.0024|0.0039|0.0041|0.0056|
|**Tissue Box**|21|42.8571|0.4102|0.4327|0.8819|0.0522|0.0564|0.1405|0.0068|0.0047|0.0006|0.0007|0.0033|0.0044|
|**Egg**|20|15.0000|0.1400|0.2657|0.7144|0.0349|0.0386|0.1044|0.0015|0.0008|0.0002|0.0003|0.0004|0.0006|
|**Cloth**|17|23.5294|0.2226|0.3649|0.8488|0.0553|0.0300|0.0763|0.0062|0.0013|0.0006|0.0007|0.0019|0.0026|
|**Safe**|16|56.2500|0.4929|0.4505|0.8736|0.0882|0.0034|0.0090|0.0166|0.0210|0.0051|0.0042|0.0116|0.0166|
|**Desk**|15|73.3333|0.6543|0.4167|0.8892|0.1243|0.0083|0.0166|0.0637|0.0555|0.0239|0.0415|0.0531|0.0538|
|**Coffee Machine**|14|57.1429|0.5343|0.4309|0.8755|0.1522|0.0794|0.1255|0.0090|0.0049|0.0065|0.0104|0.0079|0.0075|
|**Tennis Racket**|13|23.0769|0.2589|0.3742|0.8609|0.1308|0.0782|0.1607|0.0226|0.0299|0.0014|0.0015|0.0063|0.0154|
|**Laundry Hamper**|7|85.7143|0.8010|0.3543|0.9345|0.0309|0.0000|-|0.0131|0.0100|0.0039|-|0.0118|0.0098|
|**Table Top Decor**|6|33.3333|0.2706|0.4126|0.8017|0.0663|0.0050|0.0100|0.0034|0.0011|0.0058|0.0088|0.0050|0.0070|
|**Vacuum Cleaner**|5|80.0000|0.7059|0.3987|0.8824|0.0655|0.0000|-|0.0089|0.0039|0.0002|-|0.0071|0.0052|
|**Soap Bar**|4|0.0000|0.1139|0.1950|-|-|0.1139|0.1950|-|-|0.0001|0.0000|0.0001|0.0000|
|**Room Decor**|4|25.0000|0.3223|0.3979|0.8172|-|0.1573|0.2725|0.0191|-|0.0070|0.0034|0.0100|0.0067|
|**Dumbbell**|2|50.0000|0.4756|0.6726|0.9511|-|0.0000|-|0.0295|-|0.0001|-|0.0148|0.0208|
|**Coffee Table**|1|100.0000|0.9209|-|0.9209|-|-|-|0.0194|-|-|-|0.0194|-|
|**Ottoman**|1|100.0000|0.9822|-|0.9822|-|-|-|0.0872|-|-|-|0.0872|-|

Riseptto a prima si è registrato un miglioramento di poco meno di un punto percentuale:

| **entity_type** | **Number of Occurrences** | **Percentage of matches** with paternity |
| ---- | ---- | ---- |
| **Total** | 10000 | 40.6400 |
| **entity_type** | **Number of Occurrences** | **Percentage of matches** |
| **Total** | 10000 | 39.9300 |
Anche in questo caso possiamo concludere che non è il prompt engineering la chiave per per migliorare sensibilmente le performance di questo modello.



Qui ci sono le entità che hanno migliorato il numero di match con l'approccio con paternità

| **entity_type** | **Difference** |
| ---- | ---- |
| **Microwave** | <font color='green'>15.0</font> |
| **Pot** | <font color='green'>12.12</font> |
| **Tissue Box** | <font color='green'>9.52</font> |
| **Box** | <font color='green'>8.26</font> |
| **Statue** | <font color='green'>6.59</font> |
| **Safe** | <font color='green'>6.25</font> |
| **Desk Lamp** | <font color='green'>5.0</font> |
| **Soap Bottle** | <font color='green'>4.69</font> |
| **Plate** | <font color='green'>3.98</font> |
| **Alarm Clock** | <font color='green'>3.45</font> |
| **Cup** | <font color='green'>3.19</font> |
| **Paper Towel Roll** | <font color='green'>3.12</font> |
| **Potato** | <font color='green'>3.03</font> |
| **Newspaper** | <font color='green'>2.94</font> |
| **Bottle** | <font color='green'>2.72</font> |
| **Bowl** | <font color='green'>2.46</font> |
| **Laptop** | <font color='green'>2.44</font> |
| **Candle** | <font color='green'>2.33</font> |
| **Toaster** | <font color='green'>2.3</font> |
| **Faucet** | <font color='green'>1.92</font> |
| **Pan** | <font color='green'>1.85</font> |
| **Wine Bottle** | <font color='green'>1.75</font> |
| **Apple** | <font color='green'>1.56</font> |
| **Lettuce** | <font color='green'>1.45</font> |
| **Counter Top** | <font color='green'>1.38</font> |
| **Book** | <font color='green'>1.07</font> |
| **Mug** | <font color='green'>0.78</font> |
| **Pillow** | <font color='green'>0.76</font> |
| **Knife** | <font color='green'>0.72</font> |
| **Total** | <font color='green'>0.71</font> |
| **Pen** | <font color='green'>0.54</font> |
| **Cell Phone** | <font color='green'>0.5</font> |
| **Key Chain** | <font color='green'>0.46</font> |
| **Tennis Racket** | <font color='gray'>0.0</font> |
| **Laundry Hamper** | <font color='gray'>0.0</font> |
| **Table Top Decor** | <font color='gray'>0.0</font> |
| **Vacuum Cleaner** | <font color='gray'>0.0</font> |
| **Soap Bar** | <font color='gray'>0.0</font> |
| **Room Decor** | <font color='gray'>0.0</font> |
| **Baseball Bat** | <font color='gray'>0.0</font> |
| **Arm Chair** | <font color='gray'>0.0</font> |
| **Pencil** | <font color='gray'>0.0</font> |
| **Shelving Unit** | <font color='gray'>0.0</font> |
| **Floor Lamp** | <font color='gray'>0.0</font> |
| **Kettle** | <font color='gray'>0.0</font> |
| **Spatula** | <font color='gray'>0.0</font> |
| **Credit Card** | <font color='gray'>0.0</font> |
| **Dumbbell** | <font color='gray'>0.0</font> |
| **Butter Knife** | <font color='gray'>0.0</font> |
| **Toilet** | <font color='gray'>0.0</font> |
| **Spoon** | <font color='gray'>0.0</font> |
| **Garbage Can** | <font color='gray'>0.0</font> |
| **Sofa** | <font color='gray'>0.0</font> |
| **Sink** | <font color='gray'>0.0</font> |
| **Watch** | <font color='gray'>0.0</font> |
| **Fork** | <font color='gray'>0.0</font> |
| **Tomato** | <font color='gray'>0.0</font> |
| **Fridge** | <font color='gray'>0.0</font> |
| **Salt Shaker** | <font color='gray'>0.0</font> |
| **Pepper Shaker** | <font color='gray'>0.0</font> |
| **Stool** | <font color='gray'>0.0</font> |
| **Ottoman** | <font color='gray'>0.0</font> |
| **Desk** | <font color='gray'>0.0</font> |
| **Cloth** | <font color='gray'>0.0</font> |
| **Egg** | <font color='gray'>0.0</font> |
| **Dining Table** | <font color='gray'>0.0</font> |
| **House Plant** | <font color='gray'>0.0</font> |
| **Basket Ball** | <font color='gray'>0.0</font> |
| **Plunger** | <font color='gray'>0.0</font> |
| **Cart** | <font color='gray'>0.0</font> |
| **Remote Control** | <font color='red'>-0.2</font> |
| **Chair** | <font color='red'>-0.46</font> |
| **Television** | <font color='red'>-0.53</font> |
| **Painting** | <font color='red'>-0.64</font> |
| **Spray Bottle** | <font color='red'>-0.93</font> |
| **Dresser** | <font color='red'>-1.27</font> |
| **Washing Machine** | <font color='red'>-1.35</font> |
| **Bed** | <font color='red'>-1.4</font> |
| **TV Stand** | <font color='red'>-1.45</font> |
| **Dish Sponge** | <font color='red'>-1.47</font> |
| **Side Table** | <font color='red'>-1.67</font> |
| **Garbage Bag** | <font color='red'>-1.69</font> |
| **Vase** | <font color='red'>-1.96</font> |
| **Teddy Bear** | <font color='red'>-2.17</font> |
| **Dog Bed** | <font color='red'>-2.94</font> |
| **Ladle** | <font color='red'>-3.03</font> |
| **Toilet Paper** | <font color='red'>-4.35</font> |
| **Bread** | <font color='red'>-4.59</font> |
| **Coffee Machine** | <font color='red'>-7.14</font> |



|   |   |
|---|---|
|**entity_type**|**miglioramento** in percentuale |
|**Microwave**|15.0|
|**Pot**|12.121200000000002|
|**Tissue Box**|9.523800000000001|
|**Box**|8.256900000000002|
|**Statue**|6.586799999999997|
|**Safe**|6.25|
|**Desk Lamp**|5.0|
|**Soap Bottle**|4.6875|
|**Plate**|3.9772|
|**Alarm Clock**|3.4483000000000033|
|**Cup**|3.1915000000000013|
|**Paper Towel Roll**|3.125|
|**Potato**|3.0303|
|**Newspaper**|2.9412000000000003|
|**Bottle**|2.7173999999999996|
|**Bowl**|2.463000000000001|
|**Laptop**|2.439|
|**Candle**|2.325599999999998|
|**Toaster**|2.2988|
|**Faucet**|1.923099999999998|
|**Pan**|1.8518999999999988|
|**Wine Bottle**|1.7543999999999969|
|**Apple**|1.5625|
|**Lettuce**|1.449300000000001|
|**Counter Top**|1.376100000000001|
|**Book**|1.0729000000000006|
|**Mug**|0.7813000000000017|
|**Pillow**|0.7576000000000036|
|**Knife**|0.7194000000000003|
|**Total**|0.7100000000000009|
|**Pen**|0.5375999999999999|
|**Cell Phone**|0.495000000000001|
|**Key Chain**|0.4565999999999999|

Alcune entità però hanno peggiorato il loro rendimento con l'approccio con paternità:

|  |  |
| ---- | ---- |
| **entity_type** | Peggioramento in percentuale |
| **Coffee Machine** | 7.142800000000008 |
| **Bread** | 4.587199999999999 |
| **Toilet Paper** | 4.347799999999999 |
| **Ladle** | 3.0303 |
| **Dog Bed** | 2.941100000000006 |
| **Teddy Bear** | 2.1739000000000033 |
| **Vase** | 1.960799999999999 |
| **Garbage Bag** | 1.694900000000004 |
| **Side Table** | 1.6666999999999987 |
| **Dish Sponge** | 1.4705999999999992 |
| **TV Stand** | 1.449300000000008 |
| **Bed** | 1.3986000000000018 |
| **Washing Machine** | 1.3513999999999982 |
| **Dresser** | 1.2739000000000118 |
| **Spray Bottle** | 0.9346000000000032 |
| **Painting** | 0.6402000000000001 |
| **Television** | 0.5348000000000042 |
| **Chair** | 0.4619 |
| **Remote Control** | 0.19759999999999955 |
|  |  |

Molte entità, invece sono rimaste uguali

| **entity_type** | **Difference** |
| ---- | ---- |
| **Coffee Table** | 0.0 |
| **Cart** | 0.0 |
| **Plunger** | 0.0 |
| **Basket Ball** | 0.0 |
| **House Plant** | 0.0 |
| **Dining Table** | 0.0 |
| **Egg** | 0.0 |
| **Cloth** | 0.0 |
| **Desk** | 0.0 |
| **Dumbbell** | 0.0 |
| **Stool** | 0.0 |
| **Tennis Racket** | 0.0 |
| **Laundry Hamper** | 0.0 |
| **Table Top Decor** | 0.0 |
| **Vacuum Cleaner** | 0.0 |
| **Soap Bar** | 0.0 |
| **Room Decor** | 0.0 |
| **Baseball Bat** | 0.0 |
| **Arm Chair** | 0.0 |
| **Pencil** | 0.0 |
| **Shelving Unit** | 0.0 |
| **Floor Lamp** | 0.0 |
| **Kettle** | 0.0 |
| **Spatula** | 0.0 |
| **Credit Card** | 0.0 |
| **Butter Knife** | 0.0 |
| **Toilet** | 0.0 |
| **Spoon** | 0.0 |
| **Garbage Can** | 0.0 |
| **Sofa** | 0.0 |
| **Sink** | 0.0 |
| **Watch** | 0.0 |
| **Fork** | 0.0 |
| **Tomato** | 0.0 |
| **Fridge** | 0.0 |
| **Salt Shaker** | 0.0 |
| **Pepper Shaker** | 0.0 |
| **Ottoman** | 0.0 |

C'è da notare quindi, che nonostante la percentuale totale dei match non sia significativamente cambiata con il nuovo approccio, alcune entità, invece, hanno avuto un netto miglioramento.
È importante anche notare che tutte le entità che sono migliorate sono entità di piccole dimensioni che si potevano trovare posti su oggetti eterogenei, mentre le entità che hanno registrato un peggioramento, contengono alcune di grandi dimensioni, come

| entity type | peggioramento in percentuale |
| ---- | ---- |
| **TV Stand** | 1.449300000000008 |
| **Bed** | 1.3986000000000018 |
| **Washing Machine** | 1.3513999999999982 |
| **Dresser** | 1.2739000000000118 |


### Esempi
Nel github messo a disposizione potete trovare uno script chiamato definitivo_display.py. È un tool da linea di comando scritto in python che permette di visualizzare la differenza tra l'output dei file csv dopo l'evaluation.
lanciandolo con l'opzione --mismatch_only si possono vedere le istanze in cui c'è stato un mismatch tra le entità individuate con paternity prompt e quelle individuate senza paternity prompt.

```bash
 ./definitivo_display.py --mismatch_only
```

Si può inoltre selezionare una entità specifica da analizzare

```bash
./definitivo_display.py --mismatch_only --entity_type Microwave
```
analizziamo microwave, che è l'entità che è migliorata maggiormente in percentuale, cioè che ha beneficiato di più del prompt engineering

#### Microwave


![[Pasted image 20240326121217.png]]

In questo particolare esempio si può vedere come specificare la posizione del microonde abbia permesso al modello di trovarlo. È chiaramente difficile, anche per un umano, discernere quale tra le due masse grigie era effettivamente il microonde, sapere che l'oggetto si trovava sul tavolo ha permesso a cogVLM di fare una predizione più appropriata che poi si è rivelata giusta.

![[Pasted image 20240326121445.png]]

![[Pasted image 20240326121512.png]]

![[Pasted image 20240326121544.png]]

#### Coffee Machine
Procediamo con un esmpio neggativo, in cui il prompt engineering ha "confuso" il modell. È il caso di coffee machine

| **entity_type** | Peggioramento in percentuale |
| ---- | ---- |
| **Coffee Machine** | 7.142800000000008 |
Il peggioramento però è dovuto ad una sola immagine: quindi poco significativo.
Così è anche per Toilet paper e Ladle.

![[Pasted image 20240326121827.png]]

#### Bread
Un peggioramento un po' più significativo lo ha avuto "Bread"

![[Pasted image 20240326122139.png]]

![[Pasted image 20240326122158.png]]

![[Pasted image 20240326122220.png]]

A mio parere questo peggioramento è dovuto al fatto che il modello avrebbe già correttamente collocato il pane sul tavolo, ed il prompt lo ha semplicemente "confuso". Un'altra opzione è che il gran numero di oggetti sul tavolo renda più difficile al modello scegliere consistentemente la stessa entità (e che dunque questo cambio sia dovuto al caso).

#### Conclusioni su Paternity
È abbastanza evidente che paternity permetta di migliorare le performance in maniera abbastanza consistente, il miglioramento si registra nei piccoli oggetti, ed è poco influente sulla statistica finale principalmente perchè molte entità sono invece senza un'entità padre, specialmente quelle più grandi.


### Conclusioni

Questa analisi mette in luce un'evidente superiorità di cogVLM sul task osservato su tutti i punti di vista: individuazione di bounding box di piccole dimensioni, di grandi dimensioni, parzialmente ostruiti e questo si traduce in una overall performance dominante. Un fine tuning su questo task potrebbe migliorare ulteriormente i risultati ottenuti.

## DA FARE
AGGIUNGERE I CHILDREN COME DA FILE (fatto)
aggiungi lexical reference nel grounding per ogni entità. (obiezione)
Fai file output.csv + shuffle head 10k e poi te lo salvi (fatto: shuffled_output_data.csv)
spiega perchè hai scelto 0.5 (fatto)
spiega come hai calcolato le statistiche (fatto)
deviazione standard dalla media(fatto)
grafici sulle x ci metti le entità e sulle y i numeri (fatto in progress aggiungi piu grafici)
verifica a mano delle entità e delle lexical references (fatto)
ricomputa statistiche vecchie con nuovi algoritmi(fatto)
ricomputa statistiche nuove senza children(forse?)

una volta fatto: scrivi a claudiu vediamo che esce fuori.

## Da fare per lunedi
vedi cos'è cogVLM e Cog Agent
fai evaluation sulle lexical references (fatt0)
Differenza tra i due 
Prendi 2-3 esempi buono di kosmos e prova con la preview
Prendi 2-3 che non è andato bene
vedere se ci sono oggetti non visibili (fatto)
quando è un children usa il padre 100 esempi e confronta con quell'altro.
Aggrega per entity type sulle lexical references 

## Da fare per giovedì
esempio in cui sbaglia con padre e non sbaglia senza (fatto)
Scrivi osservazione sul fatto che gli oggetti che possono contenere qualcosa non hanno oggetti all'interno(fatto)
Aggiungi osservazione sul prompt dei genitori(fatto)
metti i trattini (fatto)3
Scrivi un paragrafo summary introduttivo. "questo progetot utilizza. modelli multimodali per fare grounding delle entitò in un ambiente sono stati sperimentati kosmos/cogAgent. Kosmos non ha funzionato, gli sono stati dati ambienti di procThor e gli è stato chiesto il bounding box. Versione 1 con entity type, versione 2 con parents etc... "
Fai ultima tabella riassuntiva con tutti i risultati.
E fai una serie di tabelle che mostrano solo un'entità.

## Il mio dataset
il mio dataset è il dataset_20240206

## Per prossima volta
segnati quali e quante istanze fanno 0% in kosmos e quali e quante in cogVLM
aggiungo esempi in cui kosmos sbaglia

```bash
Where is the Cell phone on the Table?
```
