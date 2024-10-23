---
publish: true
---

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
> per stampare l'indirizzo di memoria di una variabile, basta chiamare "&x", che sostanzialmente mi tira fuori l'indirizzo di memoria di x. Invece per stampare il contenuto di x basta stampare x (come abbiamo sempre fatto).
>Se non hai capito nulla forse è il caso di studiare un po' di roba sui puntatori [[puntatori| qui]]
>


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
>essendo un puntatore, se stampo "y" mi stamperà l'indirizzo di memoria della variabile puntata da y (in questo caso x). Invece se lo "deferenzio" usando l'operatore "*" quello che accade è che invece di farmi vedere l'indirizzo di memoria di x, mi fa vedere il valore contenuto nell'indirizzo di memoria di x, quindi 3.

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

#### Esercizio 4 easy
#malloc 

Alloca dinamicamente un array di 4 elementi ed assegnagli i valori che vanno da 1 a 4 con un ciclo for

>[!hint]- hint1: allocazione dell'array
>```C
>#include <stdio.h>
>#include <stdlib.h>
>int main(){
>	int *a = malloc(sizeof(int)*4);
>}
>```
>alloco dinamicamente un array di quattro elementi interi, per farlo serve la funzione malloc, contenuta nella libreria stdlib.h (ricordatevi di includerla se state usando la malloc). 
>La malloc prende in input la dimensione in byte da allocare, ovviamente questa è 4 volte la dimensione in byte di un intero (sizeof(int) per 4 volte).

>[!hint]- hint2: assegnamento all'array
>```C
>#include <stdio.h>
>#include<stdlib.h>
>
>int main(){
>	int *a=malloc(sizeof(int)*4);
>	for (int i=0;i < 4;i++){
>		a[i]=i+1; //assegno ad a il valore i+1 (cioè a[0]=1,a[1]=2,a[2]=3 e a[3]=4)
>		printf("%d",a[i]);
>	}
>}
>```

#### Esercizio 5 easy
#struct

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

