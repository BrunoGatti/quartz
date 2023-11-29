## **Distribuzione Normale (o Gaussiana):**

La distribuzione normale, anche nota come distribuzione gaussiana, è una delle distribuzioni di probabilità più importanti in statistica e teoria delle probabilità. È caratterizzata dalla sua forma a campana e completamente descritta da due parametri: la media ($\mu$) e la deviazione standard ($\sigma$). La sua funzione di densità di probabilità è data dalla formula:

$$f(x; \mu, \sigma) = \frac{1}{\sigma \sqrt{2\pi}} \exp\left(-\frac{(x - \mu)^2}{2\sigma^2}\right)$$

Dove$x$è la variabile casuale, $\mu$ è la media, $\sigma$ è la deviazione standard, $\pi$ è il numero di pi greco (circa 3.14159), ed $\exp$ è la funzione esponenziale.

La distribuzione normale è simmetrica rispetto alla sua media e segue la regola empirica o regola dei tre sigma, che afferma che circa il 68% dei dati si trova entro una deviazione standard dalla media, circa il 95% entro due deviazioni standard, e circa il 99.7% entro tre deviazioni standard.

## **Teorema Limite Centrale (CLT):**

Il Teorema Limite Centrale è uno dei concetti chiave in statistica e probabilità. Esso stabilisce che, a prescindere dalla distribuzione originale delle variabili casuali, la somma di un gran numero di tali variabili casuali tende a una distribuzione normale. In particolare, il CLT è valido quando il numero di variabili casuali sommate è sufficientemente grande.

Formalmente, il teorema afferma che se $X_1, X_2, \ldots, X_n$ sono variabili **casuali indipendenti** e identicamente distribuite (i.i.d.) con una media $\mu$ e una deviazione standard $\sigma$, allora la somma standardizzata delle variabili casuali:

$$Z = \frac{\sum_{i=1}^{n} (X_i - \mu)}{\sqrt{n \sigma^2}}$$

tende a una distribuzione normale standard (media zero, deviazione standard uno) quando $n$ diventa grande ($n \to \infty$).

Questo teorema è estremamente potente e ha ampie applicazioni in statistica inferenziale. Ad esempio, consente di derivare risultati importanti come l'intervallo di confidenza e i test di ipotesi per le medie di grandi campioni, anche quando la distribuzione delle singole osservazioni non è normalmente distribuita.

## Per variabile multivariata

Nel caso di una normale multivariata, il teorema del limite centrale può essere esteso alle distribuzioni di variabili casuali multivariate. Quindi, se si considera una somma di molte variabili casuali multivariate indipendenti e identicamente distribuite, la distribuzione di questa somma tenderà a una distribuzione normale multivariata al crescere del numero di variabili.