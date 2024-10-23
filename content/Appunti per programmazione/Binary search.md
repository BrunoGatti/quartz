---
publish: true
---

La ricerca binaria, o binary search è un algoritmo per cercare elementi su una lista ordinata.

>[!note] problema:
>Ho una lista di elementi ordinati tipo
>```python
>[1,2,5,8,13,17,22,34,39,234,300]
>```
>e voglio trovare un numero, ad esempio il 39.

Normalmente per farlo dovrei scorrere tutta la lista di elementi finchè, dopo ben 9 passaggi, non trovo il fatidico 39.

```python
[1,2,5,8,13,17,22,34,39,234,300]
 ^
[1,2,5,8,13,17,22,34,39,234,300]
   ^
[1,2,5,8,13,17,22,34,39,234,300]
     ^
[1,2,5,8,13,17,22,34,39,234,300]
	   ^
...
[1,2,5,8,13,17,22,34,39,234,300]
					 ^

```

Capite bene che scorrere tutta la lista in questo modo impiega tempo $O(n)$ (se non capisci perchè impiega $O(n)$ o non capisci cosa significa,studia [[Complessità computazionale|questo]]).

## Posso fare di meglio?
Si. In che modo?

Supponiamo di nuovo che tu debba cercare il 39.
Perchè invece di cominciare a cercare dall'inizio della lista non comincio dal centro?

```python
[1,2,5,8,13,17,22,34,39,234,300]
            ^
```
Si ok ma che vantaggio mi ha portato?
Beh ora abbiamo trovato il 17, certo non è il nostro 39, ma cosa possiamo dire ora?

>[!question]- cosa possiamo dire ora?
>Beh possiamo dire che è inutile cercare 39 prima del 17, giusto? Perchè siccome la lista è ordinata, a sinistra del 17 ci saranno solo numeri più piccoli del 17, mentre il 39 si troverà per forza nella lista di destra!

Quindi adesso tutti i numeri prima del 17, 17 compreso, non ci servono più.

```python
[1,2,5,8,13,17,22,34,39,234,300]
 x x x x  x  x
```
Quindi SCARTIAMO la lista a sinistra del 17 e proseguiamo con la lista a destra del 17.
Di nuovo cominciamo la ricerca dal centro e...
```python
[22,34,39,234,300]
       ^
```
Trovato il 39! In soli due passaggi! Rispetto ai nove di prima, è un bel salto di qualità

### "Hai solo avuto culo che il 39 stava al centro gne gne gne".
No, perchè quanto impiega al caso pessimo?
Beh al caso pessimo, la lista ad ogni passo viene dimezzata , perchè guardo al centro e scarto la parte destra o la parte sinistra.

```python
[1,2,5,8,13,17,22,34,39,234,300]
 x x x x  x  x
```

Quindi al massimo, quante volte posso dimezzare una lista lunga n?
O meglio quante volte posso dividere per due un numero n?
Se vi ricordate, il numero di volte in cui posso dividere un numero per 2 è il logaritmo in base due di quel numero.
Quindi 

$$
T(ricerca~binaria)=\log_{2}{n}=O(\log{n}) 
$$
che rispetto all'algoritmo classico è una bella differenza (l'algoritmo classico che scorre tutta la lista impiega $O(n)$).

### Qual'è la fregatura?
La fregatura è che questo algoritmo funziona solo se la lista in cui devo cercare è ordinata.
Tenetelo a mente quando programmate.

## Un esempio di problema che può essere risolto con la ricerca binaria

Copia ed incolla questo programma ed eseguilo. Questo programma vi pone un indovinello, lui sceglierà a caso un numero, e voi lo dovrete indovinare, avrete al massimo 7 tentativi.
C'è un modo, che si basa sulla ricerca binaria per indovinare sempre il numero con meno di 7 tentativi.

Provateci

```python
import random

def gioco_indovina_numero():
    numero_da_indovinare = random.randint(0, 100)
    tentativi_rimasti = 7

    print("Benvenuto al gioco Indovina il Numero!")
    print("Ho pensato a un numero tra 0 e 100. Prova ad indovinarlo.")

    while tentativi_rimasti > 0:
        try:
            tentativo = int(input("Inserisci il tuo tentativo: "))
        except ValueError:
            print("Per favore, inserisci un numero valido.")
            continue

        if tentativo == numero_da_indovinare:
            print(f"Complimenti! Hai indovinato il numero {numero_da_indovinare}!")
            break
        elif tentativo < numero_da_indovinare:
            print("Il numero è troppo piccolo. Riprova.")
        else:
            print("Il numero è troppo grande. Riprova.")

        tentativi_rimasti -= 1
        print(f"Tentativi rimasti: {tentativi_rimasti}")

    if tentativi_rimasti == 0:
        print(f"Hai esaurito i tentativi. Il numero corretto era {numero_da_indovinare}.")

if __name__ == "__main__":
    gioco_indovina_numero()

```