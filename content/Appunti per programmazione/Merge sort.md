Il merge sort è un algoritmo [[Ricorsione|ricorsivo]] di sorting (ordina una lista di elementi).
Molto veloce.
Molto usato.

L'idea di fondo del merge sort è che:
1. non è veloce ordinare una lista disordinata
2. è molto veloce, invece, mettere insieme due liste già ordinate

## Merge: mettere insieme due liste già ordinate è semplice

se abbiamo due liste ordinate del tipo:

```python
lista1=[1,5,9]
lista2=[2,3,7]
lista_unita=[]
```

metterle insieme e ottenere una lista ordinata è piuttosto facile: basta prendere il primo elemento della lista1 e confrontarlo con il primo elemento della lista 2

```python
        v 
lista1=[1,5,9]

        v 
lista2=[2,3,7]

lista_unita=[]
```

l'elemento "1" è il più piccolo e viene quindi messo in lista_unita

```python
        - v
lista1=[1,5,9]

        v 
lista2=[2,3,7]

lista_unita=[1]
```
a questo punto si prosegue sulla lista 1 ... confrontiamo 2 e 5, il 2 è chiaramente il più piccolo e viene quindi inserito nella lista unita.

```python
        - v
lista1=[1,5,9]

        - v 
lista2=[2,3,7]

lista_unita=[1,2]
```

è facile convincersi, che in 6 passi, (cioè la somma della lunghezza delle due liste) siamo riusciti a creare una lista unita ordinata a partire dalle prime due!

```python
        - - -
lista1=[1,5,9] 

        - - -           
lista2=[2,3,7] 

lista_unita=[1,2,3,5,7,9]
```

Questa operazione si chiama "Merge", e chiaramente ci mette poco tempo ad ordinare una lista O(n), Ma, il grosso problema è che questa roba **FUNZIONA SOLO LE LISTE DA METTERE INSIEME SONO GIA ORDINATE DI LORO**.

In pratica, una merda, cioè per avere una lista ordinata, le due metà devono essere già ordinate... C'è un modo per sfruttare la cosa?

Si

## Merge Sort: il passo ricorsivo

Quindi l'idea è questa, se io riuscissi, invece che prendere brutalmente tutta la lista e ordinarla come farebbe un uomo delle caverne (cioè usando bubble sort), **a dividere la mia lista in tante sottoliste già ordinate**, quello che dovrei fare sarebbe solo metterle insieme! che è molto più veloce che ordinarle [[Merge sort#Merge mettere insieme due liste già ordinate è semplice|(l'abbiamo visto prima, nel caso non l'avessi letto)|]]!

Quindi, in pratica. Se voglio ordinare una lista, prima, devo aver ordinato, le due metà della lista. Poi le metto insieme.

```python
def merge_sort(lista):
	if len(lista)>1:#fino a che non posso più spezzare la lista
		merge_sort(meta_lista_di_sinistra)
		merge_sort(meta_lista_di_destra)
		merge(meta_lista_di_sinistra, meta_lista_di_destra)
```

Ora si ragiona! Questa funzione si chiama [[Ricorsione|ricorsivamente]] sulla lista, sostanzialmente dividendola a metà, e a metà, e a metà.... Fino a che non la posso più spezzare a metà (cioè quando ha solo un elemento).

![[Pasted image 20231112235549.png]]

Ma a quel punto quando ho solo un elemento ho una lista ordinata!!

E quindi l'operazione merge SI PUO FARE!

A quel punto il merge verrà chiamato sulle liste da 1