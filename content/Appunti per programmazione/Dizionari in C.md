---
publish: true
---

Fino ad ora abbiamo visto che una delle cose più costose è sempre stata la ricerca.
Cercare un elemento da qualche parte è sempre difficile.
Abbiamo visto che per cercarlo in una lista disordinata ci mettiamo al caso pessimo la lunghezza della stringa: $O(n)$
E abbiamo visto che la ricerca è un po' più facile quando dobbiamo cercare un elemento in una lista già ordinata, in quel caso possiamo usare la [[Binary search|ricerca binaria]] che impiega solamente $O(log(n))$.
C'è un modo di essere più veloci? SI
In realtà possiamo fare talmente meglio da far paura. I dizionari, infatti, ci permettono di cercare le cose in tempo costante: $O(1)$

## Cos'è un dizionario
Se sai già cos'è un dizionario salta questa parte.
Un dizionario è una struttura dati che contiene un insieme di coppie Chiave/valore.

Una cosa del genere:

| Chiave | Valore |
| ---- | ---- |
| "Biondi" | 6 |
| "Mori" | 12 |
| "Rossi" | 2 |
Questo è un dizionario che ci dice quante persone ci sono con un determinato colore di capelli.
Se vogliamo sapere quanti biondi ci sono, ci basta chiedere al dizionario d["Biondi"] e lui ci restituirà il valore "6".

Figo, ma perché ci interessa?
Beh il dizionario ci mette tempo costante a cercare qual'è il valore associato a "Biondi".
Cioè, a differenza di come abbiamo sempre visto, quando io gli chiedo "Dammi il valore associato alla chiave Biondi", lui NON SI VA A SCORRERE LA LISTA DELLE CHIAVI finché non ha trovato "Biondi". Assolutamente no.
Lui va a colpo sicuro.
Vediamo come

### Il trucco: La funzione hash

Il trucco sta che invece di conservare queste coppie chiave/valore in modo classico, quindi una di fila all'altra tipo così (se le avessimo così al caso pessimo ci metteremmo O(n) a cercare in questa lista di coppie):


![[Pasted image 20240204004348.png]]

Inseriamo queste coppie in sparse all'interno di una lista quasi tutta vuota:

![[Pasted image 20240204004642.png]]

Già sento gli scettici che diranno: Hai solo peggiorato le cose! Adesso dobbiamo cercare in una lista ancora più lunga 
NO.
Perché il posto dove mettere le coppie non è stato scelto a caso.
Il posto dove mettere "Rossi", "Biondi" e "Mori" non è stato scelto da me, ma da una funzione chiamata "Funzione hash".
La funzione hash mi ha detto di inserire "Biondi" al primo posto, "Mori" al secondo posto, e "Rossi" al penultimo.
Con che criterio?
La cosa più bella è che del criterio con cui la funzione hash sceglie queste posizioni non ce ne può fregare di meno.
"Bella merda", direte voi, "a sto punto era meglio scegliere a caso i posti".
NO.
Perchè la funzione hash SA ESATTAMENTE DOVE LI HA MESSI, ricordatevi, la funzione hash non li ha scelti a caso.
La prossima volta che andrò a chiedere alla funzione hash "hey ti ricordi dove sta la chiave Rossi?" Lei ci risponderà "Certamente, è in penultima posizione".
Quindi quando dovrò cercare qualcosa, mi basterà chiederlo alla funzione hash! e lei mi risponderà con l'esatta posizione.

Così facendo il tempo di ricerca diventa costante: $O(1)$.

### Se devo inserire un nuovo elemento?
Se devi inserire un nuovo elemento, di nuovo, non saremo noi a decidere dove va, sarà la funzione hash.
Supponiamo di voler aggiungere il numero di persone con i capelli castani

| Chiave | Valore |
| ---- | ---- |
| "Biondi" | 6 |
| "Mori" | 12 |
| "Rossi" | 2 |
| "Castani" | 23 |
Interrogo la funzione "hash" e mi dice che "castani" va in quarta posizione

