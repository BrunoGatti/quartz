## Carattere
In statistica, il termine "carattere" si riferisce a una variabile che può assumere diversi valori. Ad esempio, se stiamo studiando l'altezza di una popolazione, l'altezza sarebbe considerata il carattere, e ciascun individuo avrebbe un valore specifico di altezza associato.

| Numero Componenti | Frequenza Assoluta |
|-------------------|---------------------|
| 1                 | 10                  |
| 2                 | 15                  |
| 3                 | 8                   |
| 4                 | 12                  |
| 5                 | 5                   |

Nell'esempio sopra, il numero delle componenti della famiglia è il carattere, le MODALITà di questo carattere sono i valori che può assumere (in questo caso il carattere ha 5 modalità)

## Frequenze assolute
A: mentre la colonna adiacente dovrebbe contenere le cosiddette frequenze assolute?
B: Esatto, hai ragione. Nella colonna adiacente al numero delle componenti familiari avrai le frequenze assolute corrispondenti a ciascuna modalità di carattere.

## Frequenze relative
A: le frequenze relative sarebbero invece la percentuale diviso cento giusto?
B:Esattamente, le frequenze relative sono calcolate dividendo la frequenza assoluta corrispondente per la somma totale delle frequenze. Per ottenere la percentuale, generalmente moltiplichi il risultato per 100.

La formula è:

$$\text{Frequenza Relativa} = \left( \frac{\text{Frequenza Assoluta}}{\text{Somma Totale delle Frequenze}} \right) \times 100$$

Supponiamo che la somma totale delle frequenze nel tuo esempio sia 50. Quindi, se hai una frequenza assoluta di 10 per il numero di componenti familiari 1, la frequenza relativa sarà:

$$\text{Frequenza Relativa} = \left( \frac{10}{50} \right) \times 100 = 20\%$$

Puoi applicare questa formula a ciascuna delle frequenze assolute per ottenere le rispettive frequenze relative in percentuale.

## Tabella doppia per esprimere due caratteri

A: nel caso di una tabella doppia, che esprime due caratteri, questi devono essere messi in colonna e in riga, giusto? Cosi da formare una matrice dove l'entry (i,J) rappresenta la frequenza assoluta dei due caratteri contemporaneamente

B:Sì, hai ragione. Nel caso di una tabella doppia o di una tabella di contingenza, i due caratteri che stai analizzando vengono solitamente posti nelle colonne e nelle righe per formare una matrice. L'entry nella riga i e colonna j rappresenta la frequenza assoluta di entrambi i caratteri contemporaneamente.

Ecco un esempio semplificato di come potrebbe apparire una tabella di contingenza:

| |Reddito 0-50k |Reddito 50-100k |Reddito 100k +|Freq assoluta|
|---|---|---|---|---|
|Famiglie con 1   | 5                      | 3                      | 2                      |10
|Famiglie con 2   | 2                      | 7                      | 4                      |13
|Famiglie con 3   | 1                      | 2                      | 6                      |9
|Frequenza assoluta|8|12|12| 32

In questo caso abbiamo le frequenze assolute di tutti e due i caratteri.

## Classe
Quando trattiamo una variabile statistica quantitativa (cioè una variabile che assume valori numerici), spesso raggruppiamo questi valori in intervalli o classi.

Una classe è un intervallo di valori che viene utilizzato per raggruppare e organizzare i dati in modo più gestibile.
Ad esempio, considera un set di dati che rappresenta l'età di un gruppo di persone. Invece di trattare ogni età specifica come un valore distinto, potresti creare classi di età come 0-10, 11-20, 21-30 e così via.

## Diagramma cartesiano

Ecco un esempio di come puoi rappresentare il carattere "Numero delle Componenti" e le relative frequenze assolute:

| Numero Componenti | Frequenza Assoluta |
|-------------------|---------------------|
| 1                 | 10                  |
| 2                 | 15                  |
| 3                 | 8                   |
| 4                 | 12                  |
| 5                 | 5                   |

1 | ██████████ 10
2 | ████████████████ 15
3 | ████████ 8
4 | ████████████ 12
5 | ██████ 5

## Funzione di ripartizione

