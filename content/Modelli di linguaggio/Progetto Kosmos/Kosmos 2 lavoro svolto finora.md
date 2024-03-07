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
| Room Decor | 12 | 8.3333 | 0.1109 | 0.2402 | 0.8512 |  | 0.0435 | 0.0605 | 0.1330 |  | 0.0515 | 0.0515 | 0.0583 | 0.0545 |
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

A differenza dell' evaluation sul dataset precedente, in questo dataset sono stati considerati anche gli oggetti di dimensione minore: i children. Questi oggetti sono normalmente trovati sopra ad altri, sono di dimensione minore rispetto all'oggetto "parent", e dunque risultano più difficili da individuare e categorizzare.
I risultati infatti sono nettamente inferiori a quelli ottenuti precedentemente

| entity_type | Number of Occurrences | Percentage of Matches | Average Overlapping Index | Std Average Overlapping Index | Average Overlapping Index (Matched) | Std Average Overlapping Index (Matched) | Average Overlapping Index (Unmatched) | Std Average Overlapping Index (Unmatched) | Avg BBox Dimensions (Correct) | Std Avg BBox Dimensions (Correct) | Avg BBox Dimensions (Incorrect) | Std Avg BBox Dimensions (Incorrect) | Average BBox Dimensions (All) | Std Average BBox Dimensions (All) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Total | 10000 | 22.2700 | 0.1784 | 0.3227 | 0.7687 | 0.1176 | 0.0093 | 0.0398 | 0.0763 | 0.1126 | 0.0067 | 0.0248 | 0.0222 | 0.0643 |
| Painting | 751 | 40.3462 | 0.3207 | 0.3910 | 0.7896 | 0.0980 | 0.0037 | 0.0158 | 0.0672 | 0.0983 | 0.0141 | 0.0237 | 0.0355 | 0.0700 |
| Cell Phone | 628 | 2.0701 | 0.0169 | 0.0962 | 0.6653 | 0.0579 | 0.0032 | 0.0171 | 0.0063 | 0.0026 | 0.0010 | 0.0073 | 0.0011 | 0.0073 |
| Remote Control | 518 | 1.7375 | 0.0153 | 0.0882 | 0.6365 | 0.1019 | 0.0043 | 0.0281 | 0.0098 | 0.0075 | 0.0008 | 0.0022 | 0.0010 | 0.0027 |
| Book | 485 | 8.8660 | 0.0693 | 0.2021 | 0.7046 | 0.1038 | 0.0075 | 0.0249 | 0.0195 | 0.0119 | 0.0028 | 0.0257 | 0.0043 | 0.0252 |
| Chair | 443 | 25.0564 | 0.2052 | 0.3196 | 0.7385 | 0.1149 | 0.0269 | 0.0687 | 0.0444 | 0.0396 | 0.0113 | 0.0138 | 0.0196 | 0.0272 |
| Pen | 356 | 0.0000 | 0.0011 | 0.0063 |  |  | 0.0011 | 0.0063 |  |  | 0.0004 | 0.0015 | 0.0004 | 0.0015 |
| Dining Table | 317 | 58.6751 | 0.4669 | 0.3810 | 0.7749 | 0.1120 | 0.0296 | 0.0809 | 0.0732 | 0.0639 | 0.0289 | 0.0573 | 0.0549 | 0.0650 |
| Box | 214 | 10.2804 | 0.0849 | 0.2172 | 0.7023 | 0.1279 | 0.0142 | 0.0430 | 0.0164 | 0.0121 | 0.0051 | 0.0076 | 0.0062 | 0.0088 |
| Key Chain | 207 | 0.4831 | 0.0043 | 0.0426 | 0.6105 |  | 0.0013 | 0.0048 | 0.0055 |  | 0.0003 | 0.0007 | 0.0004 | 0.0008 |
| Counter Top | 204 | 37.7451 | 0.3100 | 0.3914 | 0.8014 | 0.1193 | 0.0121 | 0.0347 | 0.1864 | 0.1550 | 0.0679 | 0.0911 | 0.1126 | 0.1322 |
| Bowl | 194 | 5.6701 | 0.0428 | 0.1514 | 0.6360 | 0.1189 | 0.0071 | 0.0312 | 0.0098 | 0.0045 | 0.0029 | 0.0132 | 0.0033 | 0.0130 |
| Bottle | 192 | 6.7708 | 0.0475 | 0.1654 | 0.6471 | 0.1259 | 0.0040 | 0.0118 | 0.0105 | 0.0098 | 0.0017 | 0.0033 | 0.0023 | 0.0046 |
| House Plant | 192 | 46.3542 | 0.3412 | 0.3610 | 0.7155 | 0.1179 | 0.0178 | 0.0647 | 0.0320 | 0.0339 | 0.0045 | 0.0080 | 0.0172 | 0.0274 |
| Television | 185 | 63.7838 | 0.4931 | 0.3779 | 0.7677 | 0.1180 | 0.0095 | 0.0370 | 0.1015 | 0.1404 | 0.0191 | 0.0382 | 0.0716 | 0.1210 |
| Statue | 169 | 20.7101 | 0.1470 | 0.2705 | 0.6560 | 0.1191 | 0.0140 | 0.0530 | 0.0165 | 0.0137 | 0.0032 | 0.0060 | 0.0059 | 0.0098 |
| Plate | 165 | 4.2424 | 0.0334 | 0.1444 | 0.7049 | 0.1293 | 0.0036 | 0.0124 | 0.0153 | 0.0141 | 0.0012 | 0.0025 | 0.0018 | 0.0046 |
| Sofa | 161 | 65.8385 | 0.5580 | 0.3861 | 0.8274 | 0.0893 | 0.0389 | 0.0965 | 0.1050 | 0.1011 | 0.0236 | 0.0404 | 0.0772 | 0.0936 |
| Laptop | 161 | 16.7702 | 0.1320 | 0.2731 | 0.7259 | 0.1242 | 0.0123 | 0.0262 | 0.0271 | 0.0228 | 0.0047 | 0.0140 | 0.0084 | 0.0178 |
| Fridge | 157 | 66.2420 | 0.5615 | 0.4080 | 0.8449 | 0.1084 | 0.0053 | 0.0136 | 0.2056 | 0.2487 | 0.0652 | 0.1070 | 0.1582 | 0.2216 |
| Knife | 150 | 2.6667 | 0.0227 | 0.1143 | 0.7009 | 0.1037 | 0.0042 | 0.0132 | 0.0139 | 0.0124 | 0.0015 | 0.0047 | 0.0018 | 0.0054 |
| Bed | 141 | 52.4823 | 0.4395 | 0.4085 | 0.8191 | 0.0929 | 0.0202 | 0.0655 | 0.1410 | 0.1487 | 0.0271 | 0.0425 | 0.0869 | 0.1251 |
| Dresser | 141 | 61.7021 | 0.5399 | 0.4102 | 0.8548 | 0.0847 | 0.0326 | 0.0882 | 0.1222 | 0.0957 | 0.0198 | 0.0259 | 0.0830 | 0.0916 |
| Wine Bottle | 138 | 13.7681 | 0.0986 | 0.2299 | 0.6525 | 0.0938 | 0.0102 | 0.0521 | 0.0093 | 0.0048 | 0.0054 | 0.0299 | 0.0059 | 0.0279 |
| Garbage Can | 135 | 66.6667 | 0.5233 | 0.3563 | 0.7666 | 0.0834 | 0.0367 | 0.0958 | 0.0274 | 0.0213 | 0.0102 | 0.0171 | 0.0217 | 0.0216 |
| Fork | 129 | 0.0000 | 0.0019 | 0.0085 |  |  | 0.0019 | 0.0085 |  |  | 0.0007 | 0.0025 | 0.0007 | 0.0025 |
| Spoon | 128 | 0.0000 | 0.0014 | 0.0057 |  |  | 0.0014 | 0.0057 |  |  | 0.0004 | 0.0010 | 0.0004 | 0.0010 |
| Pillow | 125 | 15.2000 | 0.1168 | 0.2495 | 0.6873 | 0.1351 | 0.0146 | 0.0307 | 0.0200 | 0.0163 | 0.0028 | 0.0039 | 0.0054 | 0.0095 |
| Mug | 119 | 4.2017 | 0.0310 | 0.1258 | 0.6205 | 0.0937 | 0.0052 | 0.0128 | 0.0116 | 0.0075 | 0.0015 | 0.0040 | 0.0019 | 0.0046 |
| Arm Chair | 114 | 54.3860 | 0.4404 | 0.3995 | 0.7965 | 0.1025 | 0.0159 | 0.0566 | 0.0597 | 0.0530 | 0.0206 | 0.0292 | 0.0419 | 0.0478 |
| Bread | 114 | 7.8947 | 0.0632 | 0.1907 | 0.6982 | 0.1202 | 0.0088 | 0.0226 | 0.0155 | 0.0115 | 0.0018 | 0.0037 | 0.0029 | 0.0059 |
| Spray Bottle | 113 | 15.0442 | 0.1057 | 0.2422 | 0.6653 | 0.1024 | 0.0066 | 0.0377 | 0.0110 | 0.0076 | 0.0012 | 0.0022 | 0.0027 | 0.0050 |
| Vase | 110 | 8.1818 | 0.0639 | 0.1837 | 0.6518 | 0.0921 | 0.0115 | 0.0472 | 0.0206 | 0.0274 | 0.0015 | 0.0026 | 0.0031 | 0.0094 |
| Soap Bottle | 106 | 6.6038 | 0.0466 | 0.1577 | 0.6285 | 0.1011 | 0.0054 | 0.0111 | 0.0101 | 0.0078 | 0.0025 | 0.0049 | 0.0030 | 0.0055 |
| Spatula | 94 | 0.0000 | 0.0058 | 0.0244 |  |  | 0.0058 | 0.0244 |  |  | 0.0020 | 0.0084 | 0.0020 | 0.0084 |
| Pencil | 91 | 1.0989 | 0.0070 | 0.0599 | 0.5701 |  | 0.0007 | 0.0053 | 0.0028 |  | 0.0003 | 0.0013 | 0.0003 | 0.0013 |
| Toaster | 89 | 12.3596 | 0.0912 | 0.2247 | 0.6816 | 0.0691 | 0.0080 | 0.0171 | 0.0181 | 0.0165 | 0.0042 | 0.0062 | 0.0060 | 0.0093 |
| Shelving Unit | 88 | 61.3636 | 0.5259 | 0.3961 | 0.8304 | 0.0856 | 0.0421 | 0.0947 | 0.1446 | 0.1667 | 0.0368 | 0.0604 | 0.1030 | 0.1453 |
| Toilet | 86 | 66.2791 | 0.5122 | 0.3496 | 0.7458 | 0.1158 | 0.0529 | 0.1209 | 0.0835 | 0.0894 | 0.0132 | 0.0112 | 0.0598 | 0.0801 |
| Kettle | 84 | 5.9524 | 0.0475 | 0.1542 | 0.6470 | 0.0582 | 0.0096 | 0.0252 | 0.0128 | 0.0061 | 0.0039 | 0.0122 | 0.0044 | 0.0121 |
| TV Stand | 84 | 35.7143 | 0.2836 | 0.3669 | 0.7525 | 0.1438 | 0.0230 | 0.0765 | 0.1123 | 0.0929 | 0.0213 | 0.0265 | 0.0538 | 0.0734 |
| Butter Knife | 83 | 0.0000 | 0.0045 | 0.0218 |  |  | 0.0045 | 0.0218 |  |  | 0.0002 | 0.0005 | 0.0002 | 0.0005 |
| Newspaper | 76 | 5.2632 | 0.0392 | 0.1538 | 0.6769 | 0.1220 | 0.0037 | 0.0131 | 0.0225 | 0.0150 | 0.0013 | 0.0026 | 0.0024 | 0.0062 |
| Apple | 75 | 2.6667 | 0.0223 | 0.1101 | 0.6565 | 0.0876 | 0.0050 | 0.0296 | 0.0037 | 0.0003 | 0.0019 | 0.0081 | 0.0019 | 0.0080 |
| Cup | 73 | 4.1096 | 0.0306 | 0.1270 | 0.6311 | 0.0491 | 0.0049 | 0.0201 | 0.0072 | 0.0045 | 0.0015 | 0.0032 | 0.0017 | 0.0034 |
| Washing Machine | 73 | 69.8630 | 0.5904 | 0.3730 | 0.8256 | 0.0920 | 0.0452 | 0.1049 | 0.0982 | 0.0986 | 0.0260 | 0.0305 | 0.0764 | 0.0902 |
| Side Table | 72 | 40.2778 | 0.3204 | 0.3884 | 0.7835 | 0.1004 | 0.0081 | 0.0189 | 0.0557 | 0.0359 | 0.0172 | 0.0274 | 0.0327 | 0.0362 |
| Candle | 70 | 1.4286 | 0.0216 | 0.1158 | 0.8907 |  | 0.0090 | 0.0484 | 0.0061 |  | 0.0007 | 0.0013 | 0.0008 | 0.0014 |
| Sink | 64 | 71.8750 | 0.5634 | 0.3551 | 0.7741 | 0.1143 | 0.0251 | 0.0762 | 0.0772 | 0.0700 | 0.0175 | 0.0281 | 0.0604 | 0.0667 |
| Floor Lamp | 64 | 59.3750 | 0.4851 | 0.3950 | 0.7990 | 0.1139 | 0.0264 | 0.0729 | 0.1211 | 0.1543 | 0.0273 | 0.0349 | 0.0830 | 0.1289 |
| Credit Card | 60 | 0.0000 | 0.0010 | 0.0036 |  |  | 0.0010 | 0.0036 |  |  | 0.0003 | 0.0007 | 0.0003 | 0.0007 |
| Pepper Shaker | 58 | 0.0000 | 0.0020 | 0.0050 |  |  | 0.0020 | 0.0050 |  |  | 0.0019 | 0.0078 | 0.0019 | 0.0078 |
| Potato | 57 | 5.2632 | 0.0349 | 0.1474 | 0.6414 | 0.1591 | 0.0012 | 0.0039 | 0.0039 | 0.0017 | 0.0020 | 0.0084 | 0.0021 | 0.0082 |
| Salt Shaker | 56 | 0.0000 | 0.0010 | 0.0038 |  |  | 0.0010 | 0.0038 |  |  | 0.0005 | 0.0006 | 0.0005 | 0.0006 |
| Tomato | 56 | 8.9286 | 0.0581 | 0.1844 | 0.6345 | 0.1074 | 0.0016 | 0.0034 | 0.0044 | 0.0029 | 0.0005 | 0.0008 | 0.0008 | 0.0016 |
| Stool | 55 | 56.3636 | 0.4302 | 0.3870 | 0.7595 | 0.1131 | 0.0049 | 0.0125 | 0.0257 | 0.0223 | 0.0081 | 0.0195 | 0.0181 | 0.0227 |
| Pan | 54 | 7.4074 | 0.0531 | 0.1707 | 0.6368 | 0.1211 | 0.0064 | 0.0241 | 0.0166 | 0.0109 | 0.0039 | 0.0085 | 0.0048 | 0.0092 |
| Garbage Bag | 54 | 68.5185 | 0.5245 | 0.3544 | 0.7509 | 0.1065 | 0.0318 | 0.1186 | 0.0218 | 0.0159 | 0.0055 | 0.0093 | 0.0167 | 0.0160 |
| Faucet | 54 | 11.1111 | 0.1033 | 0.2262 | 0.7218 | 0.0936 | 0.0260 | 0.0425 | 0.0227 | 0.0107 | 0.0107 | 0.0183 | 0.0120 | 0.0179 |
| Dish Sponge | 52 | 0.0000 | 0.0045 | 0.0227 |  |  | 0.0045 | 0.0227 |  |  | 0.0006 | 0.0018 | 0.0006 | 0.0018 |
| Lettuce | 51 | 11.7647 | 0.0811 | 0.2263 | 0.6854 | 0.1243 | 0.0006 | 0.0019 | 0.0104 | 0.0096 | 0.0007 | 0.0007 | 0.0019 | 0.0044 |
| Microwave | 46 | 13.0435 | 0.1258 | 0.2589 | 0.7665 | 0.0967 | 0.0297 | 0.0591 | 0.0431 | 0.0640 | 0.0089 | 0.0111 | 0.0133 | 0.0264 |
| Toilet Paper | 46 | 4.3478 | 0.0321 | 0.1363 | 0.6579 | 0.1199 | 0.0037 | 0.0080 | 0.0064 | 0.0002 | 0.0011 | 0.0017 | 0.0013 | 0.0020 |
| Watch | 43 | 0.0000 | 0.0009 | 0.0046 |  |  | 0.0009 | 0.0046 |  |  | 0.0003 | 0.0005 | 0.0003 | 0.0005 |
| Teddy Bear | 43 | 48.8372 | 0.3605 | 0.3476 | 0.6945 | 0.1144 | 0.0417 | 0.1055 | 0.0152 | 0.0121 | 0.0027 | 0.0025 | 0.0088 | 0.0106 |
| Paper Towel Roll | 38 | 7.8947 | 0.0512 | 0.1637 | 0.5987 | 0.0727 | 0.0043 | 0.0117 | 0.0072 | 0.0026 | 0.0021 | 0.0034 | 0.0025 | 0.0036 |
| Desk Lamp | 37 | 8.1081 | 0.0821 | 0.2067 | 0.7218 | 0.0844 | 0.0257 | 0.0756 | 0.0269 | 0.0148 | 0.0037 | 0.0048 | 0.0056 | 0.0086 |
| Plunger | 37 | 24.3243 | 0.1827 | 0.3037 | 0.6990 | 0.0724 | 0.0168 | 0.0633 | 0.0121 | 0.0040 | 0.0042 | 0.0038 | 0.0061 | 0.0051 |
| Basket Ball | 35 | 31.4286 | 0.2573 | 0.2919 | 0.6320 | 0.0851 | 0.0856 | 0.1576 | 0.0083 | 0.0041 | 0.0018 | 0.0020 | 0.0038 | 0.0041 |
| Pot | 35 | 8.5714 | 0.0637 | 0.2038 | 0.7074 | 0.1598 | 0.0033 | 0.0082 | 0.0248 | 0.0253 | 0.0031 | 0.0057 | 0.0049 | 0.0103 |
| Dog Bed | 34 | 44.1176 | 0.3621 | 0.4164 | 0.8205 | 0.0779 | 0.0003 | 0.0013 | 0.0434 | 0.0260 | 0.0146 | 0.0169 | 0.0273 | 0.0255 |
| Ladle | 34 | 2.9412 | 0.0248 | 0.1231 | 0.7196 |  | 0.0038 | 0.0091 | 0.0095 |  | 0.0011 | 0.0036 | 0.0013 | 0.0038 |
| Baseball Bat | 33 | 15.1515 | 0.1196 | 0.2724 | 0.7497 | 0.0542 | 0.0071 | 0.0292 | 0.0229 | 0.0150 | 0.0036 | 0.0047 | 0.0065 | 0.0098 |
| Cart | 32 | 46.8750 | 0.3785 | 0.4135 | 0.8061 | 0.0986 | 0.0012 | 0.0035 | 0.0781 | 0.0680 | 0.0362 | 0.0470 | 0.0559 | 0.0607 |
| Tissue Box | 26 | 3.8462 | 0.0357 | 0.1451 | 0.7297 |  | 0.0079 | 0.0327 | 0.0087 |  | 0.0024 | 0.0041 | 0.0026 | 0.0042 |
| Egg | 23 | 0.0000 | 0.0015 | 0.0045 |  |  | 0.0015 | 0.0045 |  |  | 0.0005 | 0.0016 | 0.0005 | 0.0016 |
| Alarm Clock | 22 | 18.1818 | 0.1260 | 0.2649 | 0.6687 | 0.1029 | 0.0055 | 0.0106 | 0.0103 | 0.0047 | 0.0034 | 0.0044 | 0.0046 | 0.0051 |
| Desk | 17 | 47.0588 | 0.4079 | 0.4306 | 0.8446 | 0.0901 | 0.0197 | 0.0590 | 0.1419 | 0.0992 | 0.0392 | 0.0583 | 0.0876 | 0.0938 |
| Coffee Machine | 14 | 35.7143 | 0.2354 | 0.3056 | 0.6260 | 0.0638 | 0.0183 | 0.0370 | 0.0185 | 0.0204 | 0.0132 | 0.0172 | 0.0151 | 0.0178 |
| Soap Bar | 13 | 0.0000 | 0.0010 | 0.0016 |  |  | 0.0010 | 0.0016 |  |  | 0.0005 | 0.0010 | 0.0005 | 0.0010 |
| Tennis Racket | 11 | 9.0909 | 0.0718 | 0.1704 | 0.5645 |  | 0.0226 | 0.0508 | 0.0099 |  | 0.0047 | 0.0071 | 0.0052 | 0.0070 |
| Safe | 11 | 36.3636 | 0.2719 | 0.3697 | 0.7300 | 0.1219 | 0.0101 | 0.0215 | 0.0163 | 0.0124 | 0.0055 | 0.0037 | 0.0094 | 0.0092 |
| Cloth | 10 | 0.0000 | 0.0000 | 0.0000 |  |  | 0.0000 | 0.0000 |  |  | 0.0026 | 0.0043 | 0.0026 | 0.0043 |
| Laundry Hamper | 9 | 44.4444 | 0.3525 | 0.4211 | 0.7875 | 0.1358 | 0.0044 | 0.0089 | 0.0599 | 0.0526 | 0.0154 | 0.0070 | 0.0352 | 0.0401 |
| Vacuum Cleaner | 7 | 57.1429 | 0.4380 | 0.4120 | 0.7664 | 0.0610 | 0.0000 | 0.0000 | 0.0301 | 0.0277 | 0.0183 | 0.0133 | 0.0250 | 0.0220 |
| Boots | 3 | 0.0000 | 0.0068 | 0.0107 |  |  | 0.0068 | 0.0107 |  |  | 0.0011 | 0.0007 | 0.0011 | 0.0007 |
| Desktop | 2 | 0.0000 | 0.0408 | 0.0577 |  |  | 0.0408 | 0.0577 |  |  | 0.0316 | 0.0325 | 0.0316 | 0.0325 |
| Room Decor | 2 | 0.0000 | 0.0123 | 0.0174 |  |  | 0.0123 | 0.0174 |  |  | 0.0130 | 0.0143 | 0.0130 | 0.0143 |
| Table Top Decor | 1 | 0.0000 | 0.0558 |  |  |  | 0.0558 |  |  |  | 0.0027 |  | 0.0027 |  |
| Ottoman | 1 | 100.0000 | 0.9066 |  | 0.9066 |  |  |  | 0.1021 |  |  |  | 0.1021 |  |