![[Pasted image 20240204005650.png]]

Di nuovo, se ci servirà sapere quante persone hanno i capelli castani ci basterà chiedere alla funzione hash "dove sta la chiave Castani?" e lei risponderà "è il quarto elemento della lista".
Impiegando quindi tempo costante nella ricerca.

### Il vero problema
Il vero problema si pone quando avviene un fatto terribile: la collisione.
Se ad un certo punto io volessi aggiungere i "Pelati"

| Chiave | Valore |
| ---- | ---- |
| "Biondi" | 6 |
| "Mori" | 12 |
| "Rossi" | 2 |
| "Castani" | 23 |
| "Pelati" | 3 |
Adesso può accadere che quando chiediamo alla funzione hash dove inserire la nuova chiave, quella ci risponda una casella già presa: tipo la numero quattro

![[Pasted image 20240204010128.png]]
C'è già "Castani" in posizione 4!

Come la gestiamo?
La soluzione è abbastanza semplice: prendiamo "Pelati" e lo attacchiamo a "Castani"

![[Pasted image 20240204010524.png]]
Adesso se cerchiamo il numero di Pelati o di Castani la funzione hash ci dirà che sono in posizione 4, ma dovremmo comunque scorrere la lista:
![[Pasted image 20240204010617.png]]
Per trovare quello che cerchiamo.

Quindi le collisioni fanno aumentare il tempo di ricerca.
L'idea è quindi di cercare di tenere queste liste il più piccole possibile.
Ovviamente più è grande la lista principale, meno probabilità ci sarà che avvenga una collisione: 
![[Pasted image 20240204010859.png]]
Di contro abbiamo che sprechiamo un botto di spazio per delle caselle vuote.

Il caso estremo contrario sarebbe quello in cui abbiamo una sola casella nella lista principale e tutte le coppie sono concatenate come in una lista concatenata.

![[Pasted image 20240204011416.png]]

In questo caso la ricerca sarebbe ovviamente $O(n)$ come in una lista concatenata, ma non staremmo sprecando nessuna casella.
### Il giusto equilibrio
Ci deve essere quindi il giusto equilibrio tra la lunghezza della lista principale, ed il numero di coppie chiave valore inserite.
Generalmente, se la funzione hash è buona, ci basta tenere il numero delle coppie chiave/valore proporzionale alla lunghezza della lista principale per assicurarci che la ricerca sia costante.

## Il dizionario in C

Ora che abbiamo chiaro cos'è un dizionario, e come funziona cominciamo ad implementarlo.

Quindi, un dizionario è fatto da una lunga lista, e da "nodi" ad essa attaccati

![[Pasted image 20240204012245.png]]

In verde c'è la lista principale ed in rosso uno dei nodi.
Vediamo in C:

```C
struct dict {
	nodo **a; //lista principale
	int m; // numero di liste (dimensione della lista principale)
	int n; // numero di elementi nel dizionario
};
typedef struct dict dict;
```

Questo è il dizionario: una lista di liste di nodi.
Nel dizionario teniamo anche m (la lunghezza della lista principale (quella a sinistra in verticale)), ed n, cioè il numero di elementi. Dobbiamo fare in modo che n non cresca troppo rispetto ad m, altrimenti ci saranno troppe collisioni, per questo ce lo conserviamo. Ma per ora non preoccupiamocene.

>[!question] com'è fatto un nodo?

Un nodo è ovviamente fatto da una coppia chiave/valore, ma anche da un puntatore ad un nodo successivo. 

![[Pasted image 20240204012938.png]]
In verde c'è il nodo. In blu la coppia chiave-valore in rosso il puntatore all'elemento successivo.

In C:

```C

struct nodo { //il nodo (in verde nell'immagine sopra)
	d_item info; // la coppia chiave-valore (in blu)
	struct nodo *succ; //il puntatore al nodo successivo (in rosso)
};
typedef struct nodo nodo;

struct d_item { // la coppia chiave-valore
	char *k; //la chiave (una stringa)
	float v; // il valore (un float)
};
typedef struct d_item d_item;

```

