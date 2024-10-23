---
publish: true
---

In C le stringhe sono gestiti tramite un tipo chiamato "char".
"char" definisce un carattere.
A differenza di python in cui ad esempio andavamo a definire le stringhe come un tipo vero e proprio, in C, abbiamo il carattere come tipo.

```C
#include <stdio.h>

int main(){
    char c='A';
    printf("%c\n",c);
}
```
Questo programma come si può vedere stampa il carattere "A".
![[Pasted image 20231211130547.png]]

Ma cos'è un char di preciso? Un char in realtà è un intero piccolo.
Se proviamo infatti a stampare come intero il carattere c, non ci da alcun problema.

```C
#include <stdio.h>

int main(){
    char c='A';
    printf("%c\n",c);
	printf("%d\n",c);
}
```
Ci stampa "A", ma anche 65...
![[Pasted image 20231211130650.png]]
Ma cos'è il 65?
Il 65 è l'intero che, se convertito in carattere, ci da il carattere "A".
Questo tipo di codifica che associa ad ogni carattere un intero è la cosidetta codifica ASCII.

![[Pasted image 20231211130759.png]]
Ad esempio il carattere "A" corrisponde all'esadecimale "41", che se convertito in intero, è il numero "65".

## Le stringhe: array di caratteri.
Dunque le stringhe non sono altro che array di caratteri.

```C
#include <stdio.h>

int main(){
    char c='A';
    char a[4]="ciao";
    printf("%c\n",c);
    printf("%d\n",c);

    printf("%s\n",a);
}
```

![[Pasted image 20231211131109.png]]
Come possiamo vedere, per stampare una stringa abbiamo usato il placeholder "%s"...

Un altro modo equivalente per dichiarare una stringa sarebbe stato quello di specificare ogni elemento dell'array singolarmente, tipo:

```C
#include <stdio.h>

int main(){
    char c='A';
    char a[4]={'c','i','a','o'};
    printf("%c\n",c);
    printf("%d\n",c);

    printf("%s\n",a);
}
```
Anche questo funziona uguale.

>[!danger] ricordate però che quando si parla di char si usano gli apici singoli **'c'** mentre quando si parla di stringhe si usano apici doppi **"ciao"**

