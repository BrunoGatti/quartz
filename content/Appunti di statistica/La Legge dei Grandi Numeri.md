La Legge dei Grandi Numeri (LLN) è un concetto fondamentale nella teoria delle probabilità e nella statistica. Essa stabilisce che, all'aumentare delle dimensioni di un campione casuale, la media campionaria converge verso il valore atteso della variabile casuale. In altre parole, la LLN descrive il comportamento limite delle medie campionarie.

Ci sono due versioni principali della Legge dei Grandi Numeri:

1. **LLN di Bernoulli:**
   - Considera una sequenza di variabili casuali indipendenti e identicamente distribuite (i.i.d.), ad esempio, lanci di una moneta con probabilità di successo  $p$ e fallimento  $1-p$.
   - La LLN di Bernoulli afferma che, all'aumentare del numero di lanci, la frequenza relativa di successi converge alla probabilità di successo  $p$.

2. **LLN di Khintchine:**
   - Si applica a una sequenza di variabili casuali i.i.d. con valore atteso finito $\mu$.
   - La LLN di Khintchine stabilisce che la media campionaria converge al valore atteso $\mu$all'aumentare delle dimensioni del campione.

Formalmente, se $X_1, X_2, \ldots, X_n$sono variabili casuali i.i.d. con valore atteso $\mu$, allora la LLN afferma che:

$$\frac{X_1 + X_2 + \ldots + X_n}{n} \xrightarrow{P} \mu$$

dove $\xrightarrow{P}$indica la convergenza in probabilità. Questo significa che, per ogni $\varepsilon > 0$:

$$\lim_{{n \to \infty}} P\left(\left|\frac{X_1 + X_2 + \ldots + X_n}{n} - \mu\right| \geq \varepsilon\right) = 0$$

In altre parole, la probabilità che la media campionaria si discosti significativamente dal valore atteso diventa sempre più piccola all'aumentare delle dimensioni del campione.

La LLN sottolinea il fatto che, anche se le variabili casuali individuali possono mostrare comportamenti casuali o imprevedibili, l'effetto medio su un gran numero di osservazioni segue un andamento più regolare e prevedibile. Questa legge è alla base di molte inferenze statistiche e fornisce una giustificazione teorica per l'uso della media campionaria come stimatore della media di una popolazione.