La funzione di ripartizione (o cumulative distribution function, CDF in inglese) è una funzione che fornisce la probabilità che una variabile casuale sia minore o uguale a un certo valore. In altre parole, dato un valore$x$, la funzione di ripartizione restituisce la probabilità che la variabile casuale assuma un valore minore o uguale a$x$.

La CDF è spesso indicata con$F(x)$e può essere definita come:

$$F(x) = P(X \leq x)$$

Dove$X$è la variabile casuale.

Ecco una tabella che include il numero delle componenti, la frequenza assoluta, la frequenza relativa e la funzione di ripartizione:

Nella colonna "Funzione di Ripartizione", ciascun valore è ottenuto sommando le frequenze relative cumulative fino a quel punto. Ad esempio, per il numero di componenti 2, la funzione di ripartizione è$0.20 + 0.30 = 0.50$, indicando che il 50% delle osservazioni è inferiore o uguale a 2.

| Numero Componenti | Frequenza Assoluta | Frequenza Relativa | Funzione di Ripartizione |
|-------------------|---------------------|--------------------|--------------------------|
| 1                 | 10                  | 0.20               | 0.20                     |
| 2                 | 15                  | 0.30               | 0.50                     |
| 3                 | 8                   | 0.16               | 0.66                     |
| 4                 | 12                  | 0.24               | 0.90                     |
| 5                 | 5                   | 0.10               | 1.00                     |

Ecco un esempio di come potresti creare un plot per la funzione di ripartizione in Python:

```python
import matplotlib.pyplot as plt

# Dati
numero_componenti = [1, 2, 3, 4, 5]
funzione_ripartizione = [0.20, 0.50, 0.66, 0.90, 1.00]

# Creazione del grafico
plt.step(numero_componenti, funzione_ripartizione, where='post', label='Funzione di Ripartizione')
plt.xlabel('Numero Componenti')
plt.ylabel('Funzione di Ripartizione')
plt.title('Funzione di Ripartizione per il Numero di Componenti')
plt.ylim(0, 1.1)
plt.grid(True)
plt.legend()

# Visualizzazione del grafico
plt.show()
```
![[Pasted image 20231130141955.png]]
La funzione di ripartizione è ovviamente sempre crescente, l'ultimo valore è sempre 1.

## Rappresentare variabili statistiche continue
A: Abbiamo detto che le variabili statistiche continue assumono un range di valori, detto classe, giusto? Ora se dovessimo rappresentarle, sarebbe più sensato usare un istogramma, corretto?

B: Sì, hai ragione. Per le variabili statistiche continue, che assumono un intervallo di valori, l'istogramma è una rappresentazione grafica comune e significativa. L'istogramma è particolarmente utile per visualizzare la distribuzione dei dati e mostra la frequenza delle osservazioni in intervalli o classi.

| |Reddito 0-50k |Reddito 50-100k |Reddito 100k +|Freq assoluta|
|---|---|---|---|---|
|Famiglie con 1   | 5                      | 3                      | 2                      |10
|Famiglie con 2   | 2                      | 7                      | 4                      |13
|Famiglie con 3   | 1                      | 2                      | 6                      |9
|Frequenza assoluta|8|12|12| 32

|Frequenza assoluta reddito| 8|12|12|
|-----------------| -|-|-|

![[Pasted image 20231130143919.png]]
In questo caso sull'asse y abbiamo messo la frequenza assoluta e sulla x le classi di reddito.

A: 
In realtà però da quello che so, in un istogramma per una variabile statistica continua non dovresti mettere sull'asse y il valore della frequenza assoluta, ma piuttosto, la densità di frequenza, giusto?

B:  
Hai ragione. Per le variabili statistiche continue, è comune rappresentare la densità di frequenza sull'asse y anziché la frequenza assoluta. La densità di frequenza è la frequenza relativa divisa per la larghezza dell'intervallo.

la densità di frequenza ($f_d$) è calcolata dividendo la frequenza relativa ($f_r$) per la larghezza dell'intervallo ($w$):

$$f_d = \frac{f_r}{w}$$

Dove:

-$f_d$è la densità di frequenza.
-$f_r$è la frequenza relativa.
-$w$è la larghezza dell'intervallo.

