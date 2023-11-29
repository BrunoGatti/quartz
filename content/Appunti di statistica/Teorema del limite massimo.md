## Introduzione 
Iniziamo con l'idea principale. Immaginate di avere una sequenza di variabili casuali indipendenti e identicamente distribuite (iid). La Legge del Limite Massimo si concentra su ciò che accade quando consideriamo il massimo di queste variabili in una sequenza finita.

### **Definizione Formale:**

Sia $X_1, X_2, \ldots, X_n$ una sequenza di variabili casuali iid con funzione di distribuzione cumulativa $F(x)$. La distribuzione dei massimi $\{M_n\}$, dove $M_n = \max(X_1, X_2, \ldots, X_n)$, può essere descritta in termini di una funzione di distribuzione estrema $G(x)$ come segue:

$$ \lim_{{n \to \infty}} P\left(\frac{M_n - b_n}{a_n} \leq x\right) = G(x) $$

dove $a_n > 0$ e $b_n$ sono sequenze di costanti.

### **Significato Intuitivo:**

In parole più semplici, la Legge del Limite Massimo ci dice cosa succede alla distribuzione del massimo quando la dimensione del campione $n$ cresce all'infinito. La distribuzione dei massimi converge a una distribuzione estrema $G(x)$, spesso chiamata "distribuzione di Gumbel" o "distribuzione di Frechet", a seconda delle condizioni specifiche.

### **Applicazioni Pratiche:**

Questa teoria è fondamentale in vari campi, come l'ingegneria, l'idrologia e l'assicurazione, dove è cruciale comprendere e quantificare gli eventi estremi, come ad esempio le massime piene di un fiume, i massimi di temperatura, o le perdite finanziarie eccezionali.

### Conclusioni:

In sintesi, la Legge del Limite Massimo ci fornisce uno strumento potente per modellare e comprendere gli eventi estremi in una sequenza di variabili casuali. Attraverso questa teoria, possiamo fare previsioni e analisi più robuste nelle situazioni in cui gli eventi eccezionali giocano un ruolo critico.

Certamente! Ecco un breve esercizio che coinvolge il Teorema del Limite Massimo:

## **Esercizio:**

Supponiamo di avere una sequenza di variabili casuali indipendenti e identicamente distribuite (iid) $X_1, X_2, \ldots, X_n$, ognuna con una distribuzione esponenziale di parametro $\lambda$, cioè $X_i \sim \text{Exp}(\lambda)$. La nostra variabile di interesse è la perdita massima in $n$ partite di poker, $M_n = \max(X_1, X_2, \ldots, X_n)$. Utilizzando la Legge del Limite Massimo, determina la distribuzione limite di $M_n$ quando $n$ tende all'infinito.

### **Soluzione:**

**Passo 1: Identificare la distribuzione di $X_i$:**
Poiché $X_i$ segue una distribuzione esponenziale, la sua funzione di distribuzione cumulativa è $F(x) = 1 - e^{-\lambda x}$ per $x \geq 0$.

**Passo 2: Trovare la funzione di distribuzione di $M_n$:**
La distribuzione di $M_n$ è la funzione di distribuzione cumulativa della variabile massima. Per $M_n$, la sua funzione di distribuzione cumulativa è $P(M_n \leq x) = [F(x)]^n$.

**Passo 3: Applicare la Legge del Limite Massimo:**
Considerando il limite quando $n$ tende all'infinito, otteniamo:
$$ \lim_{{n \to \infty}} P(M_n \leq x) = \lim_{{n \to \infty}} [1 - e^{-\lambda x}]^n $$

**Passo 4: Determinare la Distribuzione Limite:**
Per determinare la distribuzione limite, notiamo che l'espressione assomiglia al termine di una funzione esponenziale. Possiamo applicare il limite di una funzione esponenziale alla potenza infinita, ottenendo:
$$ \lim_{{n \to \infty}} [1 - e^{-\lambda x}]^n = e^{-e^{-\lambda x}} $$

Quindi, la distribuzione limite di $M_n$ è una distribuzione di Gumbel con parametro di posizione $0$ e parametro di scala $1/\lambda$.

**Nota:**
Questo esercizio illustra come la Legge del Limite Massimo può essere applicata a una sequenza di variabili casuali esponenziali per trovare la distribuzione limite della loro massima.