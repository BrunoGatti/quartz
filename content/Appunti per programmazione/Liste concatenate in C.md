Le liste concatenate sono una struttura dati.
L'idea è quella di inserire i dati concatenandoli gli uni con gli altri tipo così
```mermaid
graph LR
Lista --> 2
2 <--> 7
7 <--> 3
3 --> NULL

```
Potete immaginare le liste concatenate come una specie di "treno" dove ogni nodo contiene un'informazione, e si può passare da un vagone all'altro.
Il vantaggio di usare una struttura dati del genere è che la cancellazione e l'inserimento in testa e in coda hanno tempo costante: capite bene che aggiungere un vagone ad un treno è molto semplice.
La cosa, invece, che non ci piace delle liste concatenate è che la ricerca è sequenziale, cioè per cercare un numero all'interno di questa lista concatenata dobbiamo scorrerla tutta al caso pessimo.
Come potete vedere dal diagramma sopra abbiamo, per ogni elemento della lista non solo una freccia che va "avanti" al prossimo elemento ma anche una che va "indietro". 
## Un nodo:
Ora cominciamo a ragionare col C.
Come possiamo fare per implementare una struttura dati del genere?
Innanzitutto la lista è fatta da elementi, che il prof chiama "nodi".
I nodi sono i "vagoni" del nostro treno, sono tutti uguali e contengono essenzialmente 3 cose:
1. un valore (in questo caso un numero intero)
2. un puntatore all' elemento successivo
3. un puntatore all' elemento precedente

```C
struct nodo{
	float info;
	struct nodo * succ;
	struct nodo * prec;

}typedef struct nodo nodo;

```

Adesso che abbiamo i nostri "nodi", possiamo provare a crearne uno nel main

>[!question]- Crea un nodo e stampa il suo contenuto
>```C
 >#include <stdio.h>
 >#include <stdlib.h>
 >
 >struct nodo{
 >  float info;
 >  struct nodo * succ;
 >  struct nodo * prec;
 >
 >};typedef struct nodo nodo;
 >
 >int main(){
 >
 >  nodo n1; //definisco un nodo chiamato n1
 >  n1.info=3;
 >  n1.succ=NULL;
 >  n1.prec=NULL;
 >
 >  printf("%f",n1.info);
 >
 >}
>```

Okay quindi adesso abbiamo un nodo, cioè un vagone del nostro treno:

```mermaid
classDiagram
  class nodo {
    - prev: NULL
    - next: NULL
    - info: 3
  }

```
Ovviamente è un vagone scollegato, un nodo senza compagno. Insomma si fa fatica a chiamarlo "treno".
Per essere un treno che si rispetti deve come minimo avere una locomotiva, un vagone che indichi "questo è un treno".
In poche parole, ha bisogno di un puntatore, che dica "questo nodo è una lista di un elemento".

Una cosa del genere

```mermaid
classDiagram
  class nodo {
    - prev: NULL
    - next: NULL
    - info: 3
  }

Lista --> nodo
```

Ora basta implementarlo in C:

>[!question]- Implementa la lista di un elemento in C
>```C
>int main(){
 >
 >  nodo n1; //definisco un nodo chiamato n1
 >  n1.info=3;
 >  n1.succ=NULL;
 >  n1.prec=NULL;
 >
 >  nodo * lista;
 >  lista= & n1;
 >  printf("%f",lista -> info);
 >
 >}
 >```
 
 In questo caso abbiamo definito una lista, come un puntatore ad un nodo.
 ```C
 nodo * lista;
 ```
 Abbiamo poi fatto puntare la lista al nodo n1
 ```C
 lista = &n1;
 ```
Abbiamo poi stampato il numero contenuto nel nodo, passando **per la lista, non per l'elemento in se**

Cioè prima avevamo fatto:
```C
printf("%f",n1.info);
```
Mentre ora:
```C
printf("%f",lista -> info);
```

