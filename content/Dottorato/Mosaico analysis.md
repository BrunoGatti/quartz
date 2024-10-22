---
publish: "False"
---


## Compatibilità tra SRL e WSD
SRL è gestito con VERBATLAS ha frame tipo questo

![[Pasted image 20240924113028.png]]

EXIST_LIVE è il senso di verbatlas che è un insieme di synset wordnet

![[Pasted image 20240924113402.png]]

mentre per WSD abbiamo direttamente il synset di wordnet

![[Pasted image 20240924114119.png]]

Chiaramente il senso di wordnet non è limitato al solo verbo che stiamo cercando, in questo caso the verb "be" ma anche ad altri sostantivi, bisognerebbe trovare un modo per capire direttamente a quale token ci stiamo riferendo in wsd a partire dal predicato di SRL. 
Probabilmente questo può essere fatto sfruttando "token span" di WSD e arguments in SRL.
![[Pasted image 20240924114341.png]]

![[Pasted image 20240924114448.png]]

Un possibile flusso potrebbe essere 

```python
per ogni frame a partire da Verbatlas SRL prendi il "predicate"
preso il predicate estrai il token span usando "Arguments" e tra tutti trova "V"
Una volta estratto il token span trova il label a partire dal token span in "WSD"
il label corrisponde ad una "sense key" di wordnet che deve essere trasformato in un Synset.
```

## Algoritmo di estrazione
L'algoritmo esamina in sequenza tutte le pagine presenti nel database di mosaico usando una funzione chiamata "extract_pages", la funzione una volta estratta la pagina chiama una funzione di callback passata come argomento che processa la pagina estratta

```python
def extract_pages(db, callback=None, debug=False):
    """
    Extracts pages from the MongoDB collection and processes them using the provided callback function.


    Args:
    db (MongoClient): A connected MongoDB client.
    callback (function): A function that processes each page. If None, only the title is printed (in debug mode).
    debug (bool): If True, enables debug mode, printing titles and exporting full pages to JSON files.
    """
    # Access the pages collection
    collection = db['pages']

    # Iterate over each page in the collection
    for page in collection.find():
        title = page.get('title', 'Untitled Page')
        print(title)
        page_id = page.get('_id')  # Get the ObjectId of the page

        if debug:
            # Print the title
            print(f"Processing page: {title}")

            # Replace any invalid characters in the file name
            safe_title = "".join([c if c.isalnum() or c in (' ', '_', '-') else "_" for c in title])
            file_name = f"{safe_title}.json"

            # Construct the mongoexport command to export the document by its ObjectId
            try:
                command = [
                    'mongoexport',
                    '--uri', 'mongodb://admin:Cacioman21@localhost:27017/mosaico',
                    '--collection', 'pages',
                    '--query', f'{{"_id": ObjectId("{page_id}")}}',  # Use the page's ObjectId
                    '--out', file_name
                ]

                # Run the command using subprocess
                subprocess.run(command, check=True)
                print(f"Page exported to {file_name}")
            except Exception as e:
                print(f"Error exporting page {title}: {e}")

        # If a callback is provided, process the page
        if callback:
            try:
                callback(page)
            except Exception as e:
                print(f"Error processing page {title}: {e}")

```

La funzione di callback che viene applicata è "extract_srl_and_wsd_annotations". Questa funzione ha il compito di estrarre dal documento le informazioni riguardanti srl e wsd.

```python
def extract_srl_and_wsd_annotations(doc, debug=False):
    """
    Extracts SRL (Semantic Role Labeling) and WSD (Word Sense Disambiguation) annotations from the document.
    Only extracts the "verbatlas" data from the SRL annotations. If debug is True, prints the first few lines
    of both SRL (verbatlas) and WSD annotations.

    Args:
    doc (dict): The document extracted from MongoDB.
    debug (bool): If True, prints the first few lines of the SRL (verbatlas) and WSD annotations.

    Returns:
    dict: A dictionary containing SRL (verbatlas) and WSD annotations.
    """
    # Initialize containers for SRL (verbatlas) and WSD annotations
    srl_verbatlas = None
    wsd_annotations = None

    # Check if 'materialized_annotations' is present in the document
    if 'materialized_annotations' in doc:
        for annotation in doc['materialized_annotations']:
            # Extract SRL annotation (only "verbatlas")
            if annotation['name'] == 'srl':
                srl_annotations = annotation['annotation']

                # Extract only the "verbatlas" data from SRL
                srl_verbatlas = srl_annotations.get('inventory2document_spans', {}).get('verbatlas', [])

                if debug:
                    print("---- SRL (Verbatlas) Annotation Preview ----")
                    print(str(srl_verbatlas)[:500])  # Print first 500 characters as a preview
                    print("---- End of SRL (Verbatlas) Preview ----")

            # Extract WSD annotation
            elif annotation['name'] == 'wsd':
                wsd_annotations = annotation['annotation']

                if debug:
                    print("---- WSD Annotation Preview ----")
                    print(str(wsd_annotations)[:500])  # Print first 500 characters as a preview
                    print("---- End of WSD Preview ----")

    # Return a dictionary with both SRL (verbatlas) and WSD annotations
    return {
        'srl_verbatlas': srl_verbatlas,
        'wsd': wsd_annotations
    }
```

Queste annotazioni sono ancora "crude" e devono essere processate. Per questo viene chiamata la funzione "process_annotations" che ha il compito di estrarre le annotazioni e creare per ogni predicato una struttura che contenga il suo frame di VerbAtlas, il synset di wordnet/babelnet e lo span dei token.

