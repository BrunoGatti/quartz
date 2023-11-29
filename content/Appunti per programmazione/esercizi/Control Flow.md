Per controllo del flusso si intendono tutte quelle strutture che cambiano l'ordine delle istruzioni, cicli, if-else, while, for, break etc. etc.

Qui trovate alcuni esercizi commentati che potrebbero servirvi

### ESERCIZIO1: If-Else
If else crea un "bivio".
Se la condizione dentro l'if è verificata esegue un' istruzione, se non è verificata ne esegue un'altra.
La sintassi è:
```C
if(condizione){
	istruzione1;
}
else{
	condizione 2;
}
```
Si può anche aggiungere un'altra condizione aggiuntiva usando "else if"

```C
if(condizione1){//se si verifica la condizione 1 esegue istruzione 1
	istruzione1;
}
else if(condizione2){//se si verifica la condizione 2 esegue istruzione 2
	istruzione2;
}
else{//in tutti gli altri casi esegui l'istruzione 3
	istruzione3;
}
```

Fai un programma che prende un intero dall'utente e ti dice se l'intero è positivo, negativo o è zero
```c
#include <stdio.h>

int main() {
    // Dichiarazione di una variabile
    int numero;
    
    // Richiesta di input all'utente
    printf("Inserisci un numero intero: ");
    scanf("%d", &numero);

    // Verifica se il numero è positivo, negativo o zero
    if (numero > 0) {
        printf("Il numero è positivo.\n");
    } else if (numero < 0) {
        printf("Il numero è negativo.\n");
    } else {
        printf("Il numero è zero.\n");
    }

    return 0;
}
```

#### Breakdown
- `int numero;`: Dichiarazione di una variabile intera.
- `printf("Inserisci un numero intero: ");`: Stampa del messaggio per chiedere all'utente di inserire un numero.
- `scanf("%d", &numero);`: Utilizzo di `scanf` per leggere un numero intero dall'utente e memorizzarlo nella variabile `numero`.
- `if (numero > 0) { ... } else if (numero < 0) { ... } else { ... }`: Struttura di controllo del flusso che verifica se il numero è positivo, negativo o zero, e stampa un messaggio di conseguenza.

### ESERCIZIO2: Ciclo While
Il ciclo while è una delle strutture principali del control flow di ogni linguaggio di programmazione. esegue le istruzioni nel blocco fino a che è verificata la condizione tra parentesi.

La sintassi è 
```C
while (condizione){
	istruzione
}
```


Stampa i numeri da 1 a cinque con un ciclo while
```c
#include <stdio.h>

int main() {
    // Dichiarazione di una variabile contatore
    int contatore = 1;

    // Stampa dei numeri da 1 a 5 usando un ciclo while
    while (contatore <= 5) {
        printf("%d ", contatore);
        contatore++;
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int contatore = 1;`: Dichiarazione e inizializzazione di una variabile contatore.
- `while (contatore <= 5) { ... }`: Fino a che il contatore è minore di cinque, stampa il valore del contatore, e lo aumenta.
Quindi all'inizio il contatore è 1, siccome è minore di cinque, viene eseguito il corpo del while, stampo il contatore e lo aumento, così diventa 2, siccome è ancora minore di 5 eseguo il corpo del while, stampo 2, aumento il contatore che diventa 3.... e così via

### Ciclo For
Il ciclo for in C funzina così:
for(da; condizione; incremento)

ma cosa significa?
prendiamo un esempio:
```C
for (int i=0;i<=3;i++){
	istruzione1;
}
```
questo ciclo parte da 0. (i=0)
incrementa l'iteratore di uno (i++)
e continua fino a quando l'teratore è minore di 3(i<=3)

### ESERCIZIO 3:
fai un programma che stampa i numeri da 1 a cinque usando un ciclo for

```c
#include <stdio.h>

int main() {
    // Stampa dei numeri da 1 a 5 usando un ciclo for
    for (int i = 1; i <= 5; i++) {
        printf("%d ", i);
    }
    printf("\n");

    return 0;
}
```

### ESERCIZIO4: Switch
Lo switch è un modo di controllare molteplici condizioni insieme senza dover scrivere duecentomila condizioni if-else.

sintassi:
```C
switch(x){
	case 1:
		istruzione1;
	case 2:
		istruzione2;
	case 3:
		istruzione3;
	etc.....
}
```
in questo caso se x assume il voler 1 allora esegue l'istruzione 1, se x assume il valore 2 allora esegue l'istruzione 2. etc..