## Cominciamo a fare funzioni
Ok, quindi ora abbiamo una struttura che rappresenta i nodi della lista concatenata:
```C
struct nodo{
	float info;
	struct nodo * succ;
	struct nodo * prec;

}typedef struct nodo nodo;
```
Abbiamo anche dimostrato che questa struttura funziona.
Adesso andiamo a programmarci alcune funzioni che possono esserci utili:

### Lista vuota
La prima cosa che vogliamo è una funzione che ci restituisca una lista vuota.
Abbiamo già detto che una lista non è altro che un puntatore ad un nodo, giusto?
Quindi una lista vuota, non sarà altro che un puntatore che punta a niente: cioè che punta a NULL

>[!question]- fai una funzione che punta ad una lista vuota

Ok, per fare questa cosa dichiariamo una funzione. La funzione prende in input nulla, e restituisce una lista vuota

```C
nodo * lista_vuota(){
	return NULL;
}
```
\*"nodo \*" indica che vogliamo che la funzione restituisca una lista.
Mentre l'output di questa funzione è la lista vuota: NULL;

Creiamo quindi una lista vuota:

```C
#include <stdio.h>
#include <stdlib.h>

struct nodo{
    float info;
    struct nodo * succ;
    struct nodo * prec;

};typedef struct nodo nodo;

nodo * lista_vuota();

int main(){
    nodo * lista= lista_vuota();
}

nodo * lista_vuota(){
    return NULL;
}
```

### Inserimento in testa alla lista

Ok figo, però la nostra lista ora è vuota, è una cosa del genere.
```mermaid
graph TD

lista --> NULL
```
Cioè un puntatore che punta a niente.
Piuttosto triste.
Se vogliamo riempirla evitando di inserire manualmente nel main tutti i nodi come abbiamo fatto nel primo paragrafo, ci serve una funzione che aggiunga nodi a questa lista.

>[!question] Fai una funzione che inserisce un elemento in testa alla lista

Okay, come sempre dobbiamo pensare, quando facciamo una funzione:
1. Cosa prende in input
2. Cosa esce in output

Noi vogliamo dargli in input sicuramente la lista da modificare, vogliamo passargli il valore dell'elemento da aggiungere, e vogliamo avere in output la lista modificata.

Quindi se ad esempio chiamiamo la funzione così:
```C
lista=aggiungiInTesta(lista,35);
```
vorremmo che una volta chiamata così venga aggiunta alla lista il "vagone contenente il numero 35"

Facciamolo:
1. Definiamo la funzione

```C
nodo * aggiungi_in_testa(nodo * lista,float valore){
    //creo un nuovo nodo
    //aggiungo il nodo in testa alla lista
    //ritorno la lista aggiornata
}
```
A costo di essere ridondante: la funzione prende in input una lista ("nodo \* lista"), un valore ("float valore"), e restituisce una lista ("nodo \*" )

2. creo un nuovo nodo


```C
nodo * aggiungi_in_testa(nodo * lista,float valore){
    //creo un nuovo nodo
    nuovo_nodo = malloc(sizeof(nodo));
    //aggiungo il nodo in testa alla lista
    //ritorno la lista aggiornata
}
```
creiamo un nuovo nodo usando la programmazione dinamica (perchè non siamo delle bestie), alloco quindi lo spazio necessario.
Poi lo riempio

```C
nodo * aggiungi_in_testa(nodo * lista,float valore){
    //creo un nuovo nodo
    nodo * n= malloc(sizeof(nodo));
    n->info = valore;
    n->prec=NULL;
    n->succ=NULL;
```

Quindi abbiamo creato un nodo. e abbiamo una lista. Scollegati.
La situazione è una cosa del genere, supponendo che la lista avesse già della roba al suo interno:

```mermaid
classDiagram
  class nodo_nuovo_da_inserire {
    - prev: NULL
    - next: NULL
    - info: valore
  }

  class nodo1_vecchio {
    - prev: NULL
    - next: nodo2_vecchio
    - info: 5
  }

  class nodo2_vecchio {
    - prev: nodo1_vecchio
    - next: NULL
    - info: 9
  }

lista --> nodo1_vecchio
nodo1_vecchio <--> nodo2_vecchio
nodo2_vecchio <--> NULL
```
Quindi dobbiamo dire al nodo nuovo di puntare al nodo1_vecchio. Dire al nodo1_vecchio di puntare a quello nuovo, e restituire la lista aggiornata.