Continua questo esercizio: da adesso in poi si alza la difficoltà: continua [[Lezione 8#esercizio 4 medium]]

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


>[!hint]- Hint 1
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

>[!hint]- Hint 2
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

>[!question]- Soluzione
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
#array 

dato questo programma 

```C
#icnlude <stdio.h>

int main(){
	int a[3]={1,2,3};
	int *b=a;
	printf("%d",b);
	
	printf("%d",b+2);
}
```
La prima printf stampa l'indirizzo di memoria di b. Se non siete convinti di questo andatevi a vedere gli esercizi easy sugli array.
Nel mio caso stampa l'indirizzo di memoria "1803711096"

Ma cosa stampa la seconda printf?
- l'indirizzo di memoria di b più 2 (es:  "1803711098")
- l'indirizzo di memoria di b più 2 x sizeof(int) 

>[!question]- Ma cosa stampa la seconda printf?
>Ovviamente la seconda, C, che è molto intelligente, capisce che b è un puntatore ad intero, e quindi quando va a sommare un numero all'indirizzo di memoria, sa già che deve moltiplicarlo per la size del tipo dell'elemento dell'array.
>Questo è anche il motivo per cui non possiamo mettere tipi diversi nell'array. Altrimenti il compilatore non saprebbe che fare in casi come questo se il tipo non fosse deciso a priopri

Ora che questa cosa è chiarita possiamo passare al vero esercizio.

Dato questo scheletro di programma, fai un ciclo for che stampa il contenuto di a, senza usare a, e SENZA USARE LE PARENTESI QUADRE. 
```C
#icnlude <stdio.h>

int main(){
	int a[3]={1,2,3};
	int *b=a;
}
```

>[!hint]- Hint 1
> ovviamente dobbiamo fare un ciclo for per scorrere tutto l'array, se non posso usare a, posso usare un puntatore agli elementi di a, cioè b.
> ```C
> #include <stdio.h>
> int main(){
> 	int a[3]={1,2,3};
> 	int *b=a;
> 	for (int i=0;i<3;i++){
> 		printf()// cosa devo stampare
> 	}
> }
> ```

>[!hint]- Hint 2
>Nella printf devo chiamare ad ogni iterazione di i, l'i-esimo elemento puntato da b.
>Per scrivere l'i-esimo elemento puntato da b, si scrive:
>```C
>printf("%d",b+i);
>```
>ma non basta stampare questo! perchè questo non stampa il VALORE dell'i-esimo elemento puntato da b, bensì stampa l'INDIRIZZO DI MEMORIA dell'i-esimo elemento puntato da b!
>Se solo ci fosse un modo per stampare il valore contenuto da un indirizzo di memoria....

>[!question]- Soluzione per australopitechi
>ovviamente il modo per stampare il valore contenuto da un certo indirizzo di memoria è l'operatore di deferenziazione (la stellina *). Quindi
>```C
>#include <stdio.h>
>int main(){
>	int a[3]={1,2,3};
>	int *b=a;
>	for (int i=0;i<3;i++){
>		printf("%d\n",*(b+i));
>	}
>}
>```

#### Esercizio 3 medium

Definisci una funzione che prende in input un array di interi, somma tutti i numeri dell'array e alloca un nuovo array composto da tanti "1" quanto è il risultato della somma precedente

ESEMPIO:
se l'array è
```C
a[3]=[2,5,1]
```
la sua somma è 8
Io voglio un array fatto da otto "1"
```C
risultato[8]=[1,1,1,1,1,1,1,1]
```

Parti dal seguente main

```C
//scrivi qui la funzione array_di_uno

int main(){
	// definisco gli array
    int a[3]={1,2,3};
    int *b=NULL;

	//chiamo la funzione array di uno che dovete programmare voi
    b=array_di_uno(a,3);

	//stampo l'array di uni
    printf("Array di uni:[ "); //queste sono solo lì per bellezza
    for(int i=0;i<sizeof(b)/sizeof(int);i++){
        printf("%d,",b[i]); //stampa l'i esimo elemento dell'array di uni
    }
    printf("]\n"); //queste sono solo lì per bellezza
}
```

>[!hint]- Hint1
>siccome non so a priori quanto grosso dovrà essere l'array me lo devo creare dinamicamente

>[!hint]- Hint 2
>La funzione che voglio prende in input un array, la sua dimensione, e mi restituisce in output un nuovo array fatto di "uni"
>```C
>int * array_di_uno(int * array, int dimensione_array){
>	//calcola la somma degli elementi dell'array in input
>	//alloca dinamicamente l'array
>	//assegna uno a tutto l'array
>}
>```

##### Soluzione 
```C
#include <stdio.h>
#include <stdlib.h>

int * array_di_uno(int* array, int dimensione_array){
    int somma=0;
    int * uni;
    for (int i=0;i< dimensione_array;i++){
        somma+=array[i];
    }
    //a questo punto somma contiene il valore di tutti gli elementi dell'array sommati, nel nostro esempio era 8

    //adesso voglio fare un array nuovo di 8 uni
    uni= malloc(sizeof(int)*somma);

    //una volta allocato l'array lo riempio di uni
    for (int i=0;i<dimensione_array;i++){
        uni[i]=1;
    }
    return uni;
}

int main(){
    int a[3]={1,2,3};
    int *b=NULL;
    b=array_di_uno(a,3);
    printf("Array di uni:[ ");

    for(int i=0;i<sizeof(b)/sizeof(int);i++){
        printf("%d,",b[i]);
    }

    printf("]\n");
}
```

#### Esercizio 4 medium

Questa è la continuazione dell'[[Lezione 8#Esercizio 5 easy|esercizio 5 easy]] Se non hai fatto quello, fallo prima di fare questo

>[!question]- Fai una funzione che prende in input un punto, ad esempio p2 e lo stampa così: "(1,7)"
>```C
>void stampa_punto(struct punto p){
>	printf("(%d,%d)",p.x,p.y);
>}
>```
<

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

##### Soluzione completa

```C
#include <stdio.h>
#include <stdlib.h>

struct punto{

    int x;
    int y;
};

struct punto punto_medio(struct punto p1, struct punto p2){
    struct punto punto_medio;
    punto_medio.x=(p1.x+p2.x)/2;
    punto_medio.y=(p1.y+p2.y)/2;
    return punto_medio;
}

void stampa_punto(struct punto p){
    printf("(%d,%d)",p.x,p.y);
}

int main(){
    struct punto p1;
    struct punto p2;

    p1.x=1;
    p1.y=2;

    p2.x=1;
    p2.y=8;

    stampa_punto(punto_medio(p1,p2));
}
```


## Hard

#### esercizio 1 hard
#array #puntatori #malloc
Fai un programma che prende in input dall'utente continuamente un intero fino a quando non riceve in input qualcosa di diverso.
Ogni intero che viene preso in input dall'utente deve essere inserito in un array.
Ogni volta che inserisci l'intero stampa l'array.

>[!hint]- Hint 1 la funzione che stampa l'array
>Una parte importante di questo programma è la funzione che stampa l'array, consiglio di cominciare da quella.
>```C
>#include <stdio.h>
>#include <stdlib.h>
>void stampaArray(int *array, int size){
>	printf("Array: ");
>	for (int i=0; i< size; i++){
>		printf("%d",array[i]);
>	}
>	printf("\n");
>}
>```

>[!hint]- Hint 2 il main: prendere l'intero in input
>Ovviamente serve un array, visto che non sappiamo quanti interi metterà l'utente è chiaro che non ci basta allocare l'array così
>```C
>int a[10];
>```
>questo perchè se poi l'utente decide di mettere 11 interi allora il programma si rompe.
>Quindi come possiamo fare? Semplice: allochiamo dinamicamente l'array (malloc), e quando finisce lo spazio, lo aumentiamo dinamicamente (realloc)
>```C
>int main(){
>	int * array= malloc(10*sizeof(int));
>	int dimensione_corrente_array=0;
>	int dimensione_massima_array=10;
>	printf("inserisci numeri interi. Inserisci un carattere non numerico per uscire.\n");
>	//...
>}
>```
>Cominciamo con le prime variabili: l'array, su cui alloco 10 elementi, e altre due variabili, una che tiene conto di quanti elementi sono nell'array, e l'altra che tiene conto di quanti ce ne possono entrare al massimo.
>In pratica quando la dimensione corrente supera la dimensione massima mi tocca riallocare l'array con altro spazio!
>Infine stampo un prompt per far capire all'utente cosa deve fare.
>```C
>while(1){
>	int input;
>	printf("inserisci un intero: ");
>	if (scanf("%d",&input)!=1){
>		printf("input non valido. Programma finito\n");
>		break;
>	}
>	//...
>}
>```
>Questo loop è infinito (while(1)) chiaramente l'utente può inserire quanti interi vuole, il programma si interrompe nel caso in cui inserisco un non intero, per uscire dal loop sto usando un break. 
>Con la scanf prendo in input l'intero, e ora che ci faccio?
>Lo metto in un array!

>[!hint]- Hint 3: inserire l'intero nell'array
>adesso la parte succosa. Non possiamo inserire e basta l'intero nell'array! dobbiamo prima verificare che l'array non sia pieno! se è pieno va aumentata la memoria
>```C
>while(1){
>	//input e tutta la parte vista prima
>	if(dimensione_corrente_array) == dimensione_massima_array){
>		dimensione_massima_array += 5;
>		array = realloc(array, 10*sizeof(int));
>	}
>}
>```
>fatto questo aggiungiamo l'intero all'array
>```C
>//prosegue dalla parte di prima
>array[dimensione_corrente_array] =input;
>dimensione_corrente_array++;
>stampaArray(array, dimensione_corrente_array);
>```
>

### soluzione completa da copiare e incollare per zombie
```C
#include <stdio.h>
#include <stdlib.h>

void stampaArray(int *array, int size) {
    printf("Array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
}

int main() {
    int *array = malloc(10 * sizeof(int));
    int dimensione_corrente_array = 0;
    int dimensione_massima_array=10;

    printf("Inserisci numeri interi. Inserisci un carattere non numerico per uscire.\n");
    while (1) {
        int input;
        printf("Inserisci un numero intero: ");
        if (scanf("%d", &input) != 1) {
            printf("Input non valido. Uscita dal programma.\n");
            break;
        }
        if (dimensione_corrente_array == dimensione_massima_array) {
            // Rialloca l'array se la dimensione massima è raggiunta
            dimensione_massima_array += 5;
            array = realloc(array, 10 * sizeof(int));
        }
        // Aggiunge il numero all'array e incrementa la dimensione
        array[dimensione_corrente_array] = input;
        dimensione_corrente_array++;
        // Stampa l'array
        stampaArray(array, dimensione_corrente_array);
    }
    // Libera la memoria allocata dinamicamente
    free(array);
    return 0;
}
```