È chiaro che la dimensione dei bounding box ha nettamente influito sulle prestazioni del modello.

Prima la media dei bounding box per le entità non correttamente stimate era: 0,056
Adesso invece è: 0.0222

Quindi più della metà.
Curiosamente di un valore molto simile è diminuita la precisione:

| entity_type | Number of Occurrences | Percentage of Matches |
| ---- | ---- | ---- |
| Total | 10000 | 22.2700 |
Rispetto a quella precedente:

| entity_type | Number of Occurrences | Percentage of Matches |
| ---- | ---- | ---- |
| Total | 5014 | 51.9744714798564 |
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

Questo grafo secondo me evidenzia bene il limite di questo modello nel trovare un match quando l'enità è piccola. Ed evidenzia anche una certa predisposizione di questo modello a non superare una precisione del 60/70%, con la maggior parte dei punti che superano una certa dimensione (0.05 che ricordiamo essere la dimensione media dell'altro dataset) che adagiano sul 50% di precisione.

![[Pasted image 20240307124837.png]]

## Conclusioni
A mio parere questo modello, in zero shot, ha una precisione che si aggira intorno al 50-60% in condizioni ottimali (bounding box di una dimensione considerevole) e che rapidamente approccia valori di precisione bassi quando le dimensioni dei bounding box diminuiscono.
## DA FARE
AGGIUNGERE I CHILDREN COME DA FILE (fatto)
aggiungi lexical reference nel grounding per ogni entità. (obiezione)
Fai file output.csv + shuffle head 10k e poi te lo salvi (fatto: shuffled_output_data.csv)
spiega perchè hai scelto 0.5 (fatto)
spiega come hai calcolato le statistiche (fatto)
deviazione standard dalla media(fatto)
grafici sulle x ci metti le entità e sulle y i numeri (fatto in progress aggiungi piu grafici)
verifica a mano delle entità e delle lexical references (fatto)
ricomputa statistiche vecchie con nuovi algoritmi()
ricomputa statistiche nuove senza children()

una volta fatto: scrivi a claudiu vediamo che esce fuori.

