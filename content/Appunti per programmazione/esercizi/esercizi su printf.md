Printf è la prima funzione che si impara.
Stampa cose a video.

## esercizio 1

Fai un programma che stampa "hello world"

```C
#include<stdio.h>

int main(){
	printf("hello world\n");
}
```
### Breakdown dell'esercizio:
La funzione "main" è la funzione principale del programma (da qui il nome), tutto quello che è scritto nel main verrà eseguito, se scrivete la roba fuori dal main NON VERRA ESEGUITA (con qualche eccezione ma per ora non vi preoccupate).

La "printf" stampa quello che avete scritto tra le virgolette, "\n" è il carattere "new line" praticamente va a capo. Provate a vedere cosa succede se lo togliete.

NOTA: se non scrivete "#include <stdio.h>" la funzione printf non funziona! Questo perchè la funzione printf non è incorporata nel C, si trova in una libreria: "standard input output", per gli amici "stdio.h". Per usare la printf dovete chiamare questa libreria. Ci sono una serie di buone ragioni per cui questa funzione (insieme ad altre) che potrebbe sembrare fondamentale, si trova in una libreria. Se volete ne parliamo.

Notate che alla fine dell'istruzione c'è un punto e virgola. Questi vanno sempre messi alla fine di ogni istruzione a linea singola (single line instruction). Provate a vedere cosa succede se non mettete il ";".

## Esercizio 2
Stampa il numero 3.

```C
#include <stdio.h>

int main(){
	int x=3;
	printf("stampo il numero %d \n",x);
}
```
### Breakdown dell'esercizio

Con 
```C
int x=3; 
```

Abbiamo definito una variabile che contiene il valore 3.
**Abbiamo dovuto definire anche il tipo che la variabile avrebbe dovuto contenere**, scrivendo "int" prima del nome della variabile abbiamo detto al compilatore che quella variabile prenderà solo ed esclusivamente interi!

Nella printf, a questo punto dobbiamo stampare il valore della variabile x.
Per farlo si chiama la printf, e si scrive tra virgolette quello che si vuole stampare. Quando si deve stampare il valore di una variabile si usa, quello che si chiama "place holder". Un "segnaposto" che dice "voglio stampare il valore di una variabile", la variabile da cui prendere il valore è specificata dopo la virgola.

"%d" indica che il valore che si vuole andare a prendere è un intero. Per una lista completa dei placeholder per ogni tipo diverso: [qui](https://3.bp.blogspot.com/-T1okIavu_qI/VaXFdw8rxEI/AAAAAAAABIQ/cSzRjyObjBk/s1600/ph2.png)
## Esercizio 3
fai un programma che stampa il valore di 2 variabili
```C
int main(){
	int x=3;
	int y=5;
	printf("il valore della x è %d, mentre il valore della y è %d",x,y);

}
```
In questo caso ci sono due placeholder, printf li prende uno alla volta dalle variabili specificate dopo la virgola (in questo caso, prima x e poi y).