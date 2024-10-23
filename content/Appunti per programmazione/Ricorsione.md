---
publish: true
---

La ricorsione sono funzioni che chiamano loro stesso.
Ma perchè dovremmo fare mai una cosa del genere?

```python
#supponiamo di dover sommare tutti i numeri di una lista

lista=[1,2,5,13,4]

#normalmente dovreste fare una cosa tipo
def somma_di_lista(lista)
	somma_totale=0
	for x in lista:
		somma_tutale+=x
	return somma_totale

#e cioè scorriamo la lista, ed ogni elemento di quella lista lo accumuliamo in una variabile chiamata somma_totale

```
Questa è un'ottima idea, ma non funziona sempre

```python
lista=[1,2,3,[4,7,1],3,5]

print(somma_di_lista(lista)) #ERRORE

```
Mi da errore perchè quando trova la lista non può sommarla come farebbe con un normale numero. Quello che vorremmo dire alla funzione è tipo: qunado becchi un numero, bene, sommalo agli altri, ma quando becchi un'altra lista, entra dentro, trova la somma dei numeri in quella lista, e poi prosegui con gli altri numeri.

```python

def deep_somma_di_lista(lista) #questa funzione prende una lista e mi da la somma dei suoi elementi
	somma_totale=0
	for elemento in lista:
		if type(elemento)==int:
			somma_totale+=elemento
		elif type(elemento)==list:
			#dammi la somma di quella lista
	return somma_totale

```

AH! se solo avessi una funzione che prende una lista in input e restituisce la somma dei suoi elementi......
Ma io in realtà ce l'ho! La sto programmando ora!

```python
def deep_somma_di_lista(lista) #questa funzione prende una lista e mi da la somma dei suoi elementi
	somma_totale=0
	for elemento in lista:
		if type(elemento)==int:
			somma_totale+=elemento
		elif type(elemento)==list:
			somma_totale+=deep_somma_lista(elemento)
			#voglio sommare alla somma totale, la somma degli elementi della lista interna
	return somma_totale
```

Questo può sembrare una mano che si disegna da sola (e per certi versi lo è) ma allo stesso tempo è una figata pazzesca, perché mi ha risolto in maniera molto elegante un problema che sarebbe stato non banale da risolvere.

# una funzione ricorsiva per il massimo di una lista

```python
lista=[1,3,6,2,4,1,87,9,1]

def massimo(lis):
	massimo=0
	for elemento in lis:
		if elemento > massimo : massimo = elemento
	return massimo

print(massimo(lista))
```

Tutto molto figo, ma, se la lista fosse una cosa del tipo:

```python
lista=[1,2,10,[5,7,81],1,42,3]
```

Eh cazzi amari, se non usi la ricorsione.

```python
lista=[1,2,10,[5,7,81],1,42,3]

def massimo_ricorsivo(lista):
	massimo=0
	for elemento in lista:
		if type(elemento)==int and elemento > massimo: massimo=elemento
		elif type(elemento)==list:
			if massimo_ricorsivo(elemento)>massimo: massimo= massimo_ricorsivo(elemento)
	return massimo

print(massimo_ricorsivo(lista))
```

# ricorsione per l'ordinamento

AKA [[Merge sort]]
