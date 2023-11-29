Una funzione di ripartizione, anche chiamata funzione distribuzione cumulativa (CDF, Cumulative Distribution Function in inglese), è una funzione matematica che fornisce la probabilità che una variabile casuale assuma un valore minore o uguale a un dato punto. In altre parole, la CDF di una variabile casuale $X$, spesso indicata con $F(x)$, è definita come:

$$ F(x) = P(X \leq x) $$

Dove:
- $F(x)$ rappresenta la probabilità che la variabile casuale $X$ assuma un valore minore o uguale a $x$.
- $x$ è il valore per il quale stiamo valutando la probabilità.
- $P(\cdot)$ indica la probabilità.

La funzione di ripartizione ha alcune proprietà fondamentali:

1. **Non-decrescenza:** $F(x_1) \leq F(x_2)$ se $x_1 \leq x_2$.
2. **Limiti ai margini:** $F(-\infty) = 0$ e $F(\infty) = 1$.
3. **Continuità a destra:** La funzione è continua da destra, il che significa che $\lim_{{h \to 0^+}} F(x + h) = F(x)$ per ogni $x$.

La funzione di ripartizione è una rappresentazione chiave delle caratteristiche di una distribuzione di probabilità. Da essa, è possibile ottenere informazioni sulla probabilità di eventi in un determinato intervallo e valutare la forma generale della distribuzione. Quando stiamo lavorando con una variabile casuale continua, la CDF può essere ottenuta attraverso l'integrazione della funzione di densità di probabilità (pdf).