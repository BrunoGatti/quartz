Un processo di Poisson è un tipo di processo stocastico, cioè una sequenza di variabili casuali che evolve nel tempo. Questo processo prende il nome dal matematico francese Siméon Denis Poisson, che contribuì significativamente allo sviluppo della teoria delle probabilità.

Un processo di Poisson è definito da alcune proprietà chiave:

1. **Conteggio di Eventi:** Il processo conta il numero di eventi che si verificano in intervalli di tempo fissati. Ad esempio, potrebbe essere il numero di chiamate ricevute in un call center in un'ora, il numero di auto che passano attraverso un casello autostradale in un giorno, o il numero di decadimenti radioattivi in un intervallo di tempo specifico.

2. **Eventi Indipendenti:** Si assume che gli eventi si verifichino in modo indipendente l'uno dall'altro. La probabilità che si verifichi un certo numero di eventi in un intervallo di tempo dipende solo dalla lunghezza dell'intervallo e dalla media del tasso di eventi.

3. **Stazionarietà:** Il tasso di eventi (la media del numero di eventi per unità di tempo) è costante nel tempo. Questa proprietà implica che il processo ha una certa regolarità statistica nel lungo periodo.

La distribuzione di probabilità del numero di eventi che si verificano in un intervallo di tempo fissato segue la distribuzione di Poisson, che è data da:

$$ P(X = k) = \frac{e^{-\lambda} \lambda^k}{k!} $$

Dove:
- $X$ è la variabile casuale che rappresenta il numero di eventi.
- $k$ è il numero specifico di eventi.
- $\lambda$ è il tasso di eventi, che rappresenta la media del numero di eventi in un intervallo di tempo fissato.

I processi di Poisson trovano applicazioni in una vasta gamma di campi, tra cui telecomunicazioni, biologia, economia, e in generale ovunque si verifichi un conteggio di eventi che avvengono in modo indipendente e con una certa regolarità.