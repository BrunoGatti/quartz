In SRL la maggiorparte delle volte si cerca il verbo per trovare i ruoli dei suoi argomenti, ma il significato verbale a volte è anche insito all'interno di altri parti del discorso.

ES: "Sensational robbery at the bank during the night" in questo caso robbery, che sintatticamente è un nome, ha un significato predicativo.

I moderni sistemi di SRL che analizzano solo predicati verbali non possono identificare l'evento nominale nella frase.
Inoltre questi nomi con funzione predicativa non sono assolutamente una rara occorrenza, specialmente in domini come i tweet, i titoli di giornale, messaggi corti e dialoghi.

Gli autori propongono un set di esempi basati su propbank (PB-examples) costituito da esempi che valutano la performance di SRL su Predicati verbali, nominali e aggettivi.

Testando sistemi di SRL state of the art su questo dataset si può vedere come le performance si deteriorano se si cerca il significato verbale nei nomi ed ancora di più negli aggettivi, che indica che non c'è quello che gli autori chiamano "Knowledge transfer" tra predicati di tipo diverso.

Inoltre gli autori notano come non ci sia nessun dataset di training che includa adjectival PAS per Semantic Role Labeling (da qui il motivo per cui sistemi stato dell'arte performano così male sugli aggettivi).

## Other linguistic resources
Propbank, proprio a causa del fatto che non contiene verbi-aggettivo e che è sbilanciata verso predicati verbali potrebbe non essere ottimale per questo tipo di task. Sono state quindi testate altre risorse linguistiche per SRL: PropBank, FrameNet, VerbNet, VerbAtlas.
Per valutare questi sistemi comparativamente è stata createa una risorsa che includesse annotazioni in tutti e quattro questi inventari.
Il set in questione è fatto da training, validation e test (7000 train, 800 test, 900 validation).
Questo studio è stato fatto per studiare l'impatto dell'inventory su Parallel-SemLink $$($CN-22_{PropBank},\ CN-22_{FrameNet},\ CN-22_{Verbnet},\ CN-22_{VerbAtlas}$)$$
Un risultato ottenuto è che in effetti l'inventario ha un impatto su unseen frames (Challenge-SRL ha solo unseen predicates):
![[Pasted image 20241118120618.png]]

Sembrerebbe che le astrazioni di VerbAtlas in effetti agiscano positivamente sul riconoscimento di unseen patterns.

### Challenge-SRL
Challenge SRL contiene solo predicati non visti di PropBank SRL. Contiene 96 frasi per ogni tipo di predicato (nome, verbo, aggettivo) ed è annotato manualmente da esperti.

## WSD for detecting verbs
Il capitolo discute l'uso della **Disambiguazione del Senso delle Parole (Word Sense Disambiguation, WSD)** per migliorare il **Semantic Role Labeling (SRL)**, in particolare per quanto riguarda SRL non verbale. La WSD assegna il significato più appropriato a una parola nel contesto utilizzando un inventario di sensi predefinito, mentre SRL si concentra sulla disambiguazione del senso dei predicati; tuttavia, la WSD opera su tutte le parole di contenuto. Gli autori propongono che integrare la WSD potrebbe migliorare la capacità di generalizzazione di SRL, specialmente per le strutture predicato-argomento non viste durante l'addestramento.

Punti principali:

1. **Relazione tra WSD e SRL**:
   - La WSD condivide somiglianze con la disambiguazione del senso dei predicati, ma ha un ambito più ampio.
   - Esplorare il contributo della WSD potrebbe migliorare le prestazioni di SRL in scenari impegnativi e non previsti.

2. **Esperimenti con VerbAtlas e AMuSE-WSD**:
   - I frame di VerbAtlas sono collegati ai synset di WordNet, consentendo una mappatura tra le previsioni di WSD (da AMuSE-WSD) e i compiti di SRL.
   - I confronti delle prestazioni mostrano che la WSD, come baseline, supera i sistemi SRL in scenari con dati di addestramento limitati:
     - Sono stati osservati miglioramenti significativi per verbi, sostantivi e aggettivi.
     - Per i predicati nominali, la baseline di WSD ha migliorato le prestazioni complessive (+5.7 rispetto al miglior sistema SRL).

3. **Risultati degli esperimenti con un oracolo**:
   - Utilizzando un oracolo per combinare le migliori previsioni di WSD e SRL si ottiene un ulteriore miglioramento (41.5% contro il 26.0% di accuratezza).
   - Ciò dimostra che i sistemi SRL attuali potrebbero beneficiare dell'integrazione esplicita della semantica lessicale fornita dalla WSD.

4. **Prospettive future**:
   - Si ipotizza che un'integrazione più stretta tra WSD e SRL potrebbe migliorare ulteriormente le capacità di generalizzazione di SRL.

I risultati suggeriscono che sfruttare la WSD potrebbe affrontare le limitazioni di SRL, in particolare in scenari con pochi dati, e aprire la strada a una combinazione tra semantica lessicale e SRL per ottenere risultati migliori

![[Pasted image 20241118140057.png]]