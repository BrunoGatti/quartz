Il teorema di Cramér-Rao è un risultato fondamentale nella teoria delle stime statistiche. Esso fornisce un limite inferiore alla varianza di qualsiasi stimatore non distorto di un parametro di una distribuzione di probabilità.

### Principali Punti del Teorema di Cramér-Rao:

1. **Stimatori Non Distorti:**
   - Il teorema di Cramér-Rao si applica solo agli stimatori non distorti, cioè agli stimatori la cui media campionaria coincide con il valore del parametro che stanno cercando di stimare.

2. **Varianza Minima:**
   - Il teorema dimostra che, sotto certe condizioni, la varianza di qualsiasi stimatore non distorto è sempre maggiore o uguale all'inverso dell'informazione di Fisher, che è una misura della quantità di informazione contenuta nei dati rispetto al parametro.

3. **Informazione di Fisher:**
   - L'informazione di Fisher ($I(\theta)$) misura la sensibilità della funzione di verosimiglianza rispetto al parametro $\theta$. Maggiore è l'informazione di Fisher, più precisione è possibile ottenere nella stima del parametro.

4. **Espressione Matematica:**
   - Se $T$ è uno stimatore non distorto per il parametro $\theta$, allora la varianza di $T$ soddisfa l'ineguaglianza di Cramér-Rao:
     $$ \text{Var}(T) \geq \frac{1}{I(\theta)} $$
   - L'uguaglianza si verifica solo quando $T$ è uno stimatore efficiente, ovvero quando raggiunge il limite imposto dal teorema.

### Applicazioni e Importanza:

- Il teorema di Cramér-Rao è ampiamente utilizzato per valutare la precisione degli stimatori e per determinare se uno stimatore è efficiente (ossia se raggiunge il limite di varianza imposto dal teorema).

- Questo teorema è particolarmente rilevante nell'ambito dell'estimazione di massima verosimiglianza (MLE), dove si cerca di massimizzare la funzione di verosimiglianza per ottenere stimatori non distorti e efficienti.

- Il teorema di Cramér-Rao è un importante strumento nella valutazione delle prestazioni degli stimatori, ma richiede che alcune condizioni siano soddisfatte, come la regolarità della famiglia della distribuzione di probabilità e la possibilità di scambiare derivazione e integrazione.