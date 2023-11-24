Ovvero, quanto ci mette il mio programma a finire (più o meno) e quanto spazio occupa

## Complessità temporale: quanto ci mette?
Calcolare la complessità temporale vuol dire sapere quanto ci mette il mio programma a finire.
Si parla, generalmente, non di tempo, ma di "numero di istruzioni" o "step" se preferiamo.

Un programma di questo tipo
```python
istruzione1
isturzione2
istruzione3
```
esegue tre istruzioni, ed impiegherà un tempo (costante) di tre istruzioni.

### Basta contare le righe di codice quindi?
Col cazzo. Perché alcune istruzioni hanno il potere di fare tante istruzioni al loro interno

```python
for x in [1,2,3]:
	print(x)
```

in questo caso, questo programma ha un ciclo for, e la print viene fatta esattamente 3 volte. Sempre. Quindi anche in questo caso 3 istruzioni, Costanti! Perchè Indipendentemente se casca il mondo, se succede la terza guerra mondiale sempre tre istruzioni farà.

### Ma è sempre così?
NO
Consideriamo questo programma

```python
stringa=input("inserire una stringa")

for x in stringa:
	print(x)
```
in questo caso, c'è sempre un ciclo for, ma **sappiamo A PRIORI quante volte verrà fatta la print?** NO!!
Perchè il numero di volte che verrà fatta la print dipende dalla lunghezza della stringa.

Se l'utente inserisce la parola "ciao", per esempio...

```python
stringa="ciao" #4 lettere

for x in stringa: #4 volte viene eseguito il corpo del for (una per ogni lettera di ciao)
	print(x)
```

siccome "ciao" ha quattro lettere, la print, che è dentro al for, verrà fatta 4 volte.
Se la parola avesse avuto 8 lettere, il for sarebbe stato fatto quattro volte.
Se la parola avesse avuto 13 lettere, il for sarebbe stato fatto 13 volte.
Se la parola avesse avuto 19283721 lettere, il for sarebbe stato fatto 19283721.

Più generalmente, se la parola avesse avuto "n" lettere il for sarebbe stato fatto "n" volte.

#### Quindi si dice che il programma di prima impiega "n" passi, dove "n" è la grandezza dell'input.

Inoltre. non solo impiega n passi, fa n volte il corpo del for. CIOÈ:

##### PROGRAMMA1
```python
PROGRAMMA1
stringa #una stringa di "n" lettere

for x in stringa: #n volte viene eseguito il corpo del for 
	print(x)
	print("ciao")
	print("heylà")
```
3 istruzioni vengono eseguite n volte.
Quindi in totale questo programma impiega:
$$
T(programma)=3n
$$
3n: 3 istruzioni ripetute n volte.

##### PROGRAMMA2
```python

PROGRAMMA2
stringa #una stringa di "n" lettere

for x in stringa: #n volte viene eseguito il corpo del for 
	print(x)
	print("ciao")
	print("heylà")
	print("un'altra istruzione perchè si")
```

Se aggiungo un altra istruzione?
$$
T(programma)=4n
$$
quattro istruzioni ripetute n volte.

