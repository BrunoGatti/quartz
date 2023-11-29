Lo stimatore di massima verosimiglianza (Maximum Likelihood Estimator, MLE) è un metodo utilizzato nella statistica per ottenere stime dei parametri di un modello statistico. L'approccio della massima verosimiglianza si basa sulla massimizzazione della funzione di verosimiglianza, che misura quanto è probabile osservare i dati campionari dati i parametri del modello.

Per comprendere meglio il concetto di stimatore di massima verosimiglianza, ecco i passi chiave coinvolti:

1. **Definizione della Funzione di Verosimiglianza ($L$):**
   - La funzione di verosimiglianza è una misura della probabilità di osservare i dati campionari dato un insieme specifico di parametri del modello. Viene spesso indicata con $L(\theta \,|\, \text{dati})$, dove $\theta$ rappresenta i parametri.

2. **Logaritmo della Funzione di Verosimiglianza ($\ell$):**
   - Per semplificare i calcoli, è comune lavorare con il logaritmo naturale della funzione di verosimiglianza, notato come $\ell(\theta)$.

3. **Massimizzazione della Funzione di Verosimiglianza:**
   - L'obiettivo principale è trovare il set di parametri $\theta$ che massimizza la funzione di verosimiglianza (o il suo logaritmo). Questo può essere fatto utilizzando metodi matematici, come la derivazione e l'uguaglianza a zero della derivata rispetto ai parametri.

4. **Stima dei Parametri:**
   - Una volta massimizzata la funzione di verosimiglianza, otteniamo gli stimatori dei parametri del modello, indicati come $\hat{\theta}_{\text{MLE}}$.

5. **Proprietà degli Stimatori di Massima Verosimiglianza:**
   - Gli stimatori di massima verosimiglianza godono di alcune proprietà desiderabili, tra cui l'efficienza asintotica e la consistenza.

Per esemplificare, supponiamo di avere un campione casuale da una distribuzione normale con media $\mu$ e deviazione standard $\sigma$. Gli stimatori di massima verosimiglianza per $\mu$ e $\sigma$ saranno la media campionaria $\bar{X}$ e la deviazione standard campionaria $S$.

In breve, gli stimatori di massima verosimiglianza costituiscono un approccio potente e ampiamente utilizzato nella statistica per ottenere stime dei parametri del modello sulla base dei dati osservati.