Gli array sono delle strutture dati molto basilari in C. Li potete vedere come una serie di elementi uno di fila all'altro TUTTI DELLO STESSO TIPO.
Gli array, in un certo senso, li potete visualizzare come le liste in python.
```C
int a[5]={1,2,3,4,5}
```
questo è il codice per dichiarare un array di nome "a", di tipo intero. RICORDATE: dovete sempre dichiarare la dimensione dell'array! Dovete dire al compilatore, quanto sarà grande quell'array, e la sua dimensione NON POTRA ESSERE CAMBIATA.

Li potete usare per fare un sacco di roba simpatica, ma ricordatevi che non siete più in python! non ci sono più funzioni tipo 
```C
print(a)
```
per stampare tutto l'array! Per fare cose di questo genere dovrete usare dei cicli! Questo è figo, perchè vi farà capire che tutte quelle operazioni che a voi sembravano semplici e immediate con python in realtà impiegano del tempo! Si fanno tutte con un ciclo for!

```C
int a[5]={1,2,3,4,5}
printf("%d",a[2]);
```
questa printf stampa il valore dell'array con indice 2 (il terzo elemento)

```C
a[2]=10;
```
questa istruzione assegna alla terza posizione dell'array a il valore 10.
### ESERCIZIO1: Assegnamento e Stampa
Fai un programma che definisce un array di cinque elementi, che vanno da 1 a cinque. e stampali usando un ciclo for
```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di un array
    int numeri[5] = {1, 2, 3, 4, 5};

    // Stampa degli elementi dell'array
    for (int i = 0; i < 5; i++) {
        printf("%d ", numeri[i]);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int numeri[5] = {1, 2, 3, 4, 5};`: Dichiarazione e inizializzazione di un array di interi con cinque elementi.
- `for (int i = 0; i < 5; i++) { ... }`: Ciclo for per scorrere e stampare gli elementi dell'array.

### ESERCIZIO2: Somma degli Elementi
Fai un programma che definisce un array, e somma tutti gli elementi, stampando la somma totale.
```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di un array
    int numeri[5] = {1, 2, 3, 4, 5};
    int somma = 0;

    // Calcolo della somma degli elementi dell'array
    for (int i = 0; i < 5; i++) {
        somma += numeri[i];
    }

    // Stampa della somma
    printf("Somma degli elementi: %d\n", somma);

    return 0;
}
```

#### Breakdown
- `int somma = 0;`: Dichiarazione e inizializzazione di una variabile per la somma.
- `somma += numeri[i];`: Aggiornamento della variabile somma con l'aggiunta di ciascun elemento dell'array.
- `printf("Somma degli elementi: %d\n", somma);`: Stampa della somma degli elementi.

### ESERCIZIO3: Trova l'Elemento Massimo
Fai un programma che definisce un array e trova il numero massimo di quell'array
```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di un array
    int numeri[5] = {10, 5, 8, 15, 7};
    int massimo = numeri[0];  // Assume che il primo elemento sia il massimo

    // Trova l'elemento massimo nell'array
    for (int i = 1; i < 5; i++) {
        if (numeri[i] > massimo) {
            massimo = numeri[i];
        }
    }

    // Stampa dell'elemento massimo
    printf("Elemento massimo: %d\n", massimo);

    return 0;
}
```

#### Breakdown
- `int massimo = numeri[0];`: Inizializzazione della variabile massimo con il primo elemento dell'array.
- `if (numeri[i] > massimo) { ... }`: Verifica se l'elemento corrente è maggiore del massimo attuale e, in caso affermativo, aggiorna il valore massimo.
- `printf("Elemento massimo: %d\n", massimo);`: Stampa dell'elemento massimo.