La densità di frequenza è utile quando si rappresentano dati su variabili continue in un istogramma, poiché tiene conto delle dimensioni degli intervalli, consentendo una rappresentazione più accurata della distribuzione dei dati.

![[Pasted image 20231130144526.png]]

Nota che abbiamo modificato il terzo intervallo per renderlo della stessa dimensione degli altri 2, infatti, se lo avessimo lasciato >100, essendo l'intervallo infinito, il grafico sarebbe uscito così:

![[Pasted image 20231130144648.png]]
Qui il codice usato per il plot:
```python
import matplotlib.pyplot as plt
import numpy as np
# Dati di esempio
redditi = ['0-50', '50-100', '>100']
frequenze = [8, 12, 12]

# Calcolo della densità di frequenza
larghezza_intervallo = [50, 50, np.inf] # Supponiamo larghezze degli intervalli, l'ultimo intervallo va a infinito
densita_frequenza = [f / larghezza for f, larghezza in zip(frequenze, larghezza_intervallo)]
# Creazione di un dizionario per mappare le fasce di reddito
reddito_mapping = {'0-50': 1, '50-100': 2, '>100': 3}
# Assegnazione di colori a ciascuna fascia di reddito
colori = [reddito_mapping[reddito] for reddito in redditi]
# Creazione dell'istogramma con densità di frequenza
plt.figure(figsize=(10, 6))
plt.bar(redditi, densita_frequenza, color=plt.cm.viridis(colori), edgecolor='black')
# Personalizzazione del grafico
plt.xlabel('Reddito')
plt.ylabel('Densità di Frequenza')
plt.title('Istogramma: Densità di Frequenza per Fasce di Reddito')
plt.legend()
# Visualizzazione del grafico
plt.show()
```

## Rappresentare le mutabili statistiche

#### Mutabili statistiche connesse (ordinate)
con un grafico a "canne d'organo", praticamente un istogramma dove non abbiamo sulle y la densità di frequenza ma le frequenze assolute.

| Titolo di Studio    | Frequenza |
|---------------------|-----------|
| Laurea              | 30        |
| Diploma            | 25        |
| Scuola Media       | 20        |
| Scuola Elementare  | 15        |
| Nessun Titolo      | 10        |

![[Pasted image 20231130145522.png]]

#### Mutabili statistiche sconnesse
Nel caso di mutabili statistiche sconnesse (non ordinabili) si usa un grafo a torta

| Facoltà              | Frequenza |
|----------------------|-----------|
| Ingegneria           | 25        |
| Medicina             | 20        |
| Lettere e Filosofia  | 15        |
| Scienze Politiche    | 12        |
| Economia             | 10        |
| Scienze Informatiche | 10        |
| Architettura         | 8         |

![[Pasted image 20231130145757.png]]
#### Calcolo dei gradi
Il calcolo dei gradi per ciascuna categoria in base alla frequenza assoluta è dato dalla formula:

$$\text{Gradi per Categoria} = \left( \frac{\text{Frequenza Assoluta della Categoria}}{\text{Somma delle Frequenze Assolute Totali}} \right) \times 360$$

- Gradi per A:$\left( \frac{30}{100} \right) \times 360 = 108$
- Gradi per B:$\left( \frac{20}{100} \right) \times 360 = 72$
- Gradi per C:$\left( \frac{10}{100} \right) \times 360 = 36$
etc

## Grafici 3d per due variabili

se le variabili statistiche sono 2 allora ovviamente serve un garfo 3d

| |Reddito 0-50k |Reddito 50-100k |Reddito 100k +|Freq assoluta|
|---|---|---|---|---|
|Famiglie con 1   | 5                      | 3                      | 2                      |10
|Famiglie con 2   | 2                      | 7                      | 4                      |13
|Famiglie con 3   | 1                      | 2                      | 6                      |9
|Frequenza assoluta|8|12|12| 32

![[Pasted image 20231130150656.png]]

## Le medie
Ecco una panoramica delle diverse tipologie di medie analitiche, insieme alle relative formule e un esempio utilizzando i dati precedenti sul reddito delle famiglie:

