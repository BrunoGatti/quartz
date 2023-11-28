La distribuzione normale multivariata (DMN) è una generalizzazione della distribuzione normale univariata a più di una dimensione. Essa è completamente definita da un vettore di medie e una matrice di covarianza. La DMN è ampiamente utilizzata nelle statistiche, nell'analisi dei dati e in molte applicazioni pratiche in cui si lavora con più variabili casuali.

Ecco le caratteristiche principali della distribuzione normale multivariata:

1. **Parametri:**
   - **Vettore di Medie ($\boldsymbol{\mu}$):** Indica il centro della distribuzione multivariata e contiene le medie delle singole variabili.
   - **Matrice di Covarianza ($\boldsymbol{\Sigma}$):** Rappresenta le variazioni congiunte tra le variabili e la loro dispersione individuale.

2. **Notazione:**
   - Una variabile aleatoria multivariata è spesso rappresentata come un vettore casuale$\mathbf{X} = [X_1, X_2, \ldots, X_k]$, dove$k$è il numero di variabili.
   - La distribuzione normale multivariata è indicata come$\mathbf{X} \sim \mathcal{N}_k(\boldsymbol{\mu}, \boldsymbol{\Sigma})$, dove$k$è la dimensione del vettore casuale.

3. **Funzione di Densità di Probabilità:**
   - La funzione di densità di probabilità (PDF) per la distribuzione normale multivariata è espressa come:
    $$f(\mathbf{x}; \boldsymbol{\mu}, \boldsymbol{\Sigma}) = \frac{1}{(2\pi)^{k/2}|\boldsymbol{\Sigma}|^{1/2}} \exp\left(-\frac{1}{2}(\mathbf{x} - \boldsymbol{\mu})^T \boldsymbol{\Sigma}^{-1} (\mathbf{x} - \boldsymbol{\mu})\right)$$
     dove$\mathbf{x}$è il vettore casuale,$|\boldsymbol{\Sigma}|$è il determinante della matrice di covarianza e$(\mathbf{x} - \boldsymbol{\mu})^T$rappresenta la trasposta della differenza tra$\mathbf{x}$e$\boldsymbol{\mu}$.

4. **Proprietà:**
   - La DMN è completamente descritta dalle sue prime e seconde statistiche centrali (medie e covarianze).
   - Se le variabili sono indipendenti o se la matrice di covarianza è diagonale, la distribuzione multivariata si scompone nelle distribuzioni marginali univariate.

5. **Ellissi di Probabilità:**
   - La DMN è caratterizzata da ellissi di probabilità nel caso bidimensionale (due variabili). La forma e l'orientamento di queste ellissi sono influenzati dalla matrice di covarianza.

6. **Applicazioni:**
   - La DMN è utilizzata in diverse aree, tra cui analisi finanziaria, modellazione statistica, riconoscimento di pattern, analisi delle immagini e altro ancora.

La distribuzione normale multivariata è uno strumento potente quando si tratta di modellare le relazioni complesse tra più variabili casuali. La sua comprensione e l'uso adeguato possono migliorare la precisione delle analisi statistiche e delle previsioni in contesti multidimensionali.