### ESERCIZIO4: Ricerca di un Elemento
Fai un programma che definisce un array e ne trova un numero specifico (tipo l'8) e se lo trova ti dice che l'ha trovato, altrimenti ti dice che non l'ha trovato
```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di un array
    int numeri[5] = {10, 5, 8, 15, 7};
    int elemento_cercato = 8;
    int trovato = 0;  // 0 indica che l'elemento non è stato trovato

    // Ricerca dell'elemento nell'array
    for (int i = 0; i < 5; i++) {
        if (numeri[i] == elemento_cercato) {
            trovato = 1;  // L'elemento è stato trovato
            break;        // Interrompi il ciclo
        }
    }

    // Stampa del risultato della ricerca
    if (trovato) {
        printf("L'elemento %d è stato trovato.\n", elemento_cercato);
    } else {
        printf("L'elemento %d non è stato trovato.\n", elemento_cercato);
    }

    return 0;
}
```

#### Breakdown
- `int elemento_cercato = 8;`: Dichiarazione e assegnazione dell'elemento da cercare nell'array.
- `int trovato = 0;`: Inizializzazione della variabile che indica se l'elemento è stato trovato.
- `if (numeri[i] == elemento_cercato) { ... }`: Verifica se l'elemento corrente è uguale all'elemento cercato.
- `trovato = 1; break;`: Imposta la variabile `trovato` a 1 se l'elemento è stato trovato e interrompe il ciclo.
- Stampa del risultato della ricerca.

### ESERCIZIO5: Copia di Array
Fai un programma che definisce un array, e copia il contenuto di quell'array.
ATTENZIONE: non basta fare un assegnamento, se fai solo l'assegnamento, non stai copiando il contenuto dell'array, stai solo dicendo all'altra variabile di puntare al vecchio array, io voglio una COPIA.
```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di due array
    int array_orig[5] = {1, 2, 3, 4, 5};
    int array_copia[5];

    // Copia degli elementi da array_orig a array_copia
    for (int i = 0; i < 5; i++) {
        array_copia[i] = array_orig[i];
    }

    // Stampa degli elementi di array_copia
    printf("Array copiato: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", array_copia[i]);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int array_copia[5];`: Dichiarazione di un secondo array che sarà la copia.
- `array_copia[i] = array_orig[i];`: Copia degli elementi da `array_orig` a `array_copia`.
- Stampa degli elementi di `array_copia`.

### ESERCIZIO6: Somma di Elementi tra Due Array
Fai un programma che presi due array li somma tra di loro.
ESEMPIO: se gli array sono
```C
    int array1[5] = {1, 2, 3, 4, 5};
    int array2[5] = {6, 7, 8, 9, 10};
```
la loro somma
sarà:
```C
{7,9,11,13,15}
```

SOLUZIONE:
```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di due array
    int array1[5] = {1, 2, 3, 4, 5};
    int array2[5] = {6, 7, 8, 9, 10};
    int somma[5];

    // Calcolo della somma degli elementi tra array1 e

 array2
    for (int i = 0; i < 5; i++) {
        somma[i] = array1[i] + array2[i];
    }

    // Stampa degli elementi della somma
    printf("Somma degli elementi: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", somma[i]);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int somma[5];`: Dichiarazione di un terzo array per contenere la somma.
- `somma[i] = array1[i] + array2[i];`: Calcolo della somma degli elementi tra `array1` e `array2`.
- Stampa degli elementi della somma.

### ESERCIZIO7: Ordinamento di Array
Dato un array, ordinalo e stampalo, puoi fare un ordinamento semplice tipo bubble sort, o selection sort, oppure fare qualcosa di complicato tipo merge sort, e farmi felice.

```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di un array
    int numeri[6] = {5, 2, 9, 1, 5, 6};
    int temp;

    // Ordinamento degli elementi in modo crescente (Bubble Sort)
    for (int i = 0; i < 6 - 1; i++) {
        for (int j = 0; j < 6 - i - 1; j++) {
            if (numeri[j] > numeri[j + 1]) {
                // Scambio gli elementi se sono fuori ordine
                temp = numeri[j];
                numeri[j] = numeri[j + 1];
                numeri[j + 1] = temp;
            }
        }
    }

    // Stampa degli elementi ordinati
    printf("Array ordinato: ");
    for (int i = 0; i < 6; i++) {
        printf("%d ", numeri[i]);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int temp;`: Dichiarazione di una variabile temporanea per facilitare lo scambio di elementi durante l'ordinamento.
- Algoritmo di ordinamento Bubble Sort per ordinare gli elementi in modo crescente.
- Stampa degli elementi ordinati.

### ESERCIZIO8: Rimozione di Duplicati da un Array
Dato un array rimuovi gli elementi duplicati
```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di un array con duplicati
    int numeri[8] = {1, 2, 3, 2, 4, 3, 5, 6};
    int nuovi_numeri[8];
    int n = 0; // Numero di elementi unici

    // Rimozione dei duplicati
    for (int i = 0; i < 8; i++) {
        int duplicato = 0;

        // Verifica se l'elemento è già presente in nuovi_numeri
        for (int j = 0; j < n; j++) {
            if (numeri[i] == nuovi_numeri[j]) {
                duplicato = 1;
                break;
            }
        }

        // Se non è un duplicato, aggiungi a nuovi_numeri
        if (!duplicato) {
            nuovi_numeri[n++] = numeri[i];
        }
    }

    // Stampa degli elementi senza duplicati
    printf("Array senza duplicati: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", nuovi_numeri[i]);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int nuovi_numeri[8];`: Dichiarazione di un array per contenere gli elementi senza duplicati.
- Utilizzo di un secondo array (`nuovi_numeri`) e di una variabile `n` per tenere traccia del numero di elementi unici.
- Verifica se l'elemento è già presente in `nuovi_numeri` prima di aggiungerlo.

### ESERCIZIO9: Rotazione a Sinistra di un Array

La rotazione a sinistra significa che se l'array è tipo 
```C
a[5]={1,2,3,4,5}
```
l'array rotato è
```C
{2,3,4,5,1}
```
come se avessi spostato in numeri di un passo a sinistra, e l'uno che era il primo numero diventa l'ultimo.

Fai un programma che dato un array fa lo shift a sinistra

```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di un array
    int numeri[5] = {1, 2, 3, 4, 5};
    int temp = numeri[0];

    // Rotazione a sinistra di un passo
    for (int i = 0; i < 4; i++) {
        numeri[i] = numeri[i + 1];
    }

    // Assegnazione del primo elemento alla fine
    numeri[4] = temp;

    // Stampa dell'array dopo la rotazione
    printf("Array dopo la rotazione: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", numeri[i]);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int temp = numeri[0];`: Memorizzazione del primo elemento in una variabile temporanea.
- Spostamento degli elementi verso sinistra di un passo.
- Assegnazione del valore memorizzato alla fine dell'array.
- Stampa dell'array dopo la rotazione.

### ESERCIZIO10: Concatenazione di Due Array

Fare un programma che dati due array stampa la concatenazione dei due array.
tipo se  gli array sono:
```C
a1[5]={1,2,3,4,5}
a2[3]={6,7,8}
```
L'array concatenato è:
```C
{1,2,3,4,5,6,7,8}
```


```c
#include <stdio.h>

int main() {
    // Dichiarazione e assegnamento di due array
    int array1[5] = {1, 2, 3, 4, 5};
    int array2[3] = {6, 7, 8};
    int risultato[8];

    // Copia degli elementi da array1 a risultato
    for (int i = 0; i < 5; i++) {
        risultato[i] = array1[i];
    }

    // Copia degli elementi da array2 a risultato
    for (int i = 0; i < 3; i++) {
        risultato[i + 5] = array2[i];
    }

    // Stampa dell'array risultante
    printf("Array concatenato: ");
    for (int i = 0; i < 8; i++) {
        printf("%d ", risultato[i]);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int risultato[8];`: Dichiarazione di un terzo array per contenere la concatenazione.
- Copia degli elementi da `array1` a `risultato`.
- Copia degli elementi da `array2` a `risultato` partendo dalla posizione successiva alla fine di `array1`.
- Stampa dell'array risultante.

## Per continuare
per continuare potete fare [[esercizi sulle funzioni]]
