---
publish: true
---

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

```python
lista_da_ordinare=[1,6,2,9,4,3,8,7]

merge_sort([1,6,2,9,4,3,8,7]):
	merge_sort([1,6,2,9])
	merge_sort([4,3,8,7])

merge_sort([1,6,2,9]):
	merge_sort([1,6])
	merge_sort([2,9])

merge_sort([1,6]):#!!!
	merge_sort(1)#le ho srotolate fino a che le liste non sono di un elemento
	merge_sort(6)
	merge([1],[6])

merge_sort([2,9]):#!!!
	merge_sort(2)
	merge_sort(9)
	merge([2],[9])
```

Bene, ho toccato il fondo, ho chiamato merge_sort su un singolo elemento... cosa accade?
A questo punto viene invocato il **merge()**

```python
merge([1],[9])
```
funziona? BEH SI, avevamo detto che merge funziona solo con liste già ordinate... Ma essendo "1" e "6" due liste fatte di un solo elemento, tecnicamente sono ORDINATE!

E quindi funziona! Siccome funziona per 1 e 6 funzionerà anche per 2 e 9
A questo punto verra chiamato:

```python
merge([1,6],[2,9])
```
Che a sua volta funzionerà! Perchè [1,6] e [2,9] sono due liste ordinate!

Fino a che non si risalirà all'ultima divisione, e la lista sarà completamente ordinata.


![[merge-sort.gif]]

## Quanto ci mette?

È chiaro che a noi interessa quanto impiega questo algoritmo.
[[Merge sort#Merge mettere insieme due liste già ordinate è semplice|Abbiamo già detto]] che merge, per due liste da tre elementi, impiega 6 passi.
Quindi per fare il merge delle due metà di una lista di lunghezza n, impiegherà n.
È anche vero, però, che non tutti i merge sono uguali... fare il merge della lista intera (al passo finale) impiega molto di più che fare il merge di due piccoli elementi... È anche vero però che di "piccole liste" ce ne sono molte di più, mentre della lista grande ce n'è solo una.

![[Pasted image 20231113002438.png]]

In fin dei conti, se si guarda bene il disegno ad albero sopra, ci si convince che per ogni "livello" il merge si occupa di unire "n" elementi.
Quindi sostanzialmente, il tempo totale sarà:

$$
T(totale) = T(merge) * numeroDiLivelli
$$
$$
T(merge)=O(n)
$$
### quanti sono i livelli?

I livelli sono tanti quante le volte che posso dividere n per 2 cioè...  $log_2(n)$ 

e quindi:

$$
 T(totale) = T(merge ) * numero Livelli = O(n) * log_2(n) = O(n * log(n)) 
$$