```python
def process_annotations(srl_verbatlas, wsd_annotations, debug=False):
    """
    Processes SRL VerbAtlas annotations and WSD annotations in parallel.
    For each predicate in the SRL data, it extracts the corresponding synset from the WSD data.

    Args:
    srl_verbatlas (list): A list of lists representing VerbAtlas annotations, where each inner list is a phrase.
    wsd_annotations (dict): A dictionary containing WSD annotations (document_spans).
    debug (bool): If True, prints debug information. Default is False.
    """
    results = []

    # Iterate over the phrases in SRL (each phrase is a list of predicates and arguments)
    for phrase_idx, phrase_annotations in enumerate(srl_verbatlas):
        # Process each predicate in the phrase
        for annotation in phrase_annotations:
            if isinstance(annotation, dict):
                # Extract predicate label and token span for 'V'
                predicate_label = annotation['predicate']['label']
                predicate_token_span = None

                # Find the argument with role 'V' (verb)
                for argument in annotation.get('arguments', []):
                    if argument['role'] == 'V':
                        predicate_token_span = (argument['start'], argument['end'])
                        break  # Found the 'V' role, no need to continue

                if predicate_token_span:
                    # Now find the corresponding WSD synset using the token span and phrase index
                    synset = find_synset_for_token_span(predicate_token_span, wsd_annotations, phrase_idx, debug=debug)

                    # Combine SRL predicate data with WSD synset
                    results.append({
                        'predicate_label': predicate_label,
                        'predicate_token_span': predicate_token_span,
                        'synset': synset
                    })

    return results
```
## Analisi dei sensi e dei predicati
Una volta fatto questo ho ottenuto un file di questo tipo:

```python
Predicate: COPULA, Token Span: (13, 14), Synset: None
Predicate: LIGHT-VERB, Token Span: (18, 19), Synset: make%2:41:00::
Predicate: AUXILIARY, Token Span: (7, 8), Synset: None
Predicate: NAME, Token Span: (8, 9), Synset: name%2:32:03::
Predicate: SEARCH, Token Span: (2, 3), Synset: research%2:32:00::
Predicate: COPULA, Token Span: (10, 11), Synset: None
Predicate: USE, Token Span: (18, 19), Synset: use%2:34:01::
Predicate: HELP_HEAL_CARE_CURE, Token Span: (21, 22), Synset: treat%2:29:00::
Predicate: EXIST-WITH-FEATURE, Token Span: (2, 3), Synset: qualify%2:42:00::
Predicate: RECEIVE, Token Span: (15, 16), Synset: receive%2:40:00::
```

Il synset ottenuto è in realtà una "sense key" di wordnet
Il problema è che questo non è sempre vero, spesso infatti è un babelnet sense:

```python
Predicate: EXIST_LIVE, Token Span: (16, 17), Synset: None
Predicate: REPRESENT, Token Span: (17, 18), Synset: bn:00083725v
Predicate: FIND, Token Span: (21, 22), Synset: bn:00088204v
Predicate: EXIST-WITH-FEATURE, Token Span: (24, 25), Synset: bn:00089240v
Predicate: PAY, Token Span: (3, 4), Synset: bn:00092789v
Predicate: SPEAK, Token Span: (7, 8), Synset: bn:00090943v
Predicate: SHOW, Token Span: (8, 9), Synset: bn:00092636v
Predicate: TRY, Token Span: (12, 13), Synset: bn:00082844v
```


## Querying VerbAtlas

In teoria è possibile usare le API di verbatlas usando sia il sensekey di wordnet sia l'ID di babelnet. Il che renderebbe questo processo facile

![[Pasted image 20240924182640.png]]

Il problema è che non funziona

![[Pasted image 20240924182819.png]]

Se dovesse funzionare quello che potrei fare è richiedere, usando il **sense key** o il **babelnet id** per fare una richiesta alle api. l'output sarebbe esattamente il frame name di verb atlas, che dovrebbe combaciare 1 ad 1 con il predicato di verbatlas estratto da Mosaico (idealmente).

![[Pasted image 20240924184041.png]]

## Analisi preliminare

Per non rimanere completamente a mani vuote ho fatto un'analisi preliminare di quanto siano compatibili tra loro il frame VerbAtlas e il synset ottenuto. Sostanzialmente facendo il match quando il nome del synset di wordnet e il nome del frame di verbatlas sono uguali.
Quindi in casi come questo:

```
Predicate: SEE, Token Span: (13, 14), Synset: see%2:39:00::
```

Ma non in casi come questo

```
Predicate: RESTRAIN, Token Span: (21, 22), Synset: restrict%2:30:00::
```

Anche se chiaramente abbiamo una corrispondenza tra i due

## Analisi di match tra Verbatlas SRL e WSD

Alla fine ho sviluppato un algoritmo che mi ha permesso di analizzare ogni singolo predicato.
Lo script è "analyze_export_debug.py"

Si parte da una riga del file export.txt

```
Processing line: Predicate: EXIST-WITH-FEATURE, Token Span: (5, 6), Synset: bn:00082702v

Extracted Predicate: EXIST-WITH-FEATURE, Synset: bn:00082702v
Synset 'bn:00082702v' identified as a BabelNet ID.
Looking up BabelNet ID 'bn:00082702v' in BN-to-VA mapping.
Mapped BabelNet ID 'bn:00082702v' to VerbAtlas ID 'va:0104f'.
Mapped VerbAtlas ID 'va:0104f' to Frame 'EXIST-WITH-FEATURE'.
Predicate: EXIST-WITH-FEATURE, Frame: EXIST-WITH-FEATURE, Match: True

Processing line: Predicate: GIVE_GIFT, Token Span: (3, 4), Synset: bn:00088815v
```

