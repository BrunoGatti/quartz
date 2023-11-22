l'evaluation viene fatta grazie ad un algoritmo che confronta l'entità trovata da kosmos (con il suo relativo bounding box) con l'immagine labeled

$$
input=~IMAGE.png~,~LABELED\__~IMAGE.xml)
$$

$$
output =~True/False
$$
#### Labeled Image:
![[Pasted image 20231122165658.png]]
in questo file è contenuta, sottoforma di xml, il labeling di un'immagine, a cui è stato associato il bounding box per una televisione.

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

```python
# Step 2: Extract entities from the labeled image

labeled_entities = extract_entities_from_xml(labeled_image_path)

print(labeled_entities)
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

