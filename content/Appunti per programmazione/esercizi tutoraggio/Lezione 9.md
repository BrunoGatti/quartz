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
