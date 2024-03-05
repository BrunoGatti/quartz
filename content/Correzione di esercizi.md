```C
#include<stdio.h>


int main(){
    int a[100] = {1,0,-1};
    int *b=a;
    char *c=a;

    c=c+1;
    b=b+1;
    if(b==c){
        printf("ok sono uguali");
    }
    else{
        printf("non sono uguali");
    }
}
```

`b` è un puntatore a un intero (`int`), mentre `c` è un puntatore a un carattere (`char`). Quando esegui `b = b + 1;`, stai incrementando `b` di `sizeof(int)` byte, che di solito è 4 byte su molte piattaforme, mentre `c = c + 1;` incrementa `c` di `sizeof(char)` byte, che è generalmente 1 byte.

Poiché `sizeof(int)` è maggiore di `sizeof(char)`, l'incremento di `b` sposterà il suo puntatore di più byte rispetto all'incremento di `c`. Quindi, `b` sarà maggiore di `c`.

Nel contesto dei puntatori, la "grandezza" o "magnitudine" dipende dalla loro posizione relativa nella memoria. Poiché `b` sarà più "avanti" in memoria di `c`, `b` sarà maggiore di `c`. Pertanto, la condizione `if (b == c)` nel tuo codice sarà valutata come falsa, e il programma stamperà "non sono uguali".


## Domanda 4
`len()` in Python non può essere applicata direttamente a tipi di dati come numeri interi, float o altri tipi non sequenziali. `len()` è progettata per funzionare su sequenze o collezioni di elementi come liste, tuple, stringhe, set e dizionari.

Quando si tenta di applicare `len()` a un oggetto non sequenziale come un numero, si otterrà un errore di tipo `TypeError` perché `len()` non è definito per quel tipo di oggetto.

Ecco un esempio di errore che si verificherebbe se provassi a usare `len()` su un intero:

```python
len(3)
```

Questo produrrà un errore del tipo:

```
TypeError: object of type 'int' has no len()
```

Quindi, `len()` non può essere utilizzato direttamente su singoli numeri o altri tipi di dati non sequenziali.