### Ma a noi, frega sapere se un programma impiega 3n, o 4n?
NO! o almeno, non ancora. Quello che veramente fa sprecare tempo non è quel "3" o quel "4", insomma, non è la parte **costante** della formula (3 e 4) il problema, ma la parte **VARIABILE**: cioè "n".
insomma, [[Complessità computazionale#PROGRAMMA1|programma1]] e [[Complessità computazionale#PROGRAMMA2|programma2]] impiegano più o meno lo stesso tempo "lineare" cioè il tempo che impiegano è l'ineare rispetto all'input dell'utente: Se l'utente fa un input lungo 10, il programma impiegherà PIU O MENO 10 passi, se l'utente inserisce un input lungo 100 il programma impiegherà PIU O MENO 100 passi, e così via.
### Come facciamo a dire "Il nostro programma impiega più o meno N"?
Con la notazione asintotica

$$
T(programma1)=T(programma2)=O(n)
$$

Con la notazione asintotica "o grande" le costanti vanno a farsi fottere. Non c'è differenza tra 

$$
O(3n +2)~~e~~O(12n+6)
$$
sono entrambe lineari e quindi tutte e due appartenenti a 

$$O(n)$$

## Si ok, ma come faccio a fare peggio di O(n)?

SI fa, si fa.

```python

stringa=input()

for x in stringa: #n volte
	for y in stringa: #n volte
		print(x)
		print(y)
```
2 istruzioni (le due print) vengono fatte n volte per il primo ciclo for (cioè 2n) e altre n volte per il secondo ciclo for!
quindi in totale
$$ O(2*n*n)=O(2n^2)=O(n^2) $$
(ricordiamo che nella notazione O grande le costanti non contano quindi il coefficiente moltiplicativo si toglie)

E se invece c'è una cosa del genere?


```python

stringa=input()

for x in stringa: #n volte
	for y in stringa: #n volte
		print(x)
		print(y)
		
for x in stringa:
	print("ciao")
```
beh in questo caso prima le due print vengono fatte n per n volte (quindi O(n^2)) POI, successivamente, l'altra print("ciao") viene fatta "n" volte.
Quindi:
$$ T(programma)=O(2n^2+n)=O(n^2+n)$$

Ma a questo punto questo, a chi appartiene? A O(n) o O(n^2)?
Ovviamente O(n^2), ma perchè?
Perché il povero "n" non conta niente se paragonato ad n alla seconda! Esattamente come la costante "2" di $$O(2*n)$$ non contava nulla e veniva eliminata. Quindi:
$$T(programma)=O(n^2+n)=O(n^2)$$
## E theta????

Si ok, ma theta chi è?
Possiamo vedere O(n) O(n^2) come questi due insiemi.
![[Pasted image 20231123201320.png]]
tutte le funzioni che appartengono a $O(n)$ appartengono anche a $O(n^2)$.
Cioè $O(n)$ è un sottoinsieme di $O(n^2)$, questo perché "o grande" è un limite superiore: cioè sono tutte le funzioni che ci mettono "al più $n^2$". Questo significa che tutte le funzioni che ci mettono $n$ sono un sottoinsieme di quelle che ci mettono $n^2$.

Cioè: le funzioni che ci mettono $O(n^2)$ potrebbero anche, in casi particolari metterci un po' di meno. Per esempio, prendiamo un programma che trova se due parole sono anagrammi.

```python
stringa1="cane"
stringa2="enac"

if len(stringa1)!=len(stringa2)#!!!!!

for i in stringa1:
	occorrenze_i=occorrenze(i,stringa1)
	for j in stringa2:
		istruzione1
		istruzione2
```

in questo caso ci sono due cicli for uno dentro l'altro, ma non **è detto che li svolga sempre!! Potrebbe anche metterci di meno il programma!** questo perché ho aggiunto una verifica all'inizio del programma, prima di iniziare verifico che le due stringhe siano della stessa lunghezza. Perché se fossero di lunghezza differente sarebbe inutile verificare che siano anagrammi no???

Quindi ok, il programma è $O(n^2)$ ma potrebbe anche metterci di meno!!!
#### Si ok, ma chi è $\Theta$?
$\Theta(n^2)$ sono tutti i programmi che ci mettono **ESATTAMENTE** $n^2$ istruzioni, e che non accade MAI che ci mettano di meno.
Il programma di prima, quindi:

```python
stringa1="cane"
stringa2="enac"

if len(stringa1)!=len(stringa2)#!!!!!

for i in stringa1:
	occorrenze_i=occorrenze(i,stringa1)
	for j in stringa2:
		istruzione1
		istruzione2
```
siccome è possibile che ci metta meno tempo di $O(n^2)$, visto che se le due stringhe hanno lunghezza differente non esegue i due cicli for, **allora non fa poarte di $\Theta(n^2)$** ma solo di $O(n^2).

Se invece gli avessi tolto la condizione iniziale:
```python
stringa1="cane"
stringa2="enac"

for i in stringa1:
	occorrenze_i=occorrenze(i,stringa1)
	for j in stringa2:
		istruzione1
		istruzione2
```
in questo caso non c'è più la condizione che permetterebbe al programma di interrompersi prima di fare i due cicli for. Quindi questo programma ci metterà SEMPRE ESATTAMENTE $n^2$ istruzioni, quindi:
$$T(programma)=\Theta(n^2)$$
Se ci piace vederlo da un punto di vista di insiemi $\Theta(n^2)$ è la regione compresa tra $O(n^2)$ e $O(n)$.

![[Pasted image 20231124105423.png]]
Cioè quella che ho evidenziato di rosso.

## Ricapitolando
1. La complessità temporale sono il numero di istruzioni che fa il nostro programma.
2. Se il numero istruzioni che fa il nostro programma dipende da cosa inserisce l'utente, allora non sappiamo quante istruzioni farà il nostro programma -> il tempo del nostro programma dipende dall'input $n$.
3. I programmi possono impiegare "al massimo" $n$ istruzioni, e quindi fanno parte di $O(n)$ oppure, **esattamente** $n$ istruzioni, in quel caso fanno parte di $\Theta(n)$