E si estraggono il Frame Verbatlas e il synset, in questo caso:

```
Frame: EXIST-WITH-FEATURE
Synset (babelnet id): bn:00082702v 
```

Da babelnet id si passa all'id di Verbatlas:

```
Mapped BabelNet ID 'bn:00082702v' to VerbAtlas ID 'va:0104f'.
```

Da VA si passa al frame:

```
Predicate: EXIST-WITH-FEATURE, Frame: EXIST-WITH-FEATURE, Match: True
```


Una cosa simile, con più passi, avviene quando il synset (in WSD) ci viene dato come wordnet senseKEY

```
Processing line: Predicate: SEE, Token Span: (1, 2), Synset: sight%2:39:00::

Extracted Predicate: SEE, Synset: sight%2:39:00::
Synset 'sight%2:39:00::' identified as a WordNet sense key.
Looking up WordNet key 'sight%2:39:00::' in WN-to-sensekey mapping.
Mapped WordNet sense key 'sight%2:39:00::' to WordNet ID 'wn:02163746v'.
Mapped WordNet ID 'wn:02163746v' to BabelNet ID 'bn:00093726v'.
Mapped BabelNet ID 'bn:00093726v' to VerbAtlas ID 'va:0521f'.
Mapped VerbAtlas ID 'va:0521f' to Frame 'SEE'.
Predicate: SEE, Frame: SEE, Match: True
```

Il risultato è lo stesso.

Alla fine viene esportato un file con le statistiche di questo processo:

![[Pasted image 20241001112018.png]]

C'è il 66% di match tra WSD e SRL

## Analisi più in dettaglio di Mosaico

### Le pagine spagnole

Le pagine spagnole non risulta che hanno output quando chiedo di confrontare i predicati (wsd e srl)

![[Pasted image 20240925125608.png]]

Viene solo fatto il display dei titoli senza però che venga fuori niente.
Dopo aver scaricato la pagina di "Tamara de Georgia" ho notato che non ci sono annotazioni di SRL per verbatlas

![[Pasted image 20240925125709.png]]

E le annotazioni di WSD sembrano poche ad occhio

![[Pasted image 20240925125800.png]]

>[!hint]- considerazione
>mettere i synset o sense keys è meglio in WSD perchè mi permette di leggere ad occhio nudo il predicato, il babelnet index invece non mi permette ad occhio di fare una valutazione manuale

Questa cosa vale per tutte le pagine spagnole? Questa cosa vale anche per altre pagine? 

#### Questa cosa vale per tutte le pagine spagnole?
Per capire questa cosa conviene lanciare un altra volta lo script che estragga tutti i predicati da mosaico, inoltre, oltre al nome della pagina farò anche il display della lingua per capire se è una cosa circoscritta alle pagine spagnole. 

Intanto possiamo dire che come synset quelle inglesi hanno wordnet mentre le italiane hanno babelnet.

Inlgese:

![[Pasted image 20240925140725.png]]

Italiano:
![[Pasted image 20240925140748.png]]

Subito dopo le pagine in italiano cominciano le pagine spagnole, che non risultano avere annotazioni di Verbatlas

![[Pasted image 20240925141158.png]]

Prendiamo per esempio la pagina "Magiarizaciòn".

```bash
mongoexport --db=mosaico --collection=pages --query='{"title": "Magiarización"}' --out=single_entry.json --username=admin --password=****  --authenticationDatabase=admin
```

non ha annotazioni verbatlas

![[Pasted image 20240925141736.png]]

#### quante pagine spagnole non hanno annotazioni verbatlas? Tutte?

A quanto pare le annotazioni sono mancanti su tutte le pagine spagnole
![[Pasted image 20241001124318.png]]
### Pagine tedesche
Le pagine tedesche sembra abbiano frame di babelnet ma alcuni predicati non hanno frame di VerbAtlas

![[Pasted image 20240925141438.png]]

![[Pasted image 20240925141508.png]]

Inoltre, ad occhio e croce i predicati sono molti meno rispetto a quelli inglesi ed italiani

![[Pasted image 20241001125747.png]]

#### (TODO )Qual'è in media il numero di predicati in una pagina italiana e quale è il numero di predicati in media di una pagina tedesca, spagnola, inglese, francese e italiana

#### Pagine francesi

Le pagine francesi hanno meno predicati (verifica vedi capitolo precedente) e hanno qualche sporadico nullo sui frame di verbatlas

![[Pasted image 20240925142624.png]]

#### Pagine finali
Alla fine abbiamo alcune pagine che se richieste restituiscono un Noneobject

