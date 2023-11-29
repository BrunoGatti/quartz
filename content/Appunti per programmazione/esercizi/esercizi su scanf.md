Scanf è una delle funzioni di standard input outpu, esattamente come printf. Ci permette di prendere input dall'utente.

## ESERCIZIO 1
fai un programma che prende in input un intero e lo stampa
```C
#include<stdio.h>
int main(){
    int x;
    scanf("%d",&x);
    printf("%d",x);
}
```

### BREAKDOWN:
in questo esercizio si definisce una variabile x. Si prende in input un intero usando scanf. e si stampa l'intero.

```C
scanf("%d",&x);
```
questo ci dice che vogliamo prendere un intero in input. e inserirlo in x.
Perchè mettiamo la &? Per capire cos'è la "&" si rimanda alla lezione sui puntatori, ma, in breve, significa che scanf accede all'indirizzo di memoria di x per cambiarne il valore. "&x" significa, quindi, "l'indirizzo di memoria dove è conservata la variabile x".
Come ho detto, per capire bene perchè scanf faccia questa cosa, si rimanda alla lezione sui puntatori, per adesso ci basta sapere che, se vogliamo usare scanf, dobbiamo passare "&x".

Certamente! Ecco una serie di esercizi sulla funzione di libreria `scanf` in linguaggio di programmazione C. Gli esercizi sono progressivamente più complessi, e ognuno è accompagnato da una sezione "Breakdown" che spiega ogni istruzione.

### ESERCIZIO2: Input di più variabili
```c
#include <stdio.h>

int main() {
    // Dichiarazione di due variabili per l'input
    int num1, num2;

    // Richiesta di input all'utente
    printf("Inserisci due numeri separati da uno spazio: ");

    // Utilizzo di scanf per leggere due numeri separati da uno spazio
    scanf("%d %d", &num1, &num2);

    // Stampa dei numeri inseriti
    printf("Hai inserito: %d e %d\n", num1, num2);

    return 0;
}
```

#### Breakdown
- `int num1, num2;`: Dichiarazione di due variabili intere per l'input.
- `printf("Inserisci due numeri separati da uno spazio: ");`: Stampa del messaggio per chiedere all'utente di inserire due numeri separati da uno spazio.
- `scanf("%d %d", &num1, &num2);`: Utilizzo di `scanf` per leggere due numeri separati da uno spazio e memorizzarli nelle variabili `num1` e `num2`.
- `printf("Hai inserito: %d e %d\n", num1, num2);`: Stampa dei numeri inseriti.

### ESERCIZIO3: Input di una stringa
```c
#include <stdio.h>

int main() {
    // Dichiarazione di una stringa per l'input
    char nome[50];

    // Richiesta di input all'utente
    printf("Inserisci il tuo nome: ");

    // Utilizzo di scanf per leggere una stringa
    scanf("%s", nome);

    // Stampa della stringa inserita
    printf("Ciao, %s!\n", nome);

    return 0;
}
```

#### Breakdown
- `char nome[50];`: Dichiarazione di un array di caratteri per memorizzare una stringa di massimo 49 caratteri (più il terminatore nullo).
- `printf("Inserisci il tuo nome: ");`: Stampa del messaggio per chiedere all'utente di inserire il suo nome.
- `scanf("%s", nome);`: Utilizzo di `scanf` per leggere una stringa e memorizzarla nell'array `nome`.
- `printf("Ciao, %s!\n", nome);`: Stampa della stringa inserita.

### ESERCIZIO4: Gestione di numeri decimali
```c
#include <stdio.h>

int main() {
    // Dichiarazione di una variabile per l'input
    float numero;

    // Richiesta di input all'utente
    printf("Inserisci un numero decimale: ");

    // Utilizzo di scanf per leggere un numero decimale
    scanf("%f", &numero);

    // Stampa del numero decimale inserito
    printf("Hai inserito: %.2f\n", numero);

    return 0;
}
```

#### Breakdown
- `float numero;`: Dichiarazione di una variabile floating-point per l'input.
- `printf("Inserisci un numero decimale: ");`: Stampa del messaggio per chiedere all'utente di inserire un numero decimale.
- `scanf("%f", &numero);`: Utilizzo di `scanf` per leggere un numero decimale e memorizzarlo nella variabile `numero`.
- `printf("Hai inserito: %.2f\n", numero);`: Stampa del numero decimale inserito con precisione di due cifre decimali.

### ESERCIZIO5: Gestione di più tipi di dati
```c
#include <stdio.h>

int main() {
    // Dichiarazione di variabili per input di diversi tipi
    int intero;
    float decimale;
    char carattere;

    // Richiesta di input all'utente
    printf("Inserisci un numero intero, un numero decimale e un carattere: ");

    // Utilizzo di scanf per leggere diversi tipi di dati
    scanf("%d %f %c", &intero, &decimale, &carattere);

    // Stampa dei dati inseriti
    printf("Hai inserito: %d, %.2f, %c\n", intero, decimale, carattere);

    return 0;
}
```

#### Breakdown
- `int intero; float decimale; char carattere;`: Dichiarazione di variabili per memorizzare un intero, un numero decimale e un carattere.
- `printf("Inserisci un numero intero, un numero decimale e un carattere: ");`: Stampa del messaggio per chiedere all'utente di inserire un intero, un numero decimale e un carattere.
- `scanf("%d %f %c", &intero, &decimale, &carattere);`: Utilizzo di `scanf` per leggere un intero, un numero decimale e un carattere e memorizzarli nelle rispettive variabili.
- `printf("Hai inserito: %d, %.2f, %c\n", intero, decimale, carattere);`: Stampa dei dati inseriti.

Questi esercizi coprono un'ampia gamma di situazioni in cui è possibile

 utilizzare la funzione `scanf` per leggere input dall'utente in C. Spero che ti siano utili!
## Per continuare:
per continuare, continua con [[Control Flow]]
