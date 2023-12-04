## Easy

#### Esercizio 1 easy
#puntatori
Dato ill seguente scheletro di programma:

```C
#include <stdio.h>

int main(){
	int x=5;
}
```

> [!question]- stampa l'indirizzo di memoria di x, e stampa il valore di x.
> ```C
> #include <stdio.h>
> int main(){
> 	int x=5;
> 	printf(" indirizzo: %d, valore: %d",&x,x);
> }
> ```


#### Esercizio 2 easy
#puntatori
Dato il seguente scheletro di programma:
```C
#include <stdio.h>

int main(){
	int x = 3;
	int *y = &x;
}
```

>[!question]- stampa il valore e l'indirizzo di memoria di x, SENZA CHIAMARE DIRETTAMENTE LA VARIABILE X
>```C
>int main(){
>	int x =3;
>	int *y= &x;
>	printf("indirizzo: %d, valore %d", y, *y);
>}
>```

#### Esercizio 3 easy
#array
Dato il seguente scheletro di programma 

```C 
#include <stdio.h>

int main(){
	int a[4]={1,2,3,4};
	int *b;
	
	b=a;
}

```

>[!question]- Questa cosa genera errore?
>No, infatti a, contiene l'indirizzo di memoria del primo elemento, quindi assegnare a b il valore di a significa assegnargli l'indirizzo di memoria del primo elemento

>[!question]- cosa succede se stampo b?
>```C
>int main(){
>	int a[4]={1,2,3,4};
>	int *b=a;
>	printf("%d",b);
>}
>```
>Succede che stampo l'indirizzo di memoria del primo elemento dell'array.

>[!question]- stampa il quarto elemento dell'array a, usando b.
>
>```C
>#include <stdio.h>
>int main(){
>	int a[4]={1,2,3,4};
>	int *b=a;
>	printf("%d\n",b[3])
>}

## Medium
#### Esercizio 1 medium
#puntatori
dato il seguente scheletro di programma

```C
#include <stdio.h>

int main(){
	float pi=3.14;
	
	//aumenta
	
	printf("%f\n",pi);
}
```

Definisci la funzione "aumenta". SENZA MODIFICARE LE ALTRE PARTI DEL MAIN (IN PARTICOLARE LA PRINT).
"aumenta" prende in input un numero float e un intero, e aumenta il primo numero di tanto quanto specificato dall'intero. In questo caso, quindi dovrebbe aumentare il valore di "pi" di 1.

#### esercizio 2 medium
#array

>[!question]- Hint 1
>
>Dobbiamo definire una funzione: che prende in input un float e un intero.
>```C
>#include <stdio.h>
>float aumenta(float num1, int num2){
>	return num1+num2;
>}
>int main(){
>	float pi=3.14;
>	aumenta(pi,1);
>	printf("%f\n",pi);
>}
>```
>Ma attenzione! Cosiì non va bene! Perchè?...

>[!question]- Hint 2
>Non va bene perché la funzione non sta veramente modificando la variabile pi!
>Quello che sta facendo è solamente prenderne il valore, andate su python tutor per convincervene.
>Quindi quello che vogliamo sapere, è dov'è ESATTAMENTE la variabile pi. Ergo **gli dobbiamo passare il suo indirizzo di memoria, non il suo valore**
>```C
>#include <stdio.h>
>float aumenta(float * puntatore_al_numero1, int numero2){
>	//questo lo fate voi
>}
>int main(){
>	float pi=3.14;
>	//aumenta; mi raccomando fate attenzione a cosa gli passate a questa funzione
>	printf("%f\n",pi);
>}
>```

>[!question]- Soluzione per caproni
>```C
>#include <stdio.h>
>float aumenta(float * puntatore_a_num1, int num2){
>	*puntatore_a_num1 += num2;
>}
>int main(){
>	float pi=3.14;
>	aumenta(&pi, 1);
>	printf("%f\n",pi);
>}
>```
>Cioè: la funzione aumenta, prende il puntatore al primo numero, in modo tale che so dove sta esattamente. E al valore puntato da quel puntatore (nel nostro caso pi greco) ci aggiungo 1.
>Quando chiamo la funzione "aumenta" non posso passargli il valore di pi greco! Devo passargli l'indirizzo di memoria!!!!! (&pi) Questo perchè se non gli do l'indirizzo di memoria di pi, il puntatore (il pirmo argomento della funzione aumenta) non sa dove andarsela a cercare l'indirizzo di memoria di pi greco!
>Dentro la funzione aumenta: ovviamente adesso "puntatore_a_num1" non è il valore vero e proprio che voglio aumentare, bensì un PUNTATORE, al valore che voglio aumentare, quindi se ho il puntatore ad un valore, e voglio accedere al valore, come faccio?
>Si usa il cosidetto "operatore di deferenziazione" (la stellina) *puntatore_a_num.


#### Esercizio 2 medium