```python
pagine:
	Arthur Schnitzler| en
	Error processing page Arthur Schnitzler: 'NoneType' object has no attribute 'get'
	The Works (Queen album)| en
	Error processing page The Works (Queen album): 'NoneType' object has no attribute 'get'
	Czech language| en
	Error processing page Czech language: 'NoneType' object has no attribute 'get'
	Jacques Anquetil| en
	Error processing page Jacques Anquetil: 'NoneType' object has no attribute 'get'
	Common tern| en
	Error processing page Common tern: 'NoneType' object has no attribute 'get'
	Righteous Among the Nations| en
	Error processing page Righteous Among the Nations: 'NoneType' object has no attribute 'get'
	Okapi| en
	Error processing page Okapi: 'NoneType' object has no attribute 'get'
	Prince Andrew of Greece and Denmark| en
	Error processing page Prince Andrew of Greece and Denmark: 'NoneType' object has no attribute 'get'
	Star Trek (film)| en
	Error processing page Star Trek (film): 'NoneType' object has no attribute 'get'
	Jewish Christian| en
	Error processing page Jewish Christian: 'NoneType' object has no attribute 'get'
	The 40-Year-Old Virgin| en
	Error processing page The 40-Year-Old Virgin: 'NoneType' object has no attribute 'get'
	Pyrite| en
	Error processing page Pyrite: 'NoneType' object has no attribute 'get'
	Disintegration (The Cure album)| en
	Error processing page Disintegration (The Cure album): 'NoneType' object has no attribute 'get'
	Mijas| en
	Error processing page Mijas: 'NoneType' object has no attribute 'get'
	Constantius II| en
	Error processing page Constantius II: 'NoneType' object has no attribute 'get'
	Gale Sayers| en
	Error processing page Gale Sayers: 'NoneType' object has no attribute 'get'
	Maria Theresa| en
	Error processing page Maria Theresa: 'NoneType' object has no attribute 'get'
	Sarawak| en
	Error processing page Sarawak: 'NoneType' object has no attribute 'get'
	Nature Boy| en
	Error processing page Nature Boy: 'NoneType' object has no attribute 'get'
	Petra Kvitová| en
	Error processing page Petra Kvitová: 'NoneType' object has no attribute 'get'
	The Day the Earth Stood Still| en
	Error processing page The Day the Earth Stood Still: 'NoneType' object has no attribute 'get'
	Lohengrin (opera)| en
	Error processing page Lohengrin (opera): 'NoneType' object has no attribute 'get'
	Alexander von Humboldt| en
	Error processing page Alexander von Humboldt: 'NoneType' object has no attribute 'get'
	Bluebuck| en
	Error processing page Bluebuck: 'NoneType' object has no attribute 'get'
	Culhwch and Olwen| en
	Error processing page Culhwch and Olwen: 'NoneType' object has no attribute 'get'
	1986 Giro d'Italia| en
	Error processing page 1986 Giro d'Italia: 'NoneType' object has no attribute 'get'
	HMS Howe (32)| en
	Error processing page HMS Howe (32): 'NoneType' object has no attribute 'get'
	Basilica of San Isidoro, León| en
	Error processing page Basilica of San Isidoro, León: 'NoneType' object has no attribute 'get'
	Petrarch| en
	Error processing page Petrarch: 'NoneType' object has no attribute 'get'
	Liverpool Metropolitan Cathedral| en
	Error processing page Liverpool Metropolitan Cathedral: 'NoneType' object has no attribute 'get'
	CT scan| en
	Error processing page CT scan: 'NoneType' object has no attribute 'get'
	Plague (disease)| en
	Error processing page Plague (disease): 'NoneType' object has no attribute 'get'
	Cerebellum| en
	Error processing page Cerebellum: 'NoneType' object has no attribute 'get'
	Nitrogen| en
	Error processing page Nitrogen: 'NoneType' object has no attribute 'get'
	Museum Folkwang| en
	Error processing page Museum Folkwang: 'NoneType' object has no attribute 'get'
	Bad Blood (Taylor Swift song)| en
	Error processing page Bad Blood (Taylor Swift song): 'NoneType' object has no attribute 'get'
	Blow (Kesha song)| en
	Error processing page Blow (Kesha song): 'NoneType' object has no attribute 'get'
	HMS Ark Royal (91)| en
	Error processing page HMS Ark Royal (91): 'NoneType' object has no attribute 'get'
	HMS Bellerophon (1786)| en
	Error processing page HMS Bellerophon (1786): 'NoneType' object has no attribute 'get'
	John Jervis, 1st Earl of St Vincent| en
	Error processing page John Jervis, 1st Earl of St Vincent: 'NoneType' object has no attribute 'get'
	Liège| en
	Error processing page Liège: 'NoneType' object has no attribute 'get'
	The Irishman| en
	Error processing page The Irishman: 'NoneType' object has no attribute 'get'
	2016 Paris ePrix| en
	Error processing page 2016 Paris ePrix: 'NoneType' object has no attribute 'get'
	Professor Layton and the Last Specter| en
	Error processing page Professor Layton and the Last Specter: 'NoneType' object has no attribute 'get'
	Tazio Nuvolari| en
	Error processing page Tazio Nuvolari: 'NoneType' object has no attribute 'get'
	Wii Sports| en
	Error processing page Wii Sports: 'NoneType' object has no attribute 'get'
	Australian raven| en
	Error processing page Australian raven: 'NoneType' object has no attribute 'get'
	Tear down this wall!| en
	Error processing page Tear down this wall!: 'NoneType' object has no attribute 'get'
	Ki (Devin Townsend Project album)| en
	Error processing page Ki (Devin Townsend Project album): 'NoneType' object has no attribute 'get'
	We Are the World 25 for Haiti| en
	Error processing page We Are the World 25 for Haiti: 'NoneType' object has no attribute 'get'
	Kids on the Slope| en
	Error processing page Kids on the Slope: 'NoneType' object has no attribute 'get'
	Seven Samurai| en
	Error processing page Seven Samurai: 'NoneType' object has no attribute 'get'
	Cambodian Civil War| en
	Error processing page Cambodian Civil War: 'NoneType' object has no attribute 'get'
	Henry (bishop of Finland)| en
	Error processing page Henry (bishop of Finland): 'NoneType' object has no attribute 'get'
	Good Vibrations| en
	Error processing page Good Vibrations: 'NoneType' object has no attribute 'get'
	Idries Shah| en
	Error processing page Idries Shah: 'NoneType' object has no attribute 'get'
	Magical girl| en
	Error processing page Magical girl: 'NoneType' object has no attribute 'get'
	My Darling Clementine| en
	Error processing page My Darling Clementine: 'NoneType' object has no attribute 'get'
	Go First| en
	Error processing page Go First: 'NoneType' object has no attribute 'get'
	Aberdaron| en
	Error processing page Aberdaron: 'NoneType' object has no attribute 'get'
	Dookie| en
	Error processing page Dookie: 'NoneType' object has no attribute 'get'
	Havelsee| en
	Error processing page Havelsee: 'NoneType' object has no attribute 'get'
	Darius the Great| en
	Error processing page Darius the Great: 'NoneType' object has no attribute 'get'
	Battle of Marathon| en
	Error processing page Battle of Marathon: 'NoneType' object has no attribute 'get'
	Disasterpieces| en
	Error processing page Disasterpieces: 'NoneType' object has no attribute 'get'
	Khidr| en
	Error processing page Khidr: 'NoneType' object has no attribute 'get'
	Nik Stauskas| en
	Error processing page Nik Stauskas: 'NoneType' object has no attribute 'get'
	Marie Lafarge| en
	Error processing page Marie Lafarge: 'NoneType' object has no attribute 'get'
	Continued fraction| en
	Error processing page Continued fraction: 'NoneType' object is not iterable
	Neil Young (calciatore)| it
	Error processing page Neil Young (calciatore): 'NoneType' object is not iterable
	Gaston Bachelard| en
	Error processing page Gaston Bachelard: 'NoneType' object has no attribute 'get'
	Time Warner Center| it
	Error processing page Time Warner Center: 'NoneType' object is not iterable
	George Boyd| it
	Error processing page George Boyd: 'NoneType' object is not iterable
	John Beilein| it
	Error processing page John Beilein: 'NoneType' object is not iterable
	Élie Okobo| it
	Error processing page Élie Okobo: 'NoneType' object is not iterable
	Zavier Simpson| it
	Error processing page Zavier Simpson: 'NoneType' object is not iterable
	Jennifer Aniston| en
	Error processing page Jennifer Aniston: 'NoneType' object has no attribute 'get'
	Val Fitch| it
	Error processing page Val Fitch: 'NoneType' object is not iterable
	D. B. Cooper| en
	Error processing page D. B. Cooper: 'NoneType' object has no attribute 'get'
	D.J. Wilson| it
	Error processing page D.J. Wilson: 'NoneType' object is not iterable
	Leon Barnett| it
	Error processing page Leon Barnett: 'NoneType' object is not iterable
	Stuart Parnaby| it
	Error processing page Stuart Parnaby: 'NoneType' object is not iterable
	Ronnie Barker| it
	Error processing page Ronnie Barker: 'NoneType' object is not iterable
	Joaquín Reyes (attore)| it
	Error processing page Joaquín Reyes (attore): 'NoneType' object is not iterable
	Alicia McCormack| it
	Error processing page Alicia McCormack: 'NoneType' object is not iterable
	Mr. and Mrs. Iyer| it
	Error processing page Mr. and Mrs. Iyer: 'NoneType' object is not iterable
	Andrew Crofts| it
	Error processing page Andrew Crofts: 'NoneType' object is not iterable
	Jeremy Soule| it
	Error processing page Jeremy Soule: 'NoneType' object is not iterable
	Liechtenstein ai Giochi della XXXI Olimpiade| it
	Error processing page Liechtenstein ai Giochi della XXXI Olimpiade: 'NoneType' object is not iterable
	Markus Näslund| it
	Error processing page Markus Näslund: 'NoneType' object is not iterable
	Bud Grant| it
	Error processing page Bud Grant: 'NoneType' object is not iterable
	Calycanthaceae| it
	Error processing page Calycanthaceae: 'NoneType' object is not iterable
	Margaret Seddon| it
	Error processing page Margaret Seddon: 'NoneType' object is not iterable
	Pudasjärvi| it
	Error processing page Pudasjärvi: 'NoneType' object is not iterable
	Antony| it
	Error processing page Antony: 'NoneType' object is not iterable
	Rodgau| it
	Error processing page Rodgau: 'NoneType' object is not iterable
	Banksia aemula| it
	Error processing page Banksia aemula: 'NoneType' object is not iterable
	Mark Chesnutt| it
	Error processing page Mark Chesnutt: 'NoneType' object is not iterable
	Khris Middleton| it
	Error processing page Khris Middleton: 'NoneType' object is not iterable
	Aki Toyosaki| it
	Error processing page Aki Toyosaki: 'NoneType' object is not iterable
	Thank Me Later| it
	Error processing page Thank Me Later: 'NoneType' object is not iterable
	Erin Phillips| it
	Error processing page Erin Phillips: 'NoneType' object is not iterable
	Euclid| it
	Error processing page Euclid: 'NoneType' object is not iterable
	Steve Beshear| it
	Error processing page Steve Beshear: 'NoneType' object is not iterable
	Rincón de la Victoria| it
	Error processing page Rincón de la Victoria: 'NoneType' object is not iterable
	Hélio Castroneves| it
	Error processing page Hélio Castroneves: 'NoneType' object is not iterable
	Nahikari García| it
	Error processing page Nahikari García: 'NoneType' object is not iterable
	Tom Corbett| it
	Error processing page Tom Corbett: 'NoneType' object is not iterable
	George Engelmann| it
	Error processing page George Engelmann: 'NoneType' object is not iterable
	Huma Qureshi| it
	Error processing page Huma Qureshi: 'NoneType' object is not iterable
	Kandalanu| it
	Error processing page Kandalanu: 'NoneType' object is not iterable
	Steve Morison| it
	Error processing page Steve Morison: 'NoneType' object is not iterable
	Moritz Wagner| it
	Error processing page Moritz Wagner: 'NoneType' object is not iterable
	Paul Kelly (musicista)| it
	Error processing page Paul Kelly (musicista): 'NoneType' object is not iterable
	Formula di Viète| it
	Error processing page Formula di Viète: 'NoneType' object is not iterable
	Ricky Banderas| it
	Error processing page Ricky Banderas: 'NoneType' object is not iterable
	Michael Davitt| es
	Error processing page Michael Davitt: 'NoneType' object is not iterable
	Cunicultura| es
	Error processing page Cunicultura: 'NoneType' object is not iterable
	Kim Little| it
	Error processing page Kim Little: 'NoneType' object is not iterable
	Pequeños fósiles con concha| es
	Error processing page Pequeños fósiles con concha: 'NoneType' object is not iterable
	Sula dactylatra| es
	Fraates I de Partia| es
	Sinagoga de Besanzón| es
	Error processing page Sinagoga de Besanzón: 'NoneType' object is not iterable
	Boran| es
	Cygnus X-1| es
	Cyanolyca| es
	Kyren Wilson| es
	Error processing page Kyren Wilson: 'NoneType' object is not iterable
	John Parrott| es
	Error processing page John Parrott: 'NoneType' object is not iterable
	Virgen dorada de Essen| es
	Error processing page Virgen dorada de Essen: 'NoneType' object is not iterable
	Lee Peltier| es
	Error processing page Lee Peltier: 'NoneType' object is not iterable
	Muhtasib| es
	Error processing page Muhtasib: 'NoneType' object is not iterable
	Harry Arter| es
	Error processing page Harry Arter: 'NoneType' object is not iterable
	Wangerooge| es
	La Chapelle-Hullin| es
	DW Stadium| es
	Daniel Santos Peña| es
	Error processing page Daniel Santos Peña: 'NoneType' object is not iterable
	Salto en esquí en los Juegos Olímpicos de Sankt Moritz 1928| es
	Error processing page Salto en esquí en los Juegos Olímpicos de Sankt Moritz 1928: 'NoneType' object is not iterable
	Programa de Godesberg| es
	Puente George Washington| es
	Jeff Hendrick| es
	Error processing page Jeff Hendrick: 'NoneType' object is not iterable
	Trézéguet (futbolista egipcio)| es
	Error processing page Trézéguet (futbolista egipcio): 'NoneType' object is not iterable
	Ramon Perellos y Roccaful| de
	Error processing page Ramon Perellos y Roccaful: 'NoneType' object is not iterable
	Olympische Sommerspiele 2004/Teilnehmer (St. Kitts und Nevis)| de
	Error processing page Olympische Sommerspiele 2004/Teilnehmer (St. Kitts und Nevis): 'NoneType' object is not iterable
	Großer Zab| de
	Error processing page Großer Zab: 'NoneType' object is not iterable
	Groupe 4 du tableau périodique| fr
	Error processing page Groupe 4 du tableau périodique: 'NoneType' object is not iterable
	Sénégal aux Jeux olympiques d'hiver de 1992| fr
	Error processing page Sénégal aux Jeux olympiques d'hiver de 1992: 'NoneType' object is not iterable
	Requin-crocodile| fr
	Error processing page Requin-crocodile: 'NoneType' object is not iterable
	Lièvre de Yunnan| fr
	Error processing page Lièvre de Yunnan: 'NoneType' object is not iterable
	Témia vagabonde| fr
	Error processing page Témia vagabonde: 'NoneType' object is not iterable
	Nicobar ponctué| fr
	Error processing page Nicobar ponctué: 'NoneType' object is not iterable
	Cabézon toucan| fr
	Error processing page Cabézon toucan: 'NoneType' object is not iterable
	Noctule de Leisler| fr
	Error processing page Noctule de Leisler: 'NoneType' object is not iterable
	Lièvre des hauts-plateaux éthiopiens| fr
	Error processing page Lièvre des hauts-plateaux éthiopiens: 'NoneType' object is not iterable
	Mirzä Šäfi Vazeh| fr
	Error processing page Mirzä Šäfi Vazeh: 'NoneType' object is not iterable
	Aphanius d'Espagne| fr
	Error processing page Aphanius d'Espagne: 'NoneType' object is not iterable
	Afrancesamiento de Bruselas| es
	Hymenocallis| fr
	Error processing page Hymenocallis: 'NoneType' object is not iterable
	Pic syriaque| fr
	Error processing page Pic syriaque: 'NoneType' object is not iterable
	Are You Lonesome Tonight?| fr
	Error processing page Are You Lonesome Tonight?: 'NoneType' object is not iterable
	Antilope tétracère| fr
	Error processing page Antilope tétracère: 'NoneType' object is not iterable
```

