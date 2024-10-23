---
publish: true
---

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
>In questa soluzione definisco due stringhe cioè due array di char di size 6.
>Il metodo di assegnamento è diverso (nel primo assegno un carattere per volta nel secondo tutto insieme) ma il risultato è lo stesso.

##### Per continuare gli esercizi con le stringhe vai [[Lezione 9#Esercizio 4 medium]]
 

 
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

#### Esercizio 4 medium

Ora che abbiamo allocato due stringhe vorrei una funzione che prese due stringhe le concatena una all'altra.

Purtroppo questo esercizio l'ha già fatto rossi oggi. 

Quindi vi tocca un esercizio più difficile: Fai una funzione che prende in input 3 stringhe, e restituisce una stringa che è la concatenazione di queste tre stringhe dat questo main:

```C
int main(){
	char *a="ciao ";
	char *b="come ";
	char *c="va?";
	printf("%s",concatena(a,b,c));
}
```

##### Soluzione guidata passo per passo

innanzitutto dobbiamo andare a capire il main.
```C
#include<stdio.h>

int main(){
	char *a="ciao ";
	char *b="come ";
	char *c="va?";
	printf("%s",concatena(a,b,c));
}
```
In questo main definisco tre stringhe, e vado a stampare la loro concatenazione.
Per fare questo devo definire la funzione "concatena".

La funzione concatena prende in innput tre stringhe (quindi tre puntatori a caratteri) e restituisce una stringa (quindi un puntatore  a char)
```C
char * concatena(char * str1,char * str2, char * str3){}
```

Adesso andiamo a vedere che cosa deve fare questa funzione.
Per prima cosa deve.

```C
char * concatena(char * str1,char * str2, char * str3){
	//definisce una nuova stringa (quella concatenata)

	//inserisce nella nuova stringa i caratteri di stringa 1

	//inserisce nella nuova stringa i caratteri di stringa 2

	//inserisce nella nuova stringa i caratteri di stringa 3
	
}
```

Questo è lo scheletro della funzione.
Andiamo a vedere come farlo

##### Definire una nuova stringa
La nuova stringa di output può essere definita staticamente?
Tipo:
```C
char output[10];
```
NOPE. Perchè non conosciamo a priori quanto deve essere lunga.
Quindi prima devo capire quanto devo farla lunga, e poi, una volta capito, devo allocare dinamicamente la stringa.

```C
char * concatena(char * str1,char * str2, char * str3){
//definisce una nuova stringa (quella concatenata)
	// trovo la lunghezza della stringa di output
	int lunghezza_totale = strlen(str1)+strlen(str2)+strlen(str3);
	//alloco la nuova stringa di output
	char * stringa_concatenata=malloc(sizeof(char)*lunghezza_totale);


	//inserisce nella nuova stringa i caratteri di stringa 1

	//inserisce nella nuova stringa i caratteri di stringa 2

	//inserisce nella nuova stringa i caratteri di stringa 3
	
}
```

Okay, quindi quello che ho fatto è stato trovarmi la lunghezza totale sommando la lunghezza di ogni singola stringa. Per farlo ho chiamato la funzione strlen() che è una funzione della libreria <string.h> (ricordatevi di includerla)

##### Inserire i caratteri nella stringa di output
Per fare questo basta iterare su ogni singolo carattere di ogni stringa ed aggiungerlo alla stringa di output.
Lo facciamo con un ciclo for

```C
char * concatena(char * str1,char * str2, char * str3){
//definisce una nuova stringa (quella concatenata)
	// trovo la lunghezza della stringa di output
	int lunghezza_totale = strlen(str1)+strlen(str2)+strlen(str3);
	//alloco la nuova stringa di output
	char * stringa_concatenata=malloc(sizeof(char)*lunghezza_totale);


	//inserisce nella nuova stringa i caratteri di stringa 1
	for (int i=0;i<strlen(str1);i++){
		stringa_concatenata[i]=str1[i];
	}
	//inserisce nella nuova stringa i caratteri di stringa 2

	//inserisce nella nuova stringa i caratteri di stringa 3
	
}
```
Quindi alla posizione 0 di "stringa concatenata" farò corrispondere il carattere all posizione 0 di str1.

Ora che ho finito di copiare la prima lista devo copiare anche la seconda. Però adesso non va più bene usare i per indicizzare la stringa concatenata. Cioè se facessimo così:
```C
char * concatena(char * str1,char * str2, char * str3){
//definisce una nuova stringa (quella concatenata)
	// trovo la lunghezza della stringa di output
	int lunghezza_totale = strlen(str1)+strlen(str2)+strlen(str3);
	//alloco la nuova stringa di output
	char * stringa_concatenata=malloc(sizeof(char)*lunghezza_totale);


	//inserisce nella nuova stringa i caratteri di stringa 1
	for (int i=0;i<strlen(str1);i++){
		stringa_concatenata[i]=str1[i];
	}
	//inserisce nella nuova stringa i caratteri di stringa 2
	for (int i=0;i<strlen(str2);i++){
		stringa_concatenata[i]=str2[i];
	}
	//inserisce nella nuova stringa i caratteri di stringa 3
	
}
```
si andrebbe a copiare sulla stringa concatenata si, i valori di stringa 2, ma si andrebbero a sovrascrivere quelli scritti in precedenza, quindi serve un iteratore a parte per la stringa concatenata che non venga resettato a zero ogni volta che il ciclo for finisce