### Creiamo il dizionario

Adesso che abbiamo definito le struct necessarie possiamo finalmente creare il nostro primo dizionario.

>[!hint] dict init

```C
dict dict_init(int m){
	/*
	 * Ritorna un dizionario vuoto con m liste
	 * */
	dict d;
	int i;
	
	d.a = malloc(m*sizeof(nodo*));
	d.m = m;
	d.n = 0;
	for(i = 0; i < m; i++){
		d.a[i] = NULL;
	}
	
	return d;
}
```
Il prof ha sviluppato questa funzione per creare un nuovo dizionario di lunghezza m.
Vuoto.

```C
int main(int n, char *args[]){
	dict d = dict_init(5);
}
```
Se chiamiamo questa funzione nel main quello che avremo sarà un dizionario di cinque elementi.
Vuoto.
Praticamente una cosa del genere:
Un dizionario chiamato "d" di cinque elementi.
Come vediamo ancora non c'è nessuna coppia chiave valore.

![[Pasted image 20240204013822.png]]

Adesso magari vorremmo inserire un elemento.

### Inseriamo un elemento nel dizionario

Supponiamo di voler inserire l'elemento

|Pelati|3|
|--|--|

Non manca qualcosa?
SI.
Ci serve la funzione hash, per chiedergli "dove devo inserire la chiave Pelati?".

è arrivato il momento di fare i conti con la funzione hash.

La funzione hash prende in input una chiave e restituisce una posizione della lista principale (quella verticale), nel nostro caso ci darà un numero da uno a cinque.

```C
int h(char *x, dict d){ //prende in input la chiave (e il dizionario)
	
	return out % d.m; //restituisce un numero che va da 0 a d.m
}

```

La funzione hash prende in input la chiave e restituisce un numero compreso tra 0 e la lunghezza della lista principale (da 0 a d.m)
```C
out % d.m 
```
è l'operazione "modulo" (se non la conoscete studiate matematica discreta, bestie!). Fare il modulo ci assicura che il numero non superi d.m (la lunghezza della lista principale).

"out" è ottenuto facendo lo xor di ogni bit della stringa. Ma questo ci interessa fino ad un certo punto. Quello che ci interessa è che ora abbiamo una funzione che ci dice dove mettere le coppie!

```C
int h(char *x, dict d){
	int out = 0;
	int i = 0;
	
	while( x[i] != '\0'){ //per ogni bit di x (la chiave)
		out = x[i]^out; //fai lo xor con out
		i++; // prossimo bit
	}
	
	return out % d.m;
}
```

Ora che abbiamo una funzione hash sviluppiamo l'algoritmo per inserire un elemento.

L'algoritmo a grandi linee sarà questo:
1. prendo il nuovo nodo da aggiungere

![[Pasted image 20240204015252.png]]

2. chiedo alla funzione hash qual'è la sua posizione nella lista principale

![[Pasted image 20240204015434.png]]

3. vado a vedere se c'è già un elemento con quella chiave (in caso sia già lì aggiorno il valore)

![[Pasted image 20240204015531.png]]

![[Pasted image 20240204015750.png]]
4. se la chiave non è già lì allora aggiungo il nodo alla sua casella

![[Pasted image 20240204015613.png]]

Vediamo in C:

```C
dict dict_update(dict d, d_item e){ 

	nodo *p; // nuovo nodo
	int lis = h(e.k, d); //chiedo alla funzione hash dove lo devo mettere, lei mi risponde "mettilo in lis"
	
	
	p = lista_cerca_k(d.a[lis], e.k);  // in lis ci potrebbero già essere una lista di nodi! Cerco se c'è già la mia chiave
	
	if ( p == NULL ) { // la chiave non è nel dizionario
	
		 d.a[lis] = lista_in0(d.a[lis], e); // inserisco il mio elemento
		 d.n++;
	} else { //la chiave è già nel dizionario !

		p->info.v = e.v; // aggiorno il valore
	}
	
	return d; //ritorno il dizionario aggiornato
}
```
