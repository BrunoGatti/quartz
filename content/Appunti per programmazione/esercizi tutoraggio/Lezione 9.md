## Easy
### Esercizio 1 easy
#struct

Se non sai cos'è una struct vai [[Struct|qui]]

>[!question]- fai una struct che rappresenti un punto
>```C
>struct punto{
>	int x;
>	int y;
>};
>```
>ovviamente come sappiamo un punto è fatto da una coordinata x e una y.
>ricordatevi di mettere il ; alla fine della graffa dopo la struct

>[!question]- nel main dichiara due punti: (1,2) e (1,7)
>```C
>struct punto{
>	int x;
>	int y;
>};
>int main(){
>	struct punto p1;
>	struct punto p2;
>	
>	p1.x=1;
>	p1.y=2;
>	
>	p2.x=1;
>	p2.y=7;
>}
>```

##### Continua questo esercizio [[Lezione 9#Esercizio 2 Easy|qui]].
#### Esercizio 2 Easy
La vostra prima funzione con le struct:
Ovviamente le regole per fare una funzione sono sempre le stesse: Chiedetevi cosa dovete prendere in input e che cosa volete come output. In questo caso è una funzione che stampa qualcosa, prendendo in input un punto...
>[!question]- Fai una funzione che prende in input un punto, ad esempio p2 e lo stampa così: "(1,7)"

>[!hint]- Come definisco la funzione?
>Siccome è una funzione che stampa qualcosa, non dovrà ritornare nulla! Quindi è una funzione void.
>```C
>void stampa_punto(qui_cosa_metto?){}
>```

>[!hint]- Tra le parentesi cosa metto???
>Tra le parentesia ci va l'input. Il nostro input è un punto perchè la nostra funzione prende in input un punto e stsampa il contenuto.
>```C
>void stampa_punto(struct Punto p){}
>```

>[!note]- Soluzione
>```C
>void stampa_punto(struct punto p){
>	printf("(%d,%d)",p.x,p.y);
>}
>```

##### Continua questo esercizio [[Lezione 9#Esercizio 1 medium|qui]]

#### Esercizio 3 easy

Allocare dinamicamente una struct: può succedere di voler allocare dinamicamente una struct.
Per esempio:

>[!question]- usando malloc alloca dinamicamente un punto

Se non sai dove mettere le mani puoi studiare questa roba:
1. [[allocazione dinamica della memoria in C]]
2. [[Struct]]

>[!hint]- Usa la malloc: questo è solo un hint, non c'è soluzione
>Andiamo a capire: noi stiamo allocando una regione di memoria grande come la struttura punto.
>Per dire questo dobbiamo dire a malloc di allocare "sizeof(struct Punto)", cioè "alloca una regione di memoria grande quanto al struttura punto".
>Una volta fatto ciò la malloca restituisce un puntatore, si ma un puntatore a cosa? Un puntatore ad un punto! Quindi dobbiamo definire un puntatore ad un punto "struct Punto * puntatore_a_un_punto" e quel puntatore deve contenere il valore di ritorno della malloc

>[!hint]- Usa la malloc: la malloc vuole sapere quanto allocare e restituisce un puntatore...
>```C
>#include<stdlib.h>
>struct Punto {
>	float x;
>	float y;
>}
>
>int main(){
>	struct Punto * puntatore_a_un_punto = malloc(sizeof(struct Punto));
>}
>
>```

##### Continua l'esercizio [[Lezione 9#Esercizio 3 medium| qui]]

#### Esercizio 4 easy

Stringhe!
Okay, come avete visto a lezione con rossi le stringhe si dichiarano come un array di caratteri.

>[!question]- Dichiara una stringa che contiene la parola "python", si può fare in due modi. Falli entrambi

Se non sai di cosa sto parlando e vuoi ripassare studia [[Stringhe in C| questo]].

>[!soluzione]-
>```C
>#include <stdio.h>
>#include <stdlib.h>
>
 >int main(){
>  char str1[6]={'p','y','t','h','o','n'};
>  char str2[6]="python";
>
>  printf("stringa 1:%s\tstringa 2:%s\n",str1,str2);
>}
>```


 

 
```C
#include <stdio.h>
#include <stdlib.h>

int main(){
    char str1[6]={'p','y','t','h','o','n'};
    char str2[6]="python";

    printf("stringa 1:%s\tstringa 2:%s\n",str1,str2);
}
```
## Medium
#### Esercizio 1 medium

>[!question]- Fai una funzione che presi due punti calcola il punto medio dati due punti
>```C
>struct punto punto_medio(struct punto p1, struct punto p2){
>	struct punto punto_medio;
>	punto_medio.x = (p1.x+p2.x)/2;
>	punto_medio.y = (p1.y+p2.y)/2;
>	return punto_medio;
>}
>```
>Questa funzione a dirla tutta ha un difetto, sapresti dire quale, sapresti renderla migiore??

>[!question]- rendi migliore la funzione data come soluzione alla domanda prima

##### Continua l'esercizio qui

#### Esercizio 2 medium
>[!question] Fai una funzione che prende due punti e restituisce la distanza tra due punti

Per chi non si ricordasse la formula per calcolare la distanza fra due punti è:
$$
Distanza(A,B) = \sqrt{(x_A-x_B)^2+(y_A-y_B)^2}
$$
Per fare la radice quadrata  e la potenza dovete usare la funzione "sqrt" e "pow" che sono incluse nella libreria <math.h>, esempio:

```C
#include <math.h>
#include<stdio.h>

int main(){
	printf("due alla terza è: %f\n", pow(2,3));
    printf("la radice di 25. è: %f\n", sqrt(25));
}
```

>[!hint]- come definisco la funzione?
>La funzione prende in input due punti, e restituisce una distanza, quindi un numero.
>```C
>float distanza(struct Punto A, struct Punto B){
>	
>}```

>[!soluzione]-
>```C
>float distanza(struct Punto A, struct Punto B){
>    float dist;
>    dist= sqrt(pow(A.x-B.x,2)+pow(A.y-B.y,2));
>    return dist;
>}

#### Esercizio 3 medium

Questo esercizio è il continuo di questo eserecizio: [[Lezione 9#Esercizio 3 easy]]. Fai prima quello se ancora non l'hai fatto.

Adesso abbiamo allocato dinamicamente un punto.
Fico, ma il punto è vuoto.
Voglio assegnare al punto dei valori, facciamo P(1,3)
E vorrei stampare questi valori per essere sicuro che il punto li abbia effettivamente.

A questo punto dovreste avere il seguente main:
```C
#include<stdlib.h>
#include<stdio.h>
struct Punto {
    float x;
    float y;
};

int main(){
    struct Punto * puntatore_a_un_punto = malloc(sizeof(struct Punto));
}
```

>[!question]- assegna al punto i valori (3,4)

Per assegnare i valori 3 e 4 dobbiamo accedere alla struttura tramite il puntatore. Se non hai idea di come si faccia: leggi qui [[allocazione dinamica della memoria in C#Accedere ad una struttura allocata dinamicamente]]

>[!solzione]- soluzione
>```C
>#include<stdlib.h>
>#include<stdio.h>
>struct Punto {
>    float x;
>    float y;
>};
>
>int main(){
>    struct Punto * puntatore_a_un_punto = malloc(sizeof(struct Punto));
>    puntatore_a_un_punto->x = 3;
>    puntatore_a_un_punto->y = 4;
>    printf("p.x=%f\tp.y=%f\n",puntatore_a_un_punto->x,puntatore_a_un_punto->y);
>}
>```