A quanto pare queste pagine non hanno proprio il campo "WSD"

```python
	Arthur Schnitzler| en
	Error processing page Arthur Schnitzler: 'NoneType' object has no attribute 'get'
```


![[Pasted image 20240925143934.png]]

Che è il motivo per cui da l'errore di non iterabilità sull'oggetto.
Se è vero che queste pagine si sono "accumulate alla fine" non è però vero che questo errore sia soltanto derivato da queste pagine, anzi ci sono stati ben 3209 di questi errori, che corrispondono quindi a 3209 pagine senza annotazioni di WSD.

#### Questo problema c'è solo su WSD o anche su SRL?
per verificarlo ho modificato lo script che itera su tutto mosaico ed ho aggiunto due linee di debug al momento di iterare su wsd e srl annotations

```python
            srl_verbatlas = annotations['srl_verbatlas']
            wsd_annotations = annotations['wsd']

            if srl_verbatlas is None: print("there are no SRL annotations for this page")
            if wsd_annotations is None: print("There are no WSD annotations for this page")

```

In breve, su entrambi.
Facendo riferimento alle sole pagine spagnole alcune pagine non hanno annotazioni sia di WSD sia che di SRL

![[Pasted image 20240925150632.png]]

anche solo SRL

![[Pasted image 20240925150731.png]]

