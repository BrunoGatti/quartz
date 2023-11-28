La distribuzione normale, o gaussiana, è una delle distribuzioni di probabilità continue più importanti in statistica e probabilità. È spesso chiamata la "curva a campana" a causa della sua forma caratteristica.

Caratteristiche chiave della distribuzione normale:

1. **Parametri:**
   - Media $(\mu)$: Rappresenta il valore atteso o il centro della distribuzione.
   - Deviazione standard ($\sigma$): Misura la dispersione dei dati attorno alla media.

2. **Notazione:**
   - Una variabile casuale che segue una distribuzione normale con media $\mu$ e deviazione standard $\sigma$ viene denotata come $X \sim \mathcal{N}(\mu, \sigma^2)$.

3. **Funzione di Densità di Probabilità:**
   La funzione di densità di probabilità (pdf) della distribuzione normale è data da:
   $$ f(x; \mu, \sigma) = \frac{1}{\sigma \sqrt{2\pi}} e^{-\frac{1}{2}\left(\frac{x - \mu}{\sigma}\right)^2} $$

4. **Forma della Curva:**
   - La distribuzione normale è simmetrica rispetto alla sua media e assume una forma a campana.
   - Circa il 68% dei dati si trova entro una deviazione standard dalla media (\(\mu \pm \sigma\)).
   - Circa il 95% dei dati si trova entro due deviazioni standard dalla media (\(\mu \pm 2\sigma\)).
   - Circa il 99.7% dei dati si trova entro tre deviazioni standard dalla media (\(\mu \pm 3\sigma\)).

5. **Standardizzazione:**
   - La standardizzazione è il processo di trasformare una variabile normale in una variabile standard normale ($Z$), con media 0 e deviazione standard 1:
     $$ Z = \frac{X - \mu}{\sigma} $$

6. **Tabella Z:**
   - La tabella Z viene spesso utilizzata per trovare le probabilità associate ai valori standardizzati nella distribuzione normale standard.

7. **Esempio:**
   - Supponiamo che le altezze di una popolazione siano distribuite normalmente con una media di 170 cm e una deviazione standard di 10 cm. Una persona scelta a caso da questa popolazione avrà un'altezza che segue una distribuzione normale con $X \sim \mathcal{N}(170, 100)$.

La distribuzione normale è fondamentale in molti campi, inclusi l'analisi statistica, l'inferenza statistica, la teoria delle probabilità e molti modelli matematici e scientifici. La sua importanza deriva anche dal teorema del limite centrale, che afferma che la somma di un gran numero di variabili casuali indipendenti e identicamente distribuite segue una distribuzione normale, indipendentemente dalla forma della distribuzione originale.