ESERCIZIO: scrivere un programma che prende in input un numero tra 1 e 3 e ti dice se hai scelto 1, 2, 3 o se hai inserito un numero non valido
```c
#include <stdio.h>

int main() {
    // Dichiarazione di una variabile per la scelta
    int scelta;

    // Richiesta di scelta all'utente
    printf("Scegli un numero tra 1 e 3: ");
    scanf("%d", &scelta);

    // Utilizzo di switch per gestire diverse opzioni
    switch (scelta) {
        case 1:
            printf("Hai scelto uno.\n");
            break;
        case 2:
            printf("Hai scelto due.\n");
            break;
        case 3:
            printf("Hai scelto tre.\n");
            break;
        default:
            printf("Scelta non valida.\n");
    }

    return 0;
}
```

#### Breakdown
- `int scelta;`: Dichiarazione di una variabile per la scelta.
- `printf("Scegli un numero tra 1 e 3: ");`: Stampa del messaggio per chiedere all'utente di scegliere un numero.
- `scanf("%d", &scelta);`: Utilizzo di `scanf` per leggere la scelta dell'utente.
- `switch (scelta) { ... }`: Struttura switch che gestisce diverse opzioni in base alla scelta dell'utente.

### ESERCIZIO5: Do-While
Il do-while è equivalente al while. La differenza è che il do-while valuta la condizione DOPO aver eseguito il corpo.
Cioè ti garantisce l'esecuzione del corpo almeno una volta.
TIPO:
```C
#include<stdio.h>
int main(){
	do{
		printf("questa istruzione è stata eseguita anche se la condizione nel while era falsa \n");
		
	}while(0);
}
```
mentre con un while normale

```C
#include<stdio.h>

int main(){
	while(0){
		printf("questa istruzione non verrà eseguita, a differenza di prima, perchè la condizione del while viene valutata prima dell'esecuzione del corpo");
	}

}
```

ESERCIZIO: fai un programma che prende stampa i numeri da 1 a 5 usando il ciclo do-while
```c
#include <stdio.h>

int main() {
    // Dichiarazione di una variabile contatore
    int contatore = 1;

    // Stampa dei numeri da 1 a 5 usando un ciclo do-while
    do {
        printf("%d ", contatore);
        contatore++;
    } while (contatore <= 5);
    printf("\n");

    return 0;
}
```

#### Breakdown
- `int contatore = 1;`: Dichiarazione e inizializzazione di una variabile contatore.
- `do { ... } while (contatore <= 5);`: Ciclo do-while che stampa i numeri da 1 a 5 e incrementa il contatore ad ogni iterazione. Il ciclo viene eseguito almeno una volta, anche se la condizione è falsa inizialmente.

### ESERCIZIO6: Break e Continue
Break interrompe il ciclo in cui si trova.

```C
for(int i=0;i<5;i++){
	printf("questa istruzione verrà eseguita una volta sola, se non ci fosse stato il break sarebbe stata eseguita 5 volte")
	break;
}
```
in questo esempio il ciclo for viene interrotto prima ancora di finire (anzi viene interrotto alla prima istruzione).

CONTINUE:
il continue, invece di interrompere il ciclo come farebbe il break, salta le istruzioni sotto ma continua con il ciclo senza interrompersi.

```C
int main(){
	for(int i=0;i<5;i++){
		if(i==3){continue;}
		printf("%d",i);
	}

}
```
questo esempio stampa tutti i numeri da 0 a 4 ma salta il 3.

ESERCIZIO: fai un programma che stampa i numeri da 1 a 10 ma si interrompe appena trova un numero pari.
Successivamente, il programma stampa tutti i numeri dispari da 1 a 10 DISPARI usando il "continue".

```c
#include <stdio.h>

int main() {
    // Stampa dei numeri da 1 a 10, ma interrompi se il numero è pari
    for (int i = 1; i <= 10; i++) {
        if (i % 2 == 0) {
            printf("Interrotto a causa di numero pari.\n");
            break;
        }
        printf("%d ", i);
    }
    printf("\n");

    // Stampa dei numeri dispari da 1 a 10 usando continue
    for (int j = 1; j <= 10; j++) {
        if (j % 2 == 0) {
            continue;
        }
        printf("%d ", j);
    }
    printf("\n");

    return 0;
}
```

#### Breakdown
- Prima parte: Utilizzo di `break` per interrompere un ciclo se il numero è pari.
- Seconda parte: Utilizzo di `continue` per passare alla prossima iterazione del ciclo se il numero è pari, evitando la stampa di numeri pari.

## PER CONTINUARE
per continuare, ci sono degli esercizi sugli array: [[esericizi sugli array]]