```C
char * concatena(char * str1,char * str2, char * str3){
//definisce una nuova stringa (quella concatenata)
	// trovo la lunghezza della stringa di output
	int lunghezza_totale = strlen(str1)+strlen(str2)+strlen(str3);
	//alloco la nuova stringa di output
	char * stringa_concatenata=malloc(sizeof(char)*lunghezza_totale);
	int j=0; //iteratore per la stringa concatenata

	//inserisce nella nuova stringa i caratteri di stringa 1
	for (int i=0;i<strlen(str1);i++){
		stringa_concatenata[j]=str1[i];
		j++;
	}
	//inserisce nella nuova stringa i caratteri di stringa 2
	for (int i=0;i<strlen(str2);i++){
		stringa_concatenata[j]=str2[i];
		j++;
	}
	//inserisce nella nuova stringa i caratteri di stringa 3
	for (int i=0;i<strlen(str2);i++){
		stringa_concatenata[j]=str3[i];
		j++;
	}
	stringa_concatenata[j]='\0';
	return stringa_concatenata;
}
```
A questo punto basta farlo anche per l'ultima stringa e poi non scordatevi di aggiungere alla fine il carattere di fine stringa '\\0'


Per migliorare ancora questa soluzione si può, prima di fare tutte queste operazioni, controllare che l'allocazione di memoria della stringa concatenata sia andata a buon fine, ad esempio con un if

```C
char * concatena(char * str1,char * str2, char * str3){
//definisce una nuova stringa (quella concatenata)
	// trovo la lunghezza della stringa di output
	int lunghezza_totale = strlen(str1)+strlen(str2)+strlen(str3);
	//alloco la nuova stringa di output
	char * stringa_concatenata=malloc(sizeof(char)*lunghezza_totale);
	int j=0; //iteratore per la stringa concatenata

	if(stringa_concatenata!=NULL){
		//inserisce nella nuova stringa i caratteri di stringa 1
		for (int i=0;i<strlen(str1);i++){
			stringa_concatenata[j]=str1[i];
			j++;
		}
		//inserisce nella nuova stringa i caratteri di stringa 2
		for (int i=0;i<strlen(str2);i++){
			stringa_concatenata[j]=str2[i];
			j++;
		}
		//inserisce nella nuova stringa i caratteri di stringa 3
		for (int i=0;i<strlen(str2);i++){
			stringa_concatenata[j]=str3[i];
			j++;
		}
		stringa_concatenata[j]='\0';
	}
	return stringa_concatenata
}
```

Finito!
Qui sotto trovate la soluzione completa da copiare ed incollare.

>[!question]- soluzione
>```C
>#include<stdio.h>
>#include<stdlib.h>
>#include<string.h>
>
>char * concat(char* a,char *b,char *c){
>   int total_size=strlen(a)+strlen(b)+strlen(c);
>   char * chained = (char *)malloc(total_size*sizeof(char));
>   int j=0;
>   if(chained!=NULL){
>       for (int i=0;i< strlen(a);i++){
>           chained[j]=a[i];
>           j++;
>       }
>       for (int i=0; i<strlen(b);i++){
>           chained[j]=b[i];
>           j++;
>       }
>       for(int i=0; i<strlen(b);i++){
>           chained[j]=c[i];
>           j++;
>       }
>       chained[j]='\0';
>   }
>   return chained;
>}
>
>int main(){
>   char * a="ciao ";
>   char * b="come ";
>   char * c="va?";
>
>   printf("%s",concat(a,b,c));
>}
>```


#### Esercizio 1 hard
Fai la funzione di concatenazione con un numero arbitrario di stringhe!
Ci sono diversi modi per farlo, quello che consiglio è di passare un array di stringhe!!
Pensa bene come potresti definire questo array di stringhe e come all'interno della funzione separare ogni singola stringa e fare le operazioni che abbiamo fatto nell'esercizio precedente.

>[!hint]- un hint che posso darvi è il main. Così capite cosa andrà passato alla funzione. Guardatelo.
>```C
>int main(){
>   char * a="ciao ";
>   char * b="come ";
>   char * c="va?";
>
>   char ** array_di_stringhe;
>   array_di_stringhe[0]=a;
>   array_di_stringhe[1]=b;
>   array_di_stringhe[2]=c;
>
>   printf("%s\n",concatena(array_di_stringhe,3));
>}
>```
>Come vedete alla funzione concatena passo un array di stringhe e il numero di stringhe che sto passando, nel mio caso gli passo tre stringhe.
>Per passare un array di stringhe devo passare un puntatore ad un puntatore di char, cioè un puntatore a stringhe, cioè un array di stringhe fondamentalmente.

##### SOLUZIONE:

```C
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

char * concatena(char ** array_di_stringhe,int numero_stringhe){
    int total_size=0;
    //trova la dimensione totale
    for(int i=0;i<numero_stringhe;i++){
        total_size +=strlen(array_di_stringhe[i]);
    }
    //printf("%d\n",total_size);

    //alloca la stringa
    char * stringa_concatenata= malloc(sizeof(char)*total_size);

    //controlla che l'allocazione sia andata a buon fine
    if(stringa_concatenata!=NULL){
        int k=0;
        for(int i=0;i< numero_stringhe;i++){ //per ogni stringa nell'array di stringhe
            for (int j=0;j<strlen(array_di_stringhe[i]);j++){//per ogni carattere della stringa
                stringa_concatenata[k]=array_di_stringhe[i][j];
                k++;
            }
        }
        stringa_concatenata[k]='\0';
    }
    return stringa_concatenata;

}

int main(){
    char * a="ciao ";
    char * b="come ";
    char * c="va?";

    char ** array_di_stringhe;
    array_di_stringhe[0]=a;
    array_di_stringhe[1]=b;
    array_di_stringhe[2]=c;

    printf("%s\n",concatena(array_di_stringhe,3));
}
```