---
publish: true
---

## Esercizio 0

Scrivere una funzione ricorsiva che trova il massimo in una lista.
Domanda: Ci mette meno del normale algoritmo che useremmo per trovare il massimo in una lista?

Soluzione:
```python
#scrivi una funzione ricorsiva che trova il massimo in una lista

def massimo_ricorsivo(l):
	massimo=0
	if type(l[0])==list: l[0]=massimo_ricorsivo(l[0])
	if len(l)==1: return l[0]
	else:
		massimo_del_resto_della_lista= massimo_ricorsivo(l[1:])
		if l[0]>massimo_del_resto_della_lista:
			massimo=l[0]
		else:
			massimo=massimo_del_resto_della_lista
	return massimo

print(massimo_ricorsivo([1,4,[1,2,[1,4,101],[102,33]],2,6,2,43,78,[1,4,5,99],2,5,4,2]))

```

Trovare il massimo usando la ricorsione è abbastanza semplice, l'idea è di prendere il primo elemento della lista e confrontarlo con il massimo che uscirà dal resto della lista.
Se è più grande, il massimo è lui, altrimenti, sarà quello che è uscito dal resto della lista:

```python
def massimo_ricorsivo(l):
	massimo=0
	if l[0]> massimo_ricorsivo(l[1:]): massimo = massimo_ricorsivo(l[1:])
	else massimo=l[0]
	return massimo
```
ovviamente questa funzione non ha un caso base: NON sa quando fermarsi, in pratica se la lista che gli passiamo ha un solo elemento quello sarà il massimo


```python
def massimo_ricorsivo(l):
	massimo=0
	if len(l)==1:return l[0]
	if l[0]> massimo_ricorsivo(l[1:]): massimo = massimo_ricorsivo(l[1:])
	else massimo=l[0]
	return massimo
```

Questo già funziona di suo... Ma il fatto che chiamo due volte massimo_ricorsivo sugli stessi dati è un po' una schifezza. Posso semplicemente tenere il risultato in una variabile

```python
def massimo_ricorsivo(l):
	massimo=0
	if len(l)==1:return l[0]
	massimo_del_resto_lista= massimo_ricorsivo(l[1:])
	if l[0]> massimo_del_resto_lista: massimo = massimo_del_resto_lista:
	else massimo=l[0]
	return massimo
```

### Ci mette di meno del normale algoritmo iterativo?

No, per niente, ci mette asintoticamente lo stesso tempo, e anzi, forse di più.


## Esercizio 1


Fai una funzinoe ricorsiva che sommi una lista del tipo:

```python

lista = [1,3,4,2,[1,2,3],4,3,5]

```

###  SOLUZIONE esercizio 1:
```python

def deep_somma(l):
	somma=0
	for elemento in l:
		if type(elemento)==int: somma+=elemento
		elif type(elemento)==list: somma+=deep_somma(elemento)
	return somma

print(deep_somma(lista))
```

il problema di un normale approccio iterativo in questo caso è che quando incontro una lista, vorrei che il mio algoritmo si infilasse dentro anche a quella lista e sommasse anche quegli elementi, invece mi da errore:

```python
lista1=[1,2,3,[1,2,3],4,5]

def somma(lista):
    somma=0
    for el in lista:
        somma+=el
    return somma

print(somma(lista1))

---------------------------------------------------------------------

izio1_dimostrazione.py", line 6, in somma
    somma+=el
TypeError: unsupported operand type(s) for +=: 'int' and 'list'
```

Quindi quello che voglio fare è:
1. se trovo un numero sommalo
2. se trovo una lista, trova la somma in quella lista

Come faccio a trovare una somma in quella lista? [[Ricorsione|ricorsione]]

[[#SOLUZIONE esercizio 1|SOLUZIONE]]

## ESERCIZIO 2

Trova il massimo di una lista, con liste annidate (usando la ricorsione)

```python
def massimo_ricorsivo(lista):
	massimo=0
	for elemento in lista:
		if type(elemento)==int:
			if elemento>massimo: massimo=elemento
		elif type(elemento)==list:			
			massimo_della_sottolista = massimo_ricorsivo(elemento)
			if massimo_della_sottolista > massimo: massimo=massimo_della_sottolista
	return massimo

l=[1,2,3,[1,2,10],[1,6,2,[1,6,99]],[101],[32,41,22]]

print(massimo_ricorsivo(l))
```


## ESERCZIO 3
```python
lista=[1,2,3,[1,2,3,4],[1,5,4,2,[1,2,"waldo"],4,3,2]]
```
data una lista, anche annidata, trova waldo.

```python
#looking for waldo

#in una lista c'è un intruso: waldo, scrivi un programma che trovi waldo anche quando la lista è un macello

def trova_waldo(lista):
	trovato=False
	for elemento in lista:
		if elemento=="waldo": return True
		elif type(elemento)==list:
			if(trova_waldo(elemento)==True): return True
	return trovato

print(trova_waldo([1,2,3,[1,2,3,4],[1,5,4,2,[1,2,"waldo"],4,3,2]]))

```
