## Test sugli smart contracts
Testare il funzionamento degli smart contracts.
Le interazioni che avvengono con gli smart contracts:

1. Il token viene trasferito dall'indirizzo del chairperson a quello della macchina che vota
2. La macchina che vota, vota, chiamando la funzione vote(condidate) dello smart contract del sistema di voto però:
	1. bisogna prima dare l'autorizzazione al voting system di spendere i token per conto degli indirizzi delle macchine
	2. bisogna dire al sistema del voting system quale token si deve aspettare, chiamando, in fase di deployment la funzione setTokenContract(token address)

### TransferToken
Si può trasferire al massimo un token, quindi il token deve essere trasferito solamente se l'indirizzo ricevente (quello della macchina) ha 0 tokens.

```python
# Define the amount of ONE token to transfer (in wei)
amount_in_wei = web3.to_wei(1, 'ether') # Adjust the amount accordingly

# Build the transaction
transaction = token_contract.functions.transfer(recipient_address, amount_in_wei).build_transaction({
	'chainId': 11155111, 
	'gas': 200000, 
	'gasPrice': web3.to_wei('50', 'gwei'), 
	'nonce': web3.eth.get_transaction_count(sender_account.address),
})
```

### Votare
Bisogna che il voting booth approvi il voting system a spendere soldi in sua vece.
approve (spender, amount).
Questa funzione deve essere chiamata DAL voting booth. Lo spendere deve essere il Voting system. E amount deve essere 1.

```python
approve_tx = TOKEN_CONTRACT.functions.approve(VOTING_SYSTEM_CONTRACT_ADDRESS, 1).build_transaction({
	'chainId': 11155111, # Replace with the correct chain ID
	'gasPrice': web3.to_wei(20, 'gwei'),
	'gas': 400000,
	'nonce': web3.eth.get_transaction_count(sender_address),
})
```

Poi bisogna votare. Per votare è necessario avere ottenuto l'approvazione.

```python
transaction = VOTING_SYSTEM_CONTRACT.functions.vote(0).build_transaction({
	"chainId": 11155111,
	"gasPrice": gas_price,
	"gas": gas_limit,
	"nonce": nonce,
})

# Sign the transaction
signed_transaction = web3.eth.account.sign_transaction(transaction, sender_private_key)
```

## Cambiare il voto
Bisogna cambiare il voto:
Votare adesso deve essere criptato. Il voto deve essere una stringa di testo, generata off chain dallo script di python del voting booth. Al voto testuale va aggiunta una sequenza di padding randomizzata. Il tutto deve essere criptato con una chiave pubblica fornita. Il voto viene espresso passando al voting system contract l'intera stringa criptata che verrà conservata. Al voting system quindi devo:
1. modificare la funzione di voto
2. Rendere scaricabile offline tutta la sequenza di voti conservata

A questo punto per il conteggio dei voti basta che il ministero dell'interno renda pubblica la chiave privata e chiunque potrà decifrare i voti.

### Script per creare chiave pubblica e privata del ministero dell'interno (fittizio)
devo creare uno script python che generi la chiave privata e pubblica del ministero dell'interno


## Test environment deploy
per i primi test utilizzo una chain locale di Remix, versione Shanghai

Chairperson = Token Owner = 0x5b3...eddC4
Voting System = 0xD91... 39138
Token address =  0XD8B...33FA8

fatto il deployment del sistema di voto e del contratto devo dire al voting system di prendere come riferimento il mio token, chiamo setTokenContrat(toke_address).

![[Pasted image 20231206151138.png]]
Ora la variabile pubblica del voting system: "my token" contiene l'indirizzo del token
![[Pasted image 20231206151251.png]]

### Prova di voto: l'approvazione
Per prima cosa dobbiamo fornire ad un indirizzo nuovo un token per poter votare:

Voting Booth 1 = 0xAb8...35cb2
![[Pasted image 20231206151902.png]]
Per ora la balance di questo account è ovviamente 0.
Inviamo un token.
Per farlo dobbiamo inviare a 0xAb8...35cb2 un token firmando la transazione come l'owner dei token (il chairperson).

![[Pasted image 20231206152114.png]]

Ora che questo account ha una balance di 1 token possiamo cercare di votare.
Per prima cosa il votante (0xAb8...35cb2) deve permettere al voting system di spendere monete in sua vece.
![[Pasted image 20231206152304.png]]
approve è la funzione che ci serve. Prende in input un indirizzo (l'indirizzo che potrà spendere i nostri tokens) e il numero di tokens che questi ha il permesso di spendere in nostra vece.
Deve ovviamente essere firmato dal proprietario dei token da spendere.

Nel nostro caso quindi devo firmare la transazione come voting booth 1 (0xAb8...35cb2) ed autorizzare il voting system (0xD91... 39138) a spendere i miei soldi.
![[Pasted image 20231206152558.png]]
![[Pasted image 20231206152542.png]]
La transazione è andata a buon fine.
Per verificare che il voting system abbia effettivamente l'autorizzazione a spendere i coins del voting booth possiamo chiamare la funzione "allowance"

![[Pasted image 20231206153012.png]]
L'owner (dei coins) è il voting booth, e lo spender è il voting system.
Il risultato è l'intero "1", che indica che il voting system è autorizzato a spendere un coin per conto del voting booth.

### Prova di voto: il voto
A questo punto il voting booth 0xAb8...35cb2 può votare. 
Per farlo chiama la funzione "vote" del voting system.

![[Pasted image 20231206153546.png]]

In questo momento la stringa di voto è in chiaro. Off chain verranno implementati gli step necessari per criptare ed inviare il voto già criptato come argomento della funzione.

La transazione è andata a boun fine.
Per verificare il voto, per ora chiamiamo la funzione "getEncryptedVote " questa funzione del voting system restituisce tutti i voti fatti da un determinato votante

![[Pasted image 20231206153813.png]]
Passiamo a questa funzione l'indirizzo del voting booth

![[Pasted image 20231206153939.png]]