E anche solo WSD

![[Pasted image 20240925150808.png]]

## Analisi esaustiva di annotazioni mancanti

abbiamo visto che alcune pagine hanno annotazioni mancanti tra WSD e SRL.

1. it can either miss the whole SRL or WSD annotation
2. it can have the SRL and WSD object but it's missing the data therefore the output is empty even tho the object isn't none
3. it can lack both SRL and WSD

Per analizzare questo ho aggiunto alcune linee di debug nell'export dei predicati.

```
Nuria Cabanillas| it
there are no SRL annotations for this page
```
questo è un file senza annotazioni di SRL

```
Pyometra| en
There are no WSD annotations for this page
```

Possono anche non avere entrambi oppure può non avere annotazioni nonostante l'oggetto sia non None.

Ho fatto quindi una serie di script che processano l'export dei predicati

export.txt -----> |process_annotation_file.py| ------> annotation_summary.txt
![[Pasted image 20240925171645.png]]

annotation_summary.txt--->|compute_annotation_statistics.py|--->

![[Pasted image 20241001110907.png]]


## TODO
statistiche solo sull'inglese corrispondenza tra wsd e srl di sovrapposizione
numero di occorrenze frame di verbatlas su frame che matchano
per ogni frame

## Separare le lingue
ho separato export.txt in tutte le lingue usando lo script "separa_export_in_lingue.py"