```C
n->succ = lista;
```
Il nuovo nodo (n) punta al primo elemento della lista (il nodo vecchio 1 del disegno).

```C
lista->prec=n;
```
il nodo vecchio (che è il primo elemento della lista) viene fatto puntare al nodo nuovo.
La situazione è la seguente:
```mermaid
classDiagram
  class nodo_nuovo_da_inserire {
    - prev: NULL
    - next: NULL
    - info: valore
  }

  class nodo1_vecchio {
    - prev: NULL
    - next: nodo2_vecchio
    - info: 5
  }

  class nodo2_vecchio {
    - prev: nodo1_vecchio
    - next: NULL
    - info: 9
  }

lista --> nodo_nuovo_da_inserire
 nodo_nuovo_da_inserire<--> nodo1_vecchio
nodo1_vecchio <--> nodo2_vecchio
nodo2_vecchio <--> NULL
```

Qui sotto c'è il codice completo della funzione:

```C
nodo * aggiungi_in_testa(nodo * lista,float valore){
    //creo un nuovo nodo
    nodo * n= malloc(sizeof(nodo));
    n->info = valore;
    n->prec=NULL;
    n->succ=NULL;
    
    //aggiungo il nodo in testa alla lista
    n->succ = lista; 
    if (lista!=NULL){
        lista->prec=n;
    }
    lista=n;
    //ritorno la lista aggiornata
    return lista;
}
```

#### Perchè c'è quell' "if" strano?
```C
    if (lista!=NULL){
        lista->prec=n;
    }
```
Questo if controlla che la lista non sia vuota prima di eseguire l'istruzione 
```C
lista->prec = n
```
Questo è importante perchè quando la lista è vuota non c'è un elemento attaccato a lista

```mermaid
graph TD

lista --> NULL
```

E quindi quando il computer, durante l'esecuzione si va a cercare "lista->prec" non lo trova (E grazie al cazzo, non c'è nessun elemento nella lista). E quindi impazzisce, si incazza, e ritorna il famoso errore: SEGMENTATION FAULT.

>[!per i più nerd]- La segmentation fault
>La segmentation fault è un errore che sostanzialmente significa che il computer ha acceduto della memoria a cui non sarebbe dovuto accedere, è di gran lunga il più comune errore di runtime (cioè un errore che avviene mentre il programma sta girando e non mentre il programma sta compilando tipo gli errori rossi classici o i warning). 
>Quando un programma cerca di accedere della roba che non esiste, o a scrivere cose che non dovrebbe scrivere in posti che non ha ancora creato, spesso va ad accedere ad aree di memoria che non gli competono. Per evitare che il programma vada a scrivere in aree di memoria critiche il sistema ferma tutto e lancia segmentation fault.
>Nel nostro caso abbiamo provato ad accedere ad un nodo che non avevamo ancora allocato, dando quindi origine ad un segmentation fault.

Il vostro programma ora dovrebbe essere una cosa di questo tipo

```C
#include <stdio.h>
#include <stdlib.h>

struct nodo{
    float info;
    struct nodo * succ;
    struct nodo * prec;

};typedef struct nodo nodo;

nodo * lista_vuota();
nodo * aggiungi_in_testa(nodo * lista,float valore);

int main(){
    nodo * lista= lista_vuota();
}

nodo * lista_vuota(){
    return NULL;
}
nodo * aggiungi_in_testa(nodo * lista,float valore){
    //creo un nuovo nodo
    nodo * n= malloc(sizeof(nodo));
    n->info = valore;
    n->prec=NULL;
    n->succ=NULL;

    //aggiungo il nodo in testa alla lista
    n->succ = lista;
    if (lista!=NULL){
        lista->prec=n;
    }
    lista=n;

    //ritorno la lista aggiornata
    return lista;
}
```

