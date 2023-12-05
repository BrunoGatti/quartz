Il puntatore è una variabile che punta ad un altra.
Che vuol dire?

Normalmente quando andiamo a definire una variabile, il nostro computer la mette da qualche parte nella memoria RAM.

>[!example]
> Supponiamo di aver definito la variabile 
> ```C
> int main(){
> 	int x = 3;
> }
> ```
> quando andiamo ad eseguire il programma, il nostro computer la mette nello stack. In memoria risulta una cosa del genere:
>
> |nome variabile|contenuto|indirizzo|
> |---|---|---|
> |x|3|0x12345678

Quindi ogni variabile ha un valore, un nome, ed un indirizzo.
bene, quindi cos'è un puntatore?
Un puntatore è una variabile che, invece di contenere un qualsiasi numero, contiene un indirizzo in memoria! Per esempio:
>[!example]
>Potrei allocare una variabile puntatore chiamata p così
>```C
>int main(){
>	int x = 3;
>	int * p;
>}
>```
>Questo è il modo per dichiarare un puntatore ad un intero.
>Per il momento questo puntatore non punta a nulla, in memoria quindi c'è solo il nome e l'indirizzo della variabile, ma non c'è nessun "contenuto", quindi la variabile non punta a nulla.
>
>Questo è il contenuto della memoria se eseguiamo il programma:
>
> |nome variabile|contenuto|indirizzo|
> |---|---|---|
> |x|3|0x12345678
> |p||0x39184233

Ora però il nostro puntatore non punta a nulla, per esempio potremmo voler farlo puntare alla variabile x di prima! Come facciamo?

>[!question] Va bene fare così? 
>```C
>int main(){
>	int x=3;
>	int * p;
>	p=x;
>}
>```

NO! non va bene fare così.
>[!question]- Perchè?
>Perchè noi vogliamo ad assegnare a p, non il valore di x, ma il suo indirizzo. Cioè, non vogliamo questo:
>
> |nome variabile|contenuto|indirizzo|
> |---|---|---|
> |x|3|0x12345678
> |p|3|0x39184233
>Noi vogliamo questo:
>
>|nome variabile|contenuto|indirizzo|
> |---|---|---|
> |x|3|0x12345678
> |p|0x12345678|0x39184233
> Cioè vogliamo p che punti alla variabile x
> 
>```mermaid
>graph LR;
>p-->x=3
>``` 

Quindi quello che vogliamo è che p assuma come valore l'indirizzo della variabile x (che nel nostro esempio è 0x12345678).
Per fare questo basta fare così:

```C
int main(){
	int x=3;
	int *p;
	p=&x
}
```

Quando diciamo "&x" intendiamo l'indirizzo di memoria della variabile x.

Bene, ora il puntatore p "punta" alla variabile x.

|nome variabile|contenuto|indirizzo|
|---|---|---|
|x|3|0x12345678
|p|0x12345678|0x39184233

```mermaid
graph LR;

p-->x=3
```

Adesso, siccome x è puntata da p, possiamo stampare il contenuto di x usando p invece che x stessa? Domanda retorica, certo che si, ma come si fa?

Devo sostanzialmente dire  "il contenuto della variabile puntata da p".
In C per dire "il contenuto della variabile puntata da p" si usa "\*p"

```C
int main(){
	int x=3; //dichiaro x
	int *p; //dichiaro il puntatore
	p=&x; //assegno al puntatore l'indirizzo di memoria della variabile x
	printf("%d",*p); // stampo il contenuto della variabile puntata da p
}
```
### Test per capire se hai capito 
Prendi questo main

```C
int main(){
	int x=3;
	int p=&x;
}
```
Se eseguito in memoria avrò questa situazione:

|nome variabile|contenuto|indirizzo|
|---|---|---|
|x|3|0x12345678|
|p|0x12345678|0x39184233|

>[!question]- Cosa stampa se stampo "x"?
>stampa il valore della variabile x, cioè 3

>[!question]- cosa stampa se stampo &x?
>stampo l'indirizzo di memoria di x, cioeè 0x12345678

>[!question]- Cosa stampa se stampo p?
>Stampa il contenuto della variabile p, cioè 0x12345678, cioè l'indirizzo di memoria di x, visto che p punta ad x.

>[!question]- cosa stampa se stampo "&p"?
>Stampa l'indirizzo di memoria della variabile p, cioè 0x39184233 nel nostro esempio.


### Test per capire se hai capito 
Prendi questo main

```C
int main(){
	int x=6;
	printf("%d",&x);
}
```

Supponi che in memoria ci sia questo:

|nome variabile|contenuto|indirizzo|
 |---|---|---|
 |x|3|0x12345678

>[!question]- Cosa stampa la printf?
>La printf stamperà l'indirizzo di memoria di x, in questo caso 0x12345678 (o la traduzione in intero di questi byte, per i più nerd)