A questo punto ho tutti i seguenti files

![[Pasted image 20241001153052.png]]

Li voglio processare separatamente in modo da ottenere le diverse statistiche su ognuno di questi files.
A questo punto applico "compute_annotation_statistics.py" ed ottengo le statistiche per ognuna delle lingue

Ita
![[Pasted image 20241001153344.png]]

English
![[Pasted image 20241001153454.png]]

Tedesco
![[Pasted image 20241001153536.png]]

French
![[Pasted image 20241001153711.png]]

Spanish
![[Pasted image 20241001153756.png]]


| Language | Pages with no SRL | Pages with no WSD | Pages with both SRL and WSD | Pages with unknown annotations not present | Total pages with issues |
| -------- | ----------------- | ----------------- | --------------------------- | ------------------------------------------ | ----------------------- |
| Italian  | 2729              | 0                 | 45                          | 7                                          | 2910                    |
| English  | 0                 | 230               | 1                           | 0                                          | 244                     |
| German   | 2                 | 0                 | 3                           | 990                                        | 1084                    |
| French   | 17                | 0                 | 13                          | 0                                          | 34                      |
| Spanish  | 9                 | 9                 | 14                          | 16542                                      | 17192                   |
|          | 2757              | 239               | 76                          | 17539                                      | 17539                   |

## Analisi più in profondità delle pagine spagnole
Le pagine spagnole ad una prima occhiata mancano di annotazioni.
In realtà la situazione è più complicata.
per alcune pagine, non molte, manca proprio l'oggetto json.
Per altre, la maggior parte, non viene semplicemente trovata la corrispondenza tra wsd e srl.
Nella maggior parte di questi casi, manca SRL. Anche se l'oggetto è presente.
Un esempio di questo è la pagina

```
Processing page: Estatina
---- WSD Annotation Preview ----
{'document_spans': [[{'token_span': [1, 2], 'label': 'bn:00053800n'}, {'token_span': [4, 5], 'label': 'bn:00085261v'}, {'token_span': [6, 7], 'label': 'bn:00051454n'}, {'token_span': [9, 10], 'label': 'bn:00041942n'}, {'token_span': [11, 12], 'label': 'bn:00028872n'}, {'token_span': [12, 13], 'label': 'bn:00102174a'}, {'token_span': [14, 15], 'label': 'bn:00086417v'}, {'token_span': [16, 17], 'label': 'bn:00018696n'}, {'token_span': [19, 20], 'label': 'bn:00078281n'}, {'token_span': [23, 24], 'l
---- End of WSD Preview ----
---- SRL (Verbatlas) Annotation Preview ----
[[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [],
----------------
WSD Count: 402
SRL Count: 0
Total Annotations Count: 402
```
Questo è un caso ovvio di problema.
Ma in altri casi le annotazioni ci sono effettivamente per entrambi.


