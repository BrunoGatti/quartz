Questo documento fornisce una guida dettagliata sui test implementati per il contratto VotingSystem e MyToken. Gli scopi principali di questi test sono verificare il corretto funzionamento del sistema di voto, inclusi aspetti come la corretta configurazione iniziale, la gestione delle autorizzazioni e il corretto svolgimento delle votazioni.
## Test sugli smart contracts
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

## Test da fare
1. Testare che un indirizzo che ha abbastanza token e che garantisce al voting system un' allowance possa votare
2. Testare che un indirizzo che ha abbastanza token ma non ha allowance non possa votare
3. Testare che un indirizzo che ha dato allowance ma che non ha abbastanza token non possa votare
4. Testare che un indirizzo con troppi tokens (più di 1) non possa votare

## Test environment deploy
per i primi test utilizzo una chain locale di Remix.

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

Se proviamo a votare di nuovo con lo stesso indirizzo...

![[Pasted image 20231206161000.png]]

Questo è dovuto al fatto che il token che era stato inviato al voting (0xAb8...35cb2) booth è stato speso e perchè l'approvazione (allowance) che era stata data al sistema di voto era per un solo voto.

![[Pasted image 20231206161045.png]]

Per inviare un altro voto sarà necessario inviare un altro token, bisognerà di nuovo dare l'approvazione al voting system e poi il voto potrà essere effettuato.

### Test: dare allowance ma non avere abbastanza token
Per testare il sistema provo a dare al voting booth l'approvazione al voto ma non gli fornisco abbastanza tokens per poter votare (non gli do tokens)
![[Pasted image 20231206163439.png]]
Il risultato è chiaro:
![[Pasted image 20231206163520.png]]

### Test: abbastanza token, ma non c'è allowance
Diamo al voting booth 0xAb8...35cb2 un token ma il voting system non ha l'autorizzazione per trasferire i coin in vece del voting booth.

![[Pasted image 20231206163945.png]]
![[Pasted image 20231206164118.png]]
Come si può vedere la funzione transferFrom restituisce un errore per "Insufficient allowance".
Questo fa fallire la chiamata a vote().

![[Pasted image 20231206164239.png]]


## Testing in Javascript
Ho implementato i test descritti qui sopra in un file javascript che possa essere eseguito con facilità nel caso di modifiche ai contratti.
Questo ci permette di avere un'alta confidenza che i cambiamenti futuri che potrebbero essere apportati, rispettino comunque le funzioni richieste dagli stakeholders.

