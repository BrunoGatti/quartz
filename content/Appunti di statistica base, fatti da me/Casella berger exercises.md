## CH 1 p 1 Describe the sample space of these experiments
Sample space= tutti i possibili outcomes di un esperimento randomico

### Toss a coin four times

```mermaid
graph TD

A[Start] -->|H| B1[HHHH]
A -->|T| B2[HHTT]
B1 -->|H| C1[HHTH]
B1 -->|T| C2[HHTC]
B2 -->|H| C3[HHTH]
B2 -->|T| C4[HHTC]
C1 -->|H| D1[HHTHH]
C1 -->|T| D2[HHTHT]
C2 -->|H| D3[HHTCH]
C2 -->|T| D4[HHTCT]
C3 -->|H| D5[HHTHH]
C3 -->|T| D6[HHTHT]
C4 -->|H| D7[HHTCH]
C4 -->|T| D8[HHTCT]

```

HHHH
HHHT
HHTH
HHTT
......
TOTALE: $2^{4}$
### Conta il numero di foglie danneggiate da insetti
S={0,1,2,3,4,-----n} dove n è il numero totale delle foglie

### Misura la vita di una lampadina di un brand in particolare
$S\{0,.....\infty\}=\{t|t>0\}$

## Chapter 1 problem 5
```mermaid
graph TD
A[Start] -->|1/90| B1[Twins]
B1 -->|1/3| C1[Identical Twins]
B1 -->|2/3| C2[Fraternal Twins]
C1 -->|1/2| D1[Both Boys]
C1 -->|1/2| D2[Both Girls]
C2 -->|1/2| D3[Different Sex]
C2 -->|1/4| D4[Two Girls]
C2 -->|1/4| D5[Two Boys]
```


### $A=\{a~US~birth~results~in~twin~females\}=$

$$
1/90 \times (2/3 \times 1/4 + 1/3 \times 1/2)= 1/90 \times 1/6 = 1/540
$$

### $B=\{ a~US~birth~results~in~identical~twins \}$

$$ 1/90 \times 1/3=1/270$$

### $C=\{a~US~birth~results~in~twins \}$
$$1/90$$

## Ch 1 problem 7
