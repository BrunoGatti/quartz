---
publish: true
---

Le struct sono un modo per definire "strutture" in C.
Che significa?
Praticamente noi in C siamo "legati" ai tipi di dato standard che abbiamo visto finora. Gli interi, i float, i char etc..
Ma se noi volessimo definire qualcosa di diverso?
Per esempio. Supponiamo di voler definire un punto sul piano cartesiano.
![[Pasted image 20231211094957.png]]
Una cosa del genere ad esempio.
Vorremmo definire due punti: il Punto A(1,1) ed il punto B(5,4).
I punti sul piano cartesiano sono fatti da coppie di numeri.
Ovviamente non c'è un dato già fatto e finito in C che ci rappresenta un punto, ce lo dobbiamo fare noi!

```C
struct Punto{
	float x;
	float y;
};
```
Ho definito una nuova struttura: il punto.
Il punto è fatto da due scalari: x ed y. E così va bene.

Ok però non abbiamo definito I punti A e B, abbiamo semplicemente definito che cos'è un punto in generale.

Definiamo A e B
```C
struct Punto{
	float x;
	float y;
};

int main(){
	struct Punto A;
	struct Punto B;
}
```
Per definire A e B dobbiamo dire "A e B sono strutture chiamate punto"
```C
struct Punto A
```
Bene, adesso però i punti sono vuoti A( , ) e B( , ). Li dobbiamo riempire con i relativi numeri.

```C
struct Punto{
	float x;
	float y;
};

int main(){
	struct Punto A;
	struct Punto B;

	A.x=1;
	A.y=1;

	B.x=5;
	B.y=4;
}
```
Chi di voi già conosce la programmazione ad oggetti conoscerà già questo tipo di sintassi.
```C
A.x=1;
```
mi sta dicendo "prendi la struttura A, nella struttura A trovi una variabile che si chiama x, a quella variabile assegna il valore 1".

Adesso abbiamo definito i nostri due punti sul piano cartesiano:
![[Pasted image 20231211094957.png]]

Adesso potremmo voler fare qualcosa di matematico tipo calcolare il punto medio tra A e B.
Ricordo a tutti che il punto medio si trova facendo le medie delle coordinate x e la media delle y.

Cioè:
$$
P~medio=(\frac{x_A+x_B}{2},\frac{y_A+y_B}{2})
$$
Quindi possiamo fare così
```C
#include<stdio.h>

struct Punto{

    float x;
    float y;
};

int main(){
    struct Punto A;
    struct Punto B;
    struct Punto Medio;

    A.x=1;
    A.y=1;

    B.x=5;
    B.y=4;

    Medio.x=(A.x+B.x)/2;
    Medio.y=(A.y+B.y)/2;

    printf("(%f,%f)",Medio.x,Medio.y);
}
```

Bene adesso alcunni esercizi: [[Lezione 9|qui]].

## Allocare dinamicamente una struttura