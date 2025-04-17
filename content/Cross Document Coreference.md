
## Streaming Cross-Document Coreference Resolution: Evaluation and Modelling (Arie Cattan)

Il paper affronta le incongruenze nei protocolli di valutazione per CDCR. Cattan propone una metodologia di valutazione basata sul testo grezzo che non fa affidamento su menzioni annotate manualmente e ignore le singole entità (singleton).
Il modello è di tipo end-to end: cioè un modello che estende within document coreference a più documenti.

### Modello
1. Mention Extraction: Il modello utilizza BERT per estrarre menzioni direttamente dal testo, viene applicato un classificatore che identifica gli span di testo che rappresentano possibili menzioni di entità o eventi
2. Span pruning: di tutti i possibili span e menzioni, attraverso l'utilizzo di una funzione di scoring $S_m(i)$ vengono selezionati solo le mention con uno score che supera un certo treshold.
3. Span pair scoring: a tutte le coppie di mention assegnamo uno score che ci permetterà di fare clustering 
4. Clustering: le menzioni vengono raggruppate in clusters rappresentanti entità o eventi unici.
![[Pasted image 20241212103429.png]]

### Evaluation
Il modelllo è stato valutato sul dataset ECB+
Entity coreference: 35.7%
Evente coreference: 54.5%
ALL: 43.4 %


### Ulteriori considerazioni:
Attraverso una serie di ablation e gold additions tipo aggiungere gold mentions si può vedere che i bassi risultati sono dovuti soprattutto a sfide mirate al fatto che il task sia cross document.


## SciCo: Hierarchical Cross-Document Coreference for Scientific Concepts (Arie Cattan)
Il paper introduce un nuovo task: H-CDCR (hierarchycal cross document coreference) e un nuovo dataset: SciCO un dataset annotato per H-CDCR 3 volte più grande di ECB+.
SciCO si basa e si focalizza su concetti scientifici, che per natura sono gerarchici (ad esempio, un concetto principale come "modello CRF" implica il riferimento a un concetto più generale come "sequence tagging task")

### Modello
Il modello testato è di tipo Cross-Encoder: affronta simultaneamente la coreferenza e la gerarchia
#### **Vantaggi dell'Approccio Cross-Encoder**

- **Considerazione del contesto**: valutando le menzioni nel loro contesto, il modello può disambiguare significati e determinare relazioni più accuratamente.
- **Interazione diretta tra menzioni**: l'architettura consente al modello di catturare le interazioni tra le menzioni, migliorando la precisione nella determinazione delle relazioni.

## **Riassunto del paper "XCoref: Cross-Document Coreference Resolution in the Wild" di Anastasia Zhukova et al.**

---

### **Descrizione ad alto livello**

Il paper introduce **XCoref**, un metodo **non supervisionato** per la risoluzione della coreferenza cross-documento (CDCR) "nel mondo reale" ("in the wild"), con particolare attenzione ai testi giornalistici che presentano bias linguistico. A differenza dei metodi tradizionali che si concentrano su relazioni di coreferenza **rigide** (identità stretta), XCoref è progettato per risolvere anche relazioni **lasche** o astratte, che possono includere bridging o concetti con alta diversità lessicale.

---

### **Motivazione**

Nei testi giornalistici, specialmente quelli su eventi polarizzanti o controversi, l’uso di termini diversi per riferirsi allo stesso concetto (ad es. "DACA recipients" vs. "illegal aliens") può indurre bias percettivi. XCoref è pensato per individuare queste relazioni e migliorare la risoluzione della coreferenza in contesti complessi.

---

### **Struttura del modello XCoref**

XCoref utilizza un approccio **a setacci successivi** (_sieve-based_), un metodo tradizionalmente usato nella coreferenza risoluzione, adattato per risolvere sia:

1. **Coreferenze rigide** (identità stretta tra menzioni).
2. **Coreferenze lasche** (relazioni astratte come bridging o parafrasi concettuali).

#### **Pipeline del modello:**

1. **Pre-processing delle menzioni**:
    
    - Viene effettuato un parsing delle menzioni (entità, eventi, azioni) usando regole linguistiche per identificare candidati potenziali.
2. **Sieve-based Matching**:
    
    - Vengono applicati più livelli di confronto sequenziali (sieves), partendo dalle relazioni più semplici (identità rigida) e procedendo verso quelle più complesse (lasche).
    - Le relazioni sono stabilite in base a **similarità lessicale**, **parafrasi** e **associazioni semantiche**.
3. **Clustering delle menzioni**:
    
    - Le menzioni vengono raggruppate in **catene coreferenziali** man mano che passano attraverso i diversi livelli di matching.
    - Ad esempio:
        - Livello 1: Matching esatto → "Donald Trump" = "President Trump"
        - Livello 2: Bridging → "U.S. President" ↔ "the leader of the White House"

---

### **Risultati ottenuti**

L'accuratezza è stata valutata con le metriche standard di **CoNLL** per la coreferenza.

- **Prestazioni di XCoref**:
    - XCoref ha **superato sia TCA che i modelli di stato dell'arte** per CDCR.
    - Ha dimostrato una migliore capacità di risolvere menzioni con **alta diversità lessicale** e relazioni astratte.
- **Contesto di applicazione**:
    - XCoref è particolarmente efficace nell’identificare relazioni coreferenziali in articoli di notizie politiche.

---

### **Conclusioni**

XCoref rappresenta un passo avanti nella **risoluzione della coreferenza in contesti reali**, risolvendo sia menzioni con relazioni rigide che lasche. Il metodo si dimostra efficace nel rilevare bias linguistici nei testi giornalistici, contribuendo alla comprensione della polarizzazione attraverso l’analisi delle associazioni linguistiche.


## $CD^2CR$: Co-reference Resolution Across Documents and Domains

La maggiorparte dei benchmark su coreference across docuemnts contiene documenti della stessa natura (articoli di giornale principalmente). Può essere utile avere un dataset dove le coreference vengono da diversi domini. Ad esempio articoli scientifici ed articoli di giornale: potrebbe essere utile per i ricercatori al fine di ottenere informazioni su come i media parlano del proprio prodotto

### Dataset
Il dataset è costituito da coppie ( articolo scientifico - articolo di giornale ).
è stato raccolto facendo scraping dal web in un periodo che va da Aprile a Giugno del 2020, estreando gli abstract di articoli scientifici da articoli di giornale che li menzionavano.
Questo taks non è stato fatto sugli articoli nella loro interezza (sia per quello che riguarda gli articoli di giornale sia per quello che riguarda gli articoli scientifici), ma su riassunti di questi ultimi. Gli autori dicono che comunque è stata preservata la differenza di stile tra i due documenti, che è ciò che gli premeva conservare.
Hanno addestrato delle baseline e dimostrato che le performance sono modeste.