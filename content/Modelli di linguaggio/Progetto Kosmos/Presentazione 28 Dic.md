---
publish: true
---

## Passo 1: Data Gathering
Il processo di Data Gathering è stato fatto dai ragazzi di triennale. Hanno estratto una serie di ambienti digitali usando procThor e mi hanno fornito una serie di immagini nonchè informazioni sugli ogetti e le loro posizioni all'interno delle immagini.
Ci sono più oggetti all'interno di ogni immagine, e più immagini (corrispondenti a diverse posizioni dell'agente) per ogni ambiente.
![[Pasted image 20231122165842.png]]

## Passo 2: Data preprocessing
I dati, per come sono arrivati, devono essere raccolti in un dataset che sia facilmente utilizzabile dal modello.
Intendiamo fare una valutazione di Kosmos usando un oggetto per ogni immagine e verificare che il modello faccia il grounding dell'entità correttamente.
Vogliamo quindi fornire al modello un immagine, ed interrogare il modello sulla posizione dell'entità all'interno dell'immagine, verificare poi la bontà del modello.
Per fare ciò, dobbiamo seprare ogni entità in ogni immagine di ogni ambiente.
Ho scelto, sotto consiglio di Claudiu, di rappresentare questo dataset come csv.
Questo è un estratto di come si presenta:

![[Pasted image 20231220210811.png]]

Per ottenere questo file ho utilizzato uno script python che estrae queste informazioni dal dataset e le inserisce in un dataframe, che poi è stato esportato sotto forma di csv:

```python
import os
import json
import pandas as pd
from PIL import Image
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
def process_json_file(directory, file):
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
            image_path_bbox = os.path.join(bounding_box_dir.replace("bounding_box", "normal"),
                                           image_name.replace("bounding_box_", ""))
            image_path_normal = os.path.join(bounding_box_dir.replace("bounding_box", "normal"),
                                             image_name.replace("bounding_box_", ""))
            
            rows.append({
                "environment": environment,
                "entity_type": split_entity_type(entity_type),
                "lexical_references": lexical_references,
                "image_bbox": os.path.join(directory, bounding_box_path),
                "image_normal": os.path.join(directory, image_path_normal),
                "bounding_box": (x1, y1, x2, y2)
            })
    return rows

# Main function to process all JSON files in the specified directories
def process_directories(directories):
    data_rows = []
    
    for directory in directories:
        json_files = [f for f in os.listdir(directory) if f.endswith(".json")]
        
        for json_file in json_files:
            data_rows.extend(process_json_file(directory, json_file))
    
    return data_rows

# Define the list of directories
directories = [
...
]

# Process directories and create DataFrame
data = process_directories(directories)
df = pd.DataFrame(data)

# Export DataFrame to CSV
csv_filename = "output_data.csv"
df.to_csv(csv_filename, index=False)

print(f"DataFrame exported to {csv_filename}")


```

## Passo 3: Model evaluation
A questo punto dobbiamo valutare il modello su questi dati. Per adesso la valutazione è stata fatta in zero shot su uno split dei dati del 20%.
Abbiamo diviso il dataset in tre parti: train test ed eval. In questo caso abbiamo usato solamente "eval". Per fare la valutazione zero shot del modello dobbiamo fornirgli, un prompt, ottenuto sulla base del nome dell'entità, e l'immagine che contiene quell'entità.

Per fare ciò ho utilizzato uno script python che opera seguendo questa struttura:
Per ogni riga del CSV
1. ottieni il prompt a partire dalla lexical reference
2. recupera l'immagine "raw" dal dataset
3. chiedi a Kosmos di eseguire il grounding sull'immagine con il prompt.
![[Pasted image 20231220212214.png]]
![[Pasted image 20231220212039.png]]
4. estrai dall'output di kosmos il bounding box dell'entità (kosmos generalmente non restituisce solo l'entità che ci interessa):![[Pasted image 20231220212308.png]]
5. Confronta il bounding box di kosmos con quello fornito dal dataset

Per ora i risultati ottenuti "zero-shot" sono di una precisione del 54% circa.

## Passo 4: interpretazione dei risultati.
Per quanto possano essere deludenti (sotto alcuni aspetti), questi risultati sono incoraggianti.
Da una prima esplorazione dei risultati si può vedere come molti errori siano di natura di comprensione:
![[Pasted image 20231228180716.png]]
Come si può vedere in questa immagine il modello pensa a "TV Stand" come al supporto della televisione, mentre nel dataset "TV stand" indica il mobile su cui è posto il televisore. Questo è stato segnato come errore perchè i bounding boxes non si sovrappongono al 50%+

## Passi successivi:
Per i passi successivi abbiamo in programma un fine tuning del modello su questo task, inoltre abbiamo intenzione di testare il modello su "few shots". Fornendo all'interno del prompt i bounding box di altre immagini

Inoltre questo processo verrà ripetuto per un ulteriore task: quello di "entity labeling", che è sostanzialmente il task inverso a questo: dato un bounding box, ottenere il nome dell'entità evidenziata.