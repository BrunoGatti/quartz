La verosimiglianza è una misura della probabilità di ottenere le osservazioni specifiche che hai, data una particolare ipotesi sui parametri del modello.

Per essere più precisi:

- **Verosimiglianza (Likelihood):** Indica quanto è probabile che le osservazioni siano generate dai parametri specificati nell'ipotesi. È la probabilità condizionata di osservare i dati dati i parametri.

- **Formula della Verosimiglianza:** Se denotiamo i dati come $X$ e i parametri come $\theta$, la verosimiglianza è spesso indicata come $L(\theta | X)$. In altre parole, è la probabilità di ottenere $X$ dato che il parametro è $\theta$.

Quando si esegue un **test d'ipotesi**, il processo può coinvolgere la comparazione delle verosimiglianze tra l'ipotesi nulla ($H_0$) e l'ipotesi alternativa ($H_1$). Una procedura comune è confrontare il rapporto di verosimiglianza, noto come il rapporto di verosimiglianza (likelihood ratio), che è il rapporto tra la verosimiglianza massima sotto l'ipotesi $H_1$ e l'ipotesi $H_0$. Questo può essere utilizzato per decidere quale ipotesi è più supportata dai dati.

In breve, la verosimiglianza gioca un ruolo chiave nel processo di stima dei parametri e nei test d'ipotesi, aiutando a valutare quanto i dati siano compatibili con le diverse ipotesi sui parametri del modello.

## Test d'ipotesi: rifiutare l'ipotesi nulla, esempio pozione magica

Un problema ricorrente è determinare quale dovrebbe essere l'ipotesi nulla (H0) in una situazione specifica. Ad esempio, consideriamo un ricercatore che ha sviluppato un nuovo farmaco per trattare una particolare malattia. Esiste già un farmaco "vecchio" che ha una probabilità di successo $p = 1/2$ nel curare i pazienti, e il ricercatore desidera condurre un test d'ipotesi per dimostrare che il suo farmaco è superiore al vecchio. In questo contesto, deve decidere se impostare l'ipotesi nulla come $H0: p > 1/2$ (l'ipotesi che desidera "dimostrare") o $H0: p < 1/2$ (l'ipotesi che desidera "rifiutare").

Immaginiamo che il ricercatore testi il suo farmaco su $n$ pazienti e registri la proporzione $ˆp$ di quelli guariti. La scelta di $H0$ influenzerà come il ricercatore interpreta i risultati del test. Ad esempio, se osserva 51 pazienti guariti su 100, questo risultato sarebbe coerente con $H0: p > 1/2$ e l'ipotesi sarebbe accettata. Tuttavia, uno scettico potrebbe sostenere che questo risultato potrebbe essere attribuito al caso e che il vero $p$ potrebbe essere inferiore a $1/2$.

Per essere ragionevolmente sicuro che il vero $p$ sia maggiore di $1/2$, è necessario poter rifiutare l'ipotesi che $p \leq 1/2$ con sicurezza. Ad esempio, se la probabilità di osservare $ˆp \geq 0.59$ sotto l'ipotesi $p = 1/2$ è inferiore a $0.05$, allora un test del tipo "si rifiuta $p \leq 1/2$ se $ˆp \geq 0.59$" avrà un livello di significatività $\alpha < 0.05$. In tal caso, si può respingere l'obiezione secondo cui "forse il vero $p$ è inferiore a $1/2$ e il risultato osservato è dovuto al caso".

Concludendo, di solito si sceglie come ipotesi nulla quella che si è interessati a rifiutare. Quando si rifiuta l'ipotesi nulla, spesso si afferma di aver trovato una differenza "statisticamente significativa al livello $\alpha$".