Abbiamo però solo una lista vuota:

```C
int main(){
    nodo * lista= lista_vuota();
}
```
```mermaid
graph TD

lista --> NULL
```

Andiamo ad aggiungere due nodi alla lista. 

```C
int main(){
    nodo * lista= lista_vuota();
    lista = aggiungi_in_testa(lista, 3);
    lista = aggiungi_in_testa(lista,5);
}
```
A questo punto dovremmo avere questa situazione se compiliamo ed eseguiamo il programma:

```mermaid
classDiagram


  class nodo1 {
    - prev: NULL
    - next: nodo2_vecchio
    - info: 5
  }

  class nodo2 {
    - prev: nodo1_vecchio
    - next: NULL
    - info: 9
  }

lista --> nodo1
nodo1 <--> nodo2
nodo2 --> NULL
```


>[!per le bestie]- per le bestie che non si ricordano come si compila ed esegue
>1. andate nella cartella dove avete salvato il file da linea di comando
>2. lanciate il comando di compilazione 
>   ```bash
>   gcc il_mio_programma.c -o il_mio_programma.out
>   ```
>3. eseguire il file eseguibile
>   ```bash
>   ./il_mio_programma.out
>   ```

Se avete compilato ed eseguito avrete visto che il programma non fa assolutamente nulla di nulla.
Questo perchè stiamo solo allocando una lista ma non stiamo stampando niente.
Approfittiamone per scrivere una funzione che stampa la lista.

### Funzione che stampa la lista
Come sempre, le funzioni hanno un input e un output.
La funzione prende in input la lista da stampare, e in output non ritorna nulla, stampa e basta.

```C
void stampa_lista(nodo* lista);
```

Ora creiamo un puntatore, questo puntatore, ha la funzione di puntare ad ogni elemento della lista, prende un elemento, stampa il valore, e passa a quello successivo.

```C
void stampa_lista(nodo * lista){
	nodo * iteratore=lista;
    printf("lista->"); //estetica
    while(iteratore!=NULL){
        printf("%f->",iteratore->info);
        iteratore=iteratore->succ;
    }
    printf("null"); //estetica
}
```

A questo punto se aggiungiamo la funzione di stampa nel main possiamo vedere che gli elementi della lista sono stati allocati correttamente:

```C
int main(){
    nodo * lista= lista_vuota();
    lista = aggiungi_in_testa(lista, 3);
    lista = aggiungi_in_testa(lista,5);
    stampa_lista(lista);
}

```
Il programma intero è questo:

```C
#include <stdio.h>
#include <stdlib.h>

struct nodo{
    float info;
    struct nodo * succ;
    struct nodo * prec;

};typedef struct nodo nodo;

nodo * lista_vuota();
nodo * aggiungi_in_testa(nodo * lista,float valore);
void stampa_lista(nodo * lista);

int main(){
    nodo * lista= lista_vuota();

    lista = aggiungi_in_testa(lista, 3);
    lista = aggiungi_in_testa(lista,5);

    stampa_lista(lista);
}

nodo * lista_vuota(){
    return NULL;
}
nodo * aggiungi_in_testa(nodo * lista,float valore){
    //creo un nuovo nodo
    nodo * n= malloc(sizeof(nodo));
    n->info = valore;
    n->prec=NULL;
    n->succ=NULL;

    //aggiungo il nodo in testa alla lista
    n->succ = lista;
    if (lista!=NULL){
        lista->prec=n;
    }
    lista=n;

    //ritorno la lista aggiornata
    return lista;
}
void stampa_lista(nodo * lista){
    nodo * iteratore=lista;
    printf("lista->"); //estetica
    while(iteratore!=NULL){
        printf("%f->",iteratore->info);
        iteratore=iteratore->succ;
    }
    printf("null"); //estetica
}
```

Se lo eseguite il risultato sarà questo:

![[Pasted image 20240109184002.png]]
che è una fedele rappresentazione di quello che ci aspettavamo: una lista di due elementi: 5 e 3.

