Per ora abbiamo sempre dichiarato le variabili e gli array a priori. Ad esempio, se vogliamo definire un array, dobbiamo sempre e comunque dichiarare prima la sua dimensione:

```C
int a[3];
```
nonostante l'array sia ancora vuoto, il compilatore ha riservato per questo array uno spazio di memoria sullo stack di tre elementi interi.
Quindi quando andiamo a fare assegnamenti tipo

```C
a[0]=1;
a[1]=2;
a[2]=3;
```
non ci sarà nessun problema.
Ma se proviamo a fare
```C
a[3]=4;
```
Il problema ci sarà eccome!

![[Pasted image 20231211120758.png]]
se proviamo ad eseguire del codice del genere si incazza. Giustamente.

Quindi come facciamo se vogliamo, durante il nostro programma modificare la dimensione del nostro array?
Dobbiamo allocare MANUALMENTE la memoria.
Per fare questo si usa la funzione "malloc".
Malloc è una funzione della libreria <stdlib.h> che alloca una zona di memoria e ne restituisce il puntatore.
Ad esempio.

>[!nota] allochiamo dinamicamente una variabile intera

```C
#include<stdlib.h>
#include<stdio.h>

int main(){
	int* x = malloc(sizeof(int))
	*x=3;
	printf("%d",*x);
	free(x);
}
```
Spieghiamo questo codice passo per passo
#### Primo passo: allocare la memoria
innanzitutto vogliamo allocare la memoria per un intero.
Per farlo chiamiamo la funzione malloc. 
Malloc vuole sapere quanto deve allocare, nel nostro caso, dobbiamo allocare un intero, quindi gli diciamo di allocare "la dimensione in byte di un intero" cioè "sizeof(int)".
Una volta allocata la memoria, la malloc restituisce il puntatore a quella zona di memoria. 
Ma attenzione : 

>[!danger] restituisce il puntatore alla memoria!

Quindi non possiamo assegnare un puntatore ad una variabile intera, ma ad un puntatore ad una variabile intera.
Se non sei ferrato con i puntatori studia [[puntatori|questo]].

#### Passo 2 e 3: assegnamo il valore 3 alla nuova memoria allocata
A questo punto assegnamo il valore 3 alla nuova zona di memoria allocata, per farlo usiamo il puntatore, deferenziandolo (\*x).
Ricorda deferenziare significa "seguire la freccia", quindi x è un puntatore a un intero, e \*x restituisce l'intero puntato da x.

Poi stampiamo il valore

#### Passo 4: free

>[!danger] SEMPRE SEMPRE SEMPRE liberare la memoria allocata dinamicamente quando non la si usa più.

La "free(x)" dealloca la sezione di memoria dinamica puntata da x. Ricordatevi di farlo sempre altrimenti il vostro programma terrà lì quella memoria fino alla fine dell'esecuzione del programma. Questo approccio di gestione manuale della memoria può portare ad una gestione molto efficiente della memoria, ma anche a delle catastrofi inimmaginabili se non vi ricordate di deallocare.
Quindi: deallocate.

## Un esercizio in cui è necessario allocare dinamicamente la memoria:

[[Lezione 8#esercizio 1 hard]]

