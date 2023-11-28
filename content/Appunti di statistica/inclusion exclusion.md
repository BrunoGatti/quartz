Il principio di inclusione-esclusione è una tecnica combinatoria utilizzata per calcolare la cardinalità di unione di insiemi in termini delle cardinalità dei singoli insiemi e delle loro intersezioni. In altre parole, consente di calcolare il numero di elementi in una unione di insiemi, considerando gli elementi comuni in modo corretto.

La formula fondamentale del principio di inclusione-esclusione per due insiemi A e B è la seguente:
$$
 |A \cup B| = |A| + |B| - |A \cap B| 
$$
Questa formula tiene conto degli elementi in $A$ e in $B$ ma sottrae gli elementi che sono comuni ad entrambi $(|A \cap B|)$  una sola volta, poiché sono stati contati due volte nella somma di $A$ e $B$.

La formula può essere generalizzata per più insiemi. Ad esempio, per tre insiemi A, B, e C:

$$ |A \cup B \cup C| = |A| + |B| + |C| - |A \cap B| - |A \cap C| - |B \cap C| + |A \cap B \cap C| $$

Questa formula tiene conto degli elementi in $A$, in $B$, in $C$, sottrae gli elementi comuni a due insiemi, quindi aggiunge gli elementi comuni a tutti e tre gli insiemi per evitare di sottocountarli.

In generale, la formula può essere estesa a qualsiasi numero di insiemi, con l'alternanza di segni in base alla parità del numero di insiemi considerati.