### Panoramica
Per i test che seguiranno ho utilizzato il linguaggio JavaScript, in particolar modo la libreria: "[Chai](https://www.chaijs.com/)".
Chai è un'assertion library per Javascript che permette di semplificare e migliorare scrittura e lettura dei test. Fornisce un'insieme di funzioni che consentono agli sviluppatori di esprimere dichiarazioni chiare e concise sul comportamento del loro codice.
Inoltre ho utilizzato la libreria [Ethers](https://docs.ethers.org/v6/api/providers/#Signer-getAddress) per l'interazione della blockchain, il tutto all'interno dell'ambiente di sviluppo fornito da [hardahat](https://hardhat.org/tutorial/final-thoughts#_9-final-thoughts)

### Che cosa stiamo testando
Come accennato in precedenza, quello che andremo a testare sono principalmente 4 funzioni dello smart contract:
1. Testare che un indirizzo che ha abbastanza token e che garantisce al voting system un' allowance possa votare
2. Testare che un indirizzo che ha abbastanza token ma non ha allowance non possa votare
3. Testare che un indirizzo che ha dato allowance ma che non ha abbastanza token non possa votare
4. Testare che un indirizzo con troppi tokens (più di 1) non possa votare

A questi test principali, ne ho aggiunti alcuni, per verificare il corretto deployment del sistema di voto e dei tokens.
### Eseguire i test
all'interno del progetto i test si trovano nella cartella test.
Per eseguirli basta chiamare la funzione test implementata da hardhat

```bash
cd test
npx hardhat test
```

risultato desiderato:
```node
  VotingSystem
chairperson address:  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
    ✔ should have the same chairperson and owner
voting system adddress: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
my token address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
    ✔ should have different addresses for VotingSystem and Token
    ✔ should set the token contract in VotingSystem
Voting Booth Address: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
Voting Booth Balance: 0
    ✔ should print the address and balance of the voting booth
the balance is 0
the initial allowance is zero
approve transaction issued
allowance is now 1n
transaction is sent
the balance of the voting booth is now  1n
the voting booth calls the vote transaction
the vote is equal to the original vote
allowance is now 0n
the balance of the voting booth is now  0n
    ✔ should allow voting booth to vote after approval
transaction is sent
Vote transaction failed as expected for insufficient allowance
    ✔ should fail when voting booth does not give allowance
approve transaction issued
Vote transaction failed as expected for insufficient tokens
    ✔ should fail when voting booth has insufficient tokens
approve transaction issued
transaction is sent
Vote transaction failed as expected: too many tokens
    ✔ should fail when voting booth has too many tokens


  8 passing (902ms)

```

### Configurazione Iniziale
```javascript
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('VotingSystem', function () {
    let VotingSystem, MyToken, votingSystem, myToken, ownerAddress, votingBooth;

    before(async () => {
        [ownerAddress,votingBooth] = await ethers.getSigners();

        VotingSystem = await ethers.getContractFactory('contracts/VotingSystem.sol:VotingSystem');
        MyToken = await ethers.getContractFactory('contracts/MyToken.sol:MyToken');

        myToken = await MyToken.deploy();
        await myToken.waitForDeployment();
        
        votingSystem = await VotingSystem.deploy();
        await votingSystem.waitForDeployment();
    });
```

In questa parte di codice viene fatto il deployment dei token e del sistema di voto. Inoltre vengono presi i due indirizzi "signers" (in grado di firmare transazioni) che sono quelli del chairperson e del voting booth. Questa è una fase di configurazione "globale" che vale per tutte le altre asserzioni che seguiranno.
Mentre il codice nelle asserzioni "it" non viene considerato dalle altre asserzioni, questo che si trova nella sezione "before" viene invece considerato globalmente.

#### `should have the same chairperson and owner`

Questo test verifica che il chairperson del sistema di voto sia lo stesso dell'owner del token. Se questa condizione non è soddisfatta, potrebbe indicare un problema nella configurazione iniziale

```js
    it('should have the same chairperson and owner', async () => {
        const chairperson = await votingSystem.chairperson();
        //const votingSystemAddress= await votingSystem.getAddress()
        const owner = await myToken.owner();

        expect(chairperson).to.equal(ownerAddress.address);
        expect(chairperson).to.equal(owner);
        console.log("chairperson address: ",chairperson)
    });
```

#### `should have different addresses for VotingSystem and Token`

```js
    it('should have different addresses for VotingSystem and Token', async () => {
        // Check if the addresses are different
        const votingSystemAddress=await votingSystem.getAddress();
        const myTokenAddress=await myToken.getAddress();
        console.log("voting system adddress:",votingSystemAddress);
        console.log("my token address:",myTokenAddress);
        expect(votingSystem.getAddress()).to.not.equal(myToken.getAddress());
    });
```

Questo test verifica che gli indirizzi del sistema di voto e del token siano diversi. Ciò è essenziale per garantire la corretta separazione tra i due contratti.

#### `should set the token contract in VotingSystem`

```js
    it('should set the token contract in VotingSystem', async () => {
        // Set the token contract in VotingSystem
        await votingSystem.setTokenContract( await myToken.getAddress());

        // Verify that the myToken variable in VotingSystem is correctly set
        const votingSystemToken = await votingSystem.myToken();
        expect(votingSystemToken).to.equal(await myToken.getAddress());
    });
```


Questo test verifica che il contratto VotingSystem sia in grado di impostare correttamente il contratto del token. La funzione `setTokenContract` dovrebbe associare correttamente l'indirizzo del token al sistema di voto.

## Interazione con il Booth di Voto


#### `should print the address and balance of the voting booth`

Questo test stampa l'indirizzo e il saldo del voting booth. Questa operazione è utile per il debug e per assicurarsi che il booth di voto sia correttamente inizializzato.

```js
    it('should print the address and balance of the voting booth', async () => {
        // Get the address and balance of the voting booth
        const votingBoothAddress = await votingBooth.getAddress();
        const votingBoothBalance = await myToken.balanceOf(votingBoothAddress);

        // Print the address and balance of the voting booth
        console.log('Voting Booth Address:', votingBoothAddress);
        console.log('Voting Booth Balance:', votingBoothBalance.toString());
    });
```
#### `should allow voting booth to vote after approval`

Questo test verifica il flusso completo di voto. Inizialmente, il bilancio del booth di voto è zero e non c'è alcuna autorizzazione. Il test procede con l'approvazione del sistema di voto e l'invio di token al booth. Dopo il voto, vengono verificati diversi aspetti, inclusi il bilancio del booth, l'autorizzazione e il corretto salvataggio del voto cifrato.

```js
    it('should allow voting booth to vote after approval', async () => {

        // Verify that the balance of the new account is zero
        const initialBalance = await myToken.balanceOf(votingBooth.address);
        expect(initialBalance).to.equal(0);
        console.log("the balance is 0");

        // Verify that there is no allowance for the voting booth
        const initialAllowance = await myToken.allowance(await votingBooth.getAddress(),await votingSystem.getAddress());
        expect(initialAllowance).to.equal(0);
        console.log("the initial allowance is zero");

        // Sign and send the "approve" transaction
        const approveTransaction = await myToken.connect(votingBooth).approve(await votingSystem.getAddress(), 1);
        await approveTransaction.wait();
        console.log("approve transaction issued");

        // Verify that the allowance is now 1
        var updatedAllowance = await myToken.allowance(await votingBooth.getAddress(), await votingSystem.getAddress());
        expect(updatedAllowance).to.equal(1);
        console.log("allowance is now",updatedAllowance);

        // Send one token to the voting booth from the owner
        const sendTransaction = await myToken.transfer(await votingBooth.getAddress(), 1);
        await sendTransaction.wait();
        console.log("transaction is sent");

        // Verify that the balance of the voting booth is now 1
        var updatedBalance = await myToken.balanceOf(await votingBooth.getAddress());
        expect(updatedBalance).to.equal(1);
        console.log("the balance of the voting booth is now ",updatedBalance);

        // Voting booth calls the vote transaction
        const voteTransaction = await votingSystem.connect(votingBooth).vote('hello');
        await voteTransaction.wait();
        console.log("the voting booth calls the vote transaction");

        // Verify that the encrypted vote matches with the argument of the vote transaction
        const encryptedVotes = await votingSystem.getEncryptedVotes();
        expect(encryptedVotes[0]).to.equal('hello');
        console.log("the vote is equal to the original vote");

        //verify that the new balance and the new allowance is 0
        updatedAllowance = await myToken.allowance(await votingBooth.getAddress(), await votingSystem.getAddress());
        expect(updatedAllowance).to.equal(0);
        console.log("allowance is now",updatedAllowance);
        updatedBalance = await myToken.balanceOf(await votingBooth.getAddress());
        expect(updatedBalance).to.equal(0);
        console.log("the balance of the voting booth is now ",updatedBalance);
    });
```
#### `should fail when voting booth does not give allowance`

```js
    it('should fail when voting booth does not give allowance', async () => {
        // Send one token to the voting booth from the owner
        const sendTransaction = await myToken.transfer(await votingBooth.getAddress(), 1);
        await sendTransaction.wait();
        console.log("transaction is sent");

        try {
            // Attempt to call the vote transaction without giving allowance
            const voteTransaction = await votingSystem.connect(votingBooth).vote('hello');
            await voteTransaction.wait();

            // If the above line does not throw an error, fail the test
            expect.fail("Vote transaction should fail without allowance");
        } catch (error) {
            // Verify that the error is due to insufficient allowance
            expect(error.message).to.contain("ERC20InsufficientAllowance");
            console.log("Vote transaction failed as expected for insufficient allowance");
        }
    });
```

Questo test verifica che una transazione di voto fallisca quando il booth di voto non concede l'autorizzazione al sistema di voto. Il test si aspetta che il sistema restituisca un errore di "ERC20InsufficientAllowance".

#### `should fail when voting booth has insufficient tokens`

```js
    it('should fail when voting booth has insufficient tokens', async () => {
        // Allow the voting system to spend 1 token on behalf of the voting booth
        const approveTransaction = await myToken.connect(votingBooth).approve(await votingSystem.getAddress(), 1);
        await approveTransaction.wait();
        console.log("approve transaction issued");

        try {
            // Attempt to vote with insufficient tokens
            const voteTransaction = await votingSystem.connect(votingBooth).vote('hello');
            await voteTransaction.wait();

            // If the above line does not throw an error, fail the test
            expect.fail("Vote transaction should fail with insufficient tokens");
        } catch (error) {
            // Verify that the error is due to insufficient tokens
            expect(error.message).to.contain("insufficient tokens");
            console.log("Vote transaction failed as expected for insufficient tokens");
        }
    });
```

Questo test verifica che una transazione di voto fallisca quando il booth di voto ha un numero insufficiente di token, anche se è stata data l'autorizzazione. Il test si aspetta che il sistema restituisca un errore di "insufficient tokens".

#### `should fail when voting booth has too many tokens`

```js
    it('should fail when voting booth has too many tokens', async () => {
        // Allow the voting system to spend 2 tokens on behalf of the voting booth
        const approveTransaction = await myToken.connect(votingBooth).approve(await votingSystem.getAddress(), 2);
        await approveTransaction.wait();
        console.log("approve transaction issued");

        // Send 2 tokens to the voting booth from the owner
        const sendTransaction = await myToken.transfer(await votingBooth.getAddress(), 2);
        await sendTransaction.wait();
        console.log("transaction is sent");

        try {
            // Attempt to vote with too many tokens
            const voteTransaction = await votingSystem.connect(votingBooth).vote('hello');
            await voteTransaction.wait();

            // If the above line does not throw an error, fail the test
            expect.fail("Vote transaction should fail with too many tokens");
        } catch (error) {
            // Verify that the error is due to having too many tokens
            expect(error.message).to.contain("'Balance exceedes normal balance, the tokens are more than two'");
            console.log("Vote transaction failed as expected: too many tokens");
        }
    });
```

Questo test verifica che una transazione di voto fallisca quando il booth di voto ha un numero eccessivo di token, anche se è stata data l'autorizzazione. Il test si aspetta che il sistema restituisca un errore specifico indicante che il bilancio supera il limite consentito.

## Conclusioni
Questi test forniscono una copertura completa delle funzionalità principali del contratto VotingSystem. Ogni test è progettato per garantire che il sistema di voto funzioni correttamente in diversi scenari. È consigliabile eseguire questi test regolarmente durante lo sviluppo e prima dell'implementazione del sistema in un ambiente di produzione.