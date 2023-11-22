l'evaluation viene fatta grazie ad un algoritmo che confronta l'entità trovata da kosmos (con il suo relativo bounding box) con l'immagine labeled

$$
input=~IMAGE.png~,~LABELED\__~IMAGE.xml)
$$

$$
output =~True/False
$$
#### Labeled Image:
![[Pasted image 20231122165658.png]]
in questo file è contenuta, sotto forma di xml, il labeling di un'immagine, a cui è stato associato il bounding box per una televisione.

#### Image:
![[Pasted image 20231122165842.png]]
questa invece è l'immagine originale.

## L'algoritmo
L'algoritmo prende in input queste due cose e ci dice se kosmos è in grado di generare un bonding box (in questo caso per l'entità "television") accettabile. Per il codice completo (del main) si rimanda [[evaluation#codice del main completo|qui]]
### passo 1: estrazione delle entità
in questo passo viene preso il file xml e viene estratta l'entità a cui dobbiamo fare riferimento (le entità in caso siano più di una).

```python

# Step 2: Extract entities from the labeled image

labeled_entities = extract_entities_from_xml(labeled_image_path)

#print(labeled_entities)
```

```python
def extract_entities_from_xml(xml_file):
	
	entities = []
	
	tree = ET.parse(xml_file)
	
	root = tree.getroot()
	
	  
	
	object_elements = root.findall(".//object")
	
	for object_element in object_elements:
	
		entity_name = object_element.find("name").text
		
		xmin = float(object_element.find("bndbox/xmin").text)
		
		ymin = float(object_element.find("bndbox/ymin").text)
		
		xmax = float(object_element.find("bndbox/xmax").text)
		
		ymax = float(object_element.find("bndbox/ymax").text)
		
		  
	
	# Normalize coordinates
	
	xmin_normalized = xmin / image_width
	
	ymin_normalized = ymin / image_height
	
	xmax_normalized = xmax / image_width
	
	ymax_normalized = ymax / image_height
	
	  
	
	entities.append((entity_name, (xmin_normalized, ymin_normalized, xmax_normalized, ymax_normalized)))
	
	  

return entities
```
il risultato di questa fase è una lista di entità con il relativo bounding box, nel nostro caso:

```bash
[('television', (0.4, 0.275, 0.6266666666666667, 0.435))]
```

### passo 2: generare il prompt da passare a kosmos

Kosmos ha bisogno dell'immagine, ma anche di un prompt che gli dica "hey, kosmos, mi faresti il grounding della televisione?"
Ovviamente questo dipende da qual'è l'entità di cui dobbiamo fare il grounding: quindi lo generiamo a partire dall'output del passo precedente (che tra le altre cose ci aveva dato il nome dell'entità):

Questo lo step nel main:
```python
# Step 2: Extract entities from the labeled image

labeled_entities = extract_entities_from_xml(labeled_image_path)

print(labeled_entities)
```

questa la funzione "extract_entities_from_xml":
```python
def extract_entities_from_xml(xml_file):

	entities = []
	
	tree = ET.parse(xml_file)
	
	root = tree.getroot()
	
	  
	
	object_elements = root.findall(".//object")
	
	for object_element in object_elements:
		
		entity_name = object_element.find("name").text
		
		xmin = float(object_element.find("bndbox/xmin").text)
		
		ymin = float(object_element.find("bndbox/ymin").text)
		
		xmax = float(object_element.find("bndbox/xmax").text)
		
		ymax = float(object_element.find("bndbox/ymax").text)
	
	  
	
	# Normalize coordinates
	
	xmin_normalized = xmin / image_width
	
	ymin_normalized = ymin / image_height
	
	xmax_normalized = xmax / image_width
	
	ymax_normalized = ymax / image_height
	
	  
	
	entities.append((entity_name, (xmin_normalized, ymin_normalized, xmax_normalized, ymax_normalized)))

  

return entities
```

il prompt per dire a Kosmos: "trovami in quest'immagine il bounding box di television" è:
```python
"<grounding><phrase>television</phrase>"
```

### passo 3: Dire a kosmos di generare il bounding box dell'entità

A questo punto kosmos ha tutto quello che gli serve per generare il bounding box di "television".

questo il codice nel main:
```python
# Step 4: Process image with Kosmos and get entities

kosmos_entities = process_image_with_kosmos(prompts[0], image_path)

print(kosmos_entities)
```

questo il codice nella funzione "process_image_with_kosmos":
```python
def process_image_with_kosmos(prompt, image_path):

  
	
	image = Image.open(image_path)
	
	inputs = processor(text=prompt, images=image, return_tensors="pt")
	
	  
	  
	
	generated_ids = model.generate(
		
		pixel_values=inputs["pixel_values"],
		
		input_ids=inputs["input_ids"][:, :-1],
		
		attention_mask=inputs["attention_mask"][:, :-1],
		
		img_features=None,
		
		img_attn_mask=inputs["img_attn_mask"][:, :-1],
		
		use_cache=True,
		
		max_new_tokens=64,
	
	)
	
	generated_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
	
	  
	
	processed_text, kosmos_entities = processor.post_process_generation(generated_text)
	
	print(kosmos_entities)

  

return kosmos_entities
```

Da Kosmos possiamo farci avere molte cose in output, ma ciò che serve a noi è il bounding box dell'entità "television". Kosmos da questa, insieme da altre informazioni nell'output di "kosmos_entities"

```python
[('television', (0, 10), [(0.421875, 0.296875, 0.609375, 0.453125)]), ('sofa', (15, 19), [(0.015625, 0.390625, 0.515625, 0.953125)])]
```

Come si può vedere Kosmos (completely unsolicited) ci ha dato anche il bounding box di qualcos'altro (in questo caso sofa), questo non è un problema perchè l'importante è che ci dia almeno quello di "television", ma va preso in considerazione perchè lo fa spesso.

### passo4: Confrontiamo l'output di kosmos con il labeled data

ora dobbiamo capire se kosmos ha fatto qualcosa di accettabile oppure no?
#### cosa consideriamo accettabile?
Accettabile è il caso di considerare quando, kosmos fa correttamente il bounding box dell'entità che gli abbiamo chiesto quindi serve che
1. I Bounding box corrispondano con un'entità di quelle che ci ha dato kosmos
2. che l'entità abbia il nome giusto
In poche parole: non ci interessa che kosmos abbia individuato correttamente il bounding box se poi quel bounding box mi dice che è una "fatina dei denti" e non il televisore che gli avevo chiesto di trovare.

```python
# Step 5: Compare entities and calculate overlapping index

for labeled_entity in labeled_entities:
	for kosmos_entity in kosmos_entities:	
		entity_name, labeled_box = labeled_entity	
		entity_name_kosmos, _, kosmos_boxes = kosmos_entity		
		for kosmos_box in kosmos_boxes:		
			overlap_index = overlapping_index(labeled_box, kosmos_box)		
			if overlap_index > 0.5:			
				if(entity_name!=entity_name_kosmos): print(f"The entities match for {entity_name} and {entity_name_kosmos} from kosmos, but the names are different")				
				else:				
					print(f"The entities match for \"{entity_name}\" and \"{entity_name_kosmos}\" from kosmos with an overlapping index of: {overlap_index}")				
				break
```
in questo codice prendiamo ogni entità (di quelle assegnate sul file xml, quindi normalmente una sola), poi prendiamo ogni entità che ha restituito kosmos, e ne confrontiamo l'overlap index.

L'overlap index è una misura che calcola quanto si sovrappongono i due bounding box. Generalmente in letteratura, se i due bounding box si sovrappongono per più del 50% allora si considera una corrispondenza.

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

### Output dell'esempio
alla fine abbiamo avuto un match tra i due bounding box:
```bash
-----------------------------
The entities match for "television" and "television" from kosmos with an overlapping index of: 0.6529275050225192

----------------------------
```

### codice del main completo:
```python
def main():

# Step 1: Get user input for image and labeled image

#image_path = input("Enter the path to the image file (e.g., IMG_1.png): ")

image_path="/content/drive/MyDrive/prova_kosmos/img_3.PNG"

#labeled_image_path = input("Enter the path to the labeled image file (e.g., labeled_image.xml): ")

labeled_image_path="/content/drive/MyDrive/prova_kosmos/labeled_img_3.xml"

  

# Step 2: Extract entities from the labeled image

labeled_entities = extract_entities_from_xml(labeled_image_path)

#print(labeled_entities)

  

# Step 3: Generate prompts from extracted entities

prompts = generate_prompt(labeled_entities)

#print(prompts[0])

  

# Step 4: Process image with Kosmos and get entities

kosmos_entities = process_image_with_kosmos(prompts[0], image_path)

#print(kosmos_entities)

  

# Step 5: Compare entities and calculate overlapping index

for labeled_entity in labeled_entities:

for kosmos_entity in kosmos_entities:

entity_name, labeled_box = labeled_entity

entity_name_kosmos, _, kosmos_boxes = kosmos_entity

for kosmos_box in kosmos_boxes:

overlap_index = overlapping_index(labeled_box, kosmos_box)

if overlap_index > 0.5:

if(entity_name!=entity_name_kosmos): print(f"The entities match for {entity_name} and {entity_name_kosmos} from kosmos, but the names are different")

else:

print(f"The entities match for \"{entity_name}\" and \"{entity_name_kosmos}\" from kosmos with an overlapping index of: {overlap_index}")

break

  

if __name__ == "__main__":

main()
```