```
Processing page: Jinmeiyō kanji
---- SRL (Verbatlas) Annotation Preview ----
[[], [{'predicate': {'token_idx': 10, 'label': 'COPULA'}, 'arguments': [{'start': 0, 'end': 9, 'role': 'Theme'}, {'start': 10, 'end': 11, 'role': 'V'}, {'start': 11, 'end': 25, 'role': 'Attribute'}]}, {'predicate': {'token_idx': 17, 'label': 'KNOW'}, 'arguments': [{'start': 14, 'end': 17, 'role': 'Theme'}, {'start': 17, 'end': 18, 'role': 'V'}, {'start': 18, 'end': 23, 'role': 'Topic'}, {'start': 23, 'end': 25, 'role': 'Location'}]}], [{'predicate': {'token_idx': 1, 'label': 'COPULA'}, 'argument
---- End of SRL (Verbatlas) Preview ----
---- WSD Annotation Preview ----
{'document_spans': [[], [{'token_span': [1, 2], 'label': 'chinese%3:01:00::'}, {'token_span': [2, 3], 'label': 'character%1:10:00::'}, {'token_span': [4, 5], 'label': 'use%1:04:00::'}, {'token_span': [6, 7], 'label': 'personal%3:00:00::'}, {'token_span': [7, 8], 'label': 'name%1:10:00::'}, {'token_span': [12, 13], 'label': 'set%1:14:00::'}, {'token_span': [15, 16], 'label': 'chinese%3:01:00::'}, {'token_span': [16, 17], 'label': 'character%1:10:00::'}, {'token_span': [17, 18], 'label': 'know%2:3
---- End of WSD Preview ----
-----------------
WSD Count: 283
SRL Count: 102
Total Annotations Count: 385

```

In questo caso potrebbe sembrare che effettivamente ci sia una corrispondenza. 

```
[
{
'predicate': {'token_idx': 10, 'label': 'COPULA'}, 'arguments':
[{'start': 0, 'end': 9, 'role': 'Theme'}, {'start': 10, 'end': 11, 'role': 'V'}, {'start': 11, 'end': 25, 'role': 'Attribute'}]
}, 
{
'predicate': {'token_idx': 17, 'label': 'KNOW'}, 'arguments': [{'start': 14, 'end': 17, 'role': 'Theme'}, {'start': 17, 'end': 18, 'role': 'V'}, {'start': 18, 'end': 23, 'role': 'Topic'}, {'start': 23, 'end': 25, 'role': 'Location'}]
}
]
```
Queste sono le annotazioni di una frase SRL. in questo caso il verbo è KNOW e il token span è 17-18.
Ma se andiamo a vedere la wsd di questa frase

```
[
{'token_span': [1, 2], 'label': 'chinese%3:01:00::'},
{'token_span': [2, 3], 'label': 'character%1:10:00::'},
{'token_span': [4, 5], 'label': 'use%1:04:00::'},
{'token_span': [6, 7], 'label': 'personal%3:00:00::'},
{'token_span': [7, 8], 'label': 'name%1:10:00::'},
{'token_span': [12, 13], 'label': 'set%1:14:00::'},
{'token_span': [15, 16], 'label': 'chinese%3:01:00::'},
{'token_span': [16, 17], 'label': 'character%1:10:00::'},
{'token_span': [17, 18], 'label': 'know%2:31:06::'},
{'token_span': [20, 21], 'label': 'name%1:10:00::'},
{'token_span': [24, 25], 'label': 'english%1:10:00::'}
]
```

Il motivo per cui lo script non riesce ad individuare questa roba è che il formato è diverso da quello delle altre lingue evidentemente

## Lista delle pagine problematiche
ho fatto una lista delle pagine problematiche.
Lo script si chiama "lista_pagine.py" e prende in input export.txt (o meglio la lista di nomi di pagine con la relativa annotazione mancante) e da in output un file per ognuna di tipo diverso di annotazione mancante

![[Pasted image 20241007131039.png]]


## Analisi solo inglese
Purtroppo anche analizzando i match tra wsd e srl stiamo sotto il 65 percento
![[Pasted image 20241008123314.png]]
![[Pasted image 20241008120547.png]]

### Statistiche dei frame
Abbiamo un file adesso chiamato frame_stats.txt che contiene tutti i frame di verbatlas ed i frame con i quali sono stati confusi maggiormente

![[Pasted image 20241008130733.png]]
realizzare una confusion matrix: confusion_matrix.py

Esempio: nella pagina dei Ramones inglese Know è stato confuso con agree_accept

```
Page: Ramones| en, Token Span: (19, Synset: know%2:31:06::, Confused with Frame: AGREE_ACCEPT
Page: Ramones| en, Token Span: (21, Synset: know%2:31:06::, Confused with Frame: AGREE_ACCEPT
Page: Ramones| en, Token Span: (14, Synset: meet%2:41:01::, Confused with Frame: MEET
Page: Ramones| en, Token Span: (24, Synset: know%2:31:06::, Confused with Frame: AGREE_ACCEPT
```

![[Pasted image 20241008153516.png]](analyze_export_debug.py)


## conta quante volte sbaglia (quante volte non c'è match)
devo fare un'analisi a campione.