| |Reddito 0-50k |Reddito 50-100k |Reddito 100k +|Freq assoluta|
|---|---|---|---|---|
|Famiglie con 1   | 5                      | 3                      | 2                      |10
|Famiglie con 2   | 2                      | 7                      | 4                      |13
|Famiglie con 3   | 1                      | 2                      | 6                      |9
|Frequenza assoluta|8|12|12| 32
### 1. **Media Aritmetica (o Media delle Frequenze):**

La media aritmetica se sostituita ad ogni valore lascia invariata la somma

   - **Formula:** $\text{Media Aritmetica} = \frac{\sum x_i}{n}$
   - Dove $x_i$ sono i valori e $n$ è la dimensione del campione.

   - **Esempio con i dati sui redditi delle famiglie:**
     $$ \text{Media Aritmetica} = \frac{(5 + 3 + 2 + 2 + 7 + 4 + 1 + 2 + 6)}{9} = 3,33 $$
3,33 se sostituito a tutti i valori mantiene la somma invariata

Inoltre la media aritmetica ha la proprietà traslativa e moltiplicativa. Cioè se aggiungo o moltiplico a tutti i valori una costante, allora anche la media verrà aumentata (o moltiplicata) per quella costante

Inoltre gode della proprietà associativa, quindi posso calcolare la media aritmetica come la media ponderata di ogni gruppo. Tipo se prendiamo le tre classi di reddito, e per ognuna prendiamo la media, si fa la media ponderata si trova la media aritmetica.

Per la media aritmetica, la somma dei quadrati degli scarti dei valori rispetto alla media è un minimo. Questo concetto è noto come il "principio del minimo quadrato" e gioca un ruolo chiave nelle statistiche.

La formula matematica che esprime questo principio è la seguente:

$$\sum_{i=1}^{n} (x_i - \bar{x})^2 $$

Il principio del minimo quadrato implica che, tra tutte le possibili scelte di una costante come stima di posizione centrale, la media aritmetica è quella che minimizza la somma dei quadrati degli scarti. In altre parole, la media aritmetica è la scelta che rende la somma dei quadrati degli scarti dei valori dalla media il più piccolo possibile. Questo rende la media aritmetica una misura robusta e comunemente utilizzata di posizione centrale in statistica.
### 2. **Media Geometrica:**


   - **Formula:** $\text{Media Geometrica} = \sqrt[n]{x_1 \cdot x_2 \cdot \ldots \cdot x_n}$
   - Dove $x_i$ sono i valori e $n$ è la dimensione del campione.

   - **Esempio con i dati sui redditi delle famiglie:**
     $$ \text{Media Geometrica} = \sqrt[9]{5 \cdot 3 \cdot 2 \cdot 2 \cdot 7 \cdot 4 \cdot 1 \cdot 2 \cdot 6} $$

### 3. **Media Armonica:**
   - **Formula:** $ \text{Media Armonica} = \frac{n}{\frac{1}{x_1} + \frac{1}{x_2} + \ldots + \frac{1}{x_n}} $
   - Dove $ x_i $ sono i valori e $ n $ è la dimensione del campione.

   - **Esempio con i dati sui redditi delle famiglie:**
     $$ \text{Media Armonica} = \frac{9}{\frac{1}{5} + \frac{1}{3} + \frac{1}{2} + \frac{1}{2} + \frac{1}{7} + \frac{1}{4} + \frac{1}{1} + \frac{1}{2} + \frac{1}{6}} $$

#### 4. **Media Quadratica (o Radice Quadrata della Media dei Quadrati):**
   - **Formula:** $ \text{Media Quadratica} = \sqrt{\frac{\sum x_i^2}{n}} $
   - Dove $ x_i $ sono i valori e $ n $ è la dimensione del campione.

   - **Esempio con i dati sui redditi delle famiglie:**
     $$ \text{Media Quadratica} = \sqrt{\frac{5^2 + 3^2 + 2^2 + 2^2 + 7^2 + 4^2 + 1^2 + 2^2 + 6^2}{9}} $$

#### 5. **Media di Potenza (o Media $ p $-esima):**
   - **Formula:** $ \text{Media di Potenza} = \sqrt[p]{\frac{\sum x_i^p}{n}} $
   - Dove $ x_i $ sono i valori, $ n $ è la dimensione del campione, e $ p $ è l'esponente della potenza.

   - **Esempio con i dati sui redditi delle famiglie (supponiamo $ p = 3 $):**

	 $$ \text{Media di Potenza} = \sqrt[3]{\frac{5^3 + 3^3 + 2^3 + 2^3 + 7^3 + 4^3 + 1^3 + 2^3 + 6^3}{9}} $$

Ricorda che la scelta della media dipende dal contesto specifico e dall'obiettivo dell'analisi. Ciascun tipo di media ha caratteristiche uniche e fornisce informazioni diverse sulla distribuzione dei dati.

## Medie lasche o di posizione
Si può fare solo ordinando i valori di x

### Valore centrale di x: 
$${vc}= \frac{x_{min}-x_{max}}{2} $$
La somma tra il minimo valore osservato di x e il massimo valore osservato di x.
ES: x=1,2,3,4
$$ vc=\frac{1+4}{2}= 2.5 $$
### Moda
è il valore x con la maggiore frequenza

| |Reddito 0-50k |Reddito 50-100k |Reddito 100k +|Freq assoluta|
|---|---|---|---|---|
|Famiglie con 1   | 5                      | 3                      | 2                      |10
|Famiglie con 2   | 2                      | 7                      | 4                      |13
|Famiglie con 3   | 1                      | 2                      | 6                      |9
|Frequenza assoluta|8|12|12| 32

Per la grandezza del nucleo familiare la moda sono le famiglie con 2 persone che compongono il nucleo

Quando si calcola la moda su classi, però bisogna calcolare la densità di frequenza, non basta calcolare la frequenza assoluta.
![[Pasted image 20231130144526.png]]
in questo caso guardiamo la densità di ferquenza abbiamo due mode! Bimodalità!

## La mediana
è il valore che divide a metà le osservazioni.
X=1,2,3,4
mediana=2,5
che in questo caso coincide con la media, ma non sempre
X=1,2,7,8,9
in questo caso la mediana è 7

Si può anche trovare a partire dalla funzione di ripartizione, ed è il valore in corrispondenza del quale la funzione di ripartizione prende il valore 0,50.


| Numero Componenti | Frequenza Assoluta | Frequenza Relativa | Funzione di Ripartizione |
|-------------------|---------------------|--------------------|--------------------------|
| 1                 | 10                  | 0.20               | 0.20                     |
| 2                 | 15                  | 0.30               | 0.50                     |
| 3                 | 8                   | 0.16               | 0.66                     |
| 4                 | 12                  | 0.24               | 0.90                     |
| 5                 | 5                   | 0.10               | 1.00                     |

In questo caso è 2 il valore di mediana. 

Nel caso in cui si ha a che fare con classi:

|xi|ni| Funzione di ripartizione|
|--|--|--|
|0-5|7|0,47|
|5-10|5|0,80|
|10-15|3|1|
In questo caso per calcolare il valore esatto di mediana dobbiamo prendere la classe "5-10" (perchè quella con funzione di ripartizione immediatamente maggiore a 0,5)
ed applicare la seguente formula.

$$ Me=5+\frac{5}{0,80-0,47}{(0,5-0,47)}=5,45 $$
Per capire, all'interno della classe in quale valore esatto si trova la mediana.

#### Quando conviene utilizzare la mediana al posto della media?
Quando ho molti outliers

X= 1,2,3,100

media=26.5
mediana=2.5

## Quartili
I quartili dividono i valori in quattro parti, quindi sono tre.
x=1,2,3,4
q1=1,5
q2=2,5
q3=3,5

Nel caso ponderato continuo:

|xi|ni| Funzione di ripartizione|
|--|--|--|
|0-5|7|0,47|
|5-10|5|0,80|
|10-15|3|1|

 $$Q1=min~classe+\frac{ampiezza~quartile}{FR~classe-FR~classe~precedente}{(posizione~percent~quartile-FR~classe~precedente)} $$
$$Q1=0+\frac{5}{0,47-0}{(0,25-0)}=2,66 $$
  $$Q2=ME=5+\frac{5}{0,80-0,47}{(0,5-0,47)}=5,45 $$
  