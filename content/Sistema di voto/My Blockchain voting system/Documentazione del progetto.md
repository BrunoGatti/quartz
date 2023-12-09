Questo progetto è stato interamente sviluppato utilizzando [hardhat](https://hardhat.org/).
Hardhat è una suite di sviluppo per la programmazione di smart contract su blockchain. Si tratta di uno strumento che facilita la creazione, il test e la distribuzione di smart contracts su diverse blockchain.
La struttura del progetto è la seguente:
- Artifacts: contiene il risultato della compilazione degli smart contract
- node modules: i moduli installati tramite npm, principalmente contiene gli smart contract relativi agli standard ERC20, utitlizzati nel mio progetto per implementare i miei token.
- python: contiene gli script python per il front end
- test: contiene script per effettuare il testing automatizzato.
- contracts: contiene il codice degli smart contracts.

## Clonare la repository

per poter implementare il progetto occorre clonare la repository da github.
```bash
git clone https://github.com/BrunoGatti/hardhat_voting_project
```

## Contracts

La prima parte di questo sistema sono gli smart contract.
Per questo progetto ne sono necessari 2:
1. Un'implementazione di token ERC20 (per implementare i coin che la macchina deve pagare per votare)
2. Un contratto che gestisca la logica di voto.

### MyToken.sol
```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
	address public owner;
    constructor() ERC20("MyToken", "MTK") {
		owner=msg.sender;
        _mint(msg.sender, 100000000 * 10**18); // Mint 100,000,000 tokens and send them to the deployer
    }
}
```
Questo contratto implementa un token di tipo ERC20, una volta pubblicato sulla blockchain il contratto fa il mint di 100 milioni di token.
L'ERC20 è uno standard che garantisce alcune funzioni di base come la possibilità di trasferire i token, la possibilità di chiedere la balance di un indirizzo ed altre che ci torneranno utili fra poco.

## VotingSystem.sol
```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract VotingSystem {
    MyToken public myToken;  // Reference to the ERC-20 token contract
    address public chairperson;  // Chairperson's address
    string[] private encryptedVotes;  // List to store encrypted votes
    address[] public voters;  // Array to track the addresses of voters

    event Voted(address indexed voter, string encryptedVote);

    constructor() {
        chairperson = msg.sender;
    }

    function setTokenContract(address _tokenAddress) external {
        require(msg.sender == chairperson, "Only the chairperson can set the token contract");
        myToken = MyToken(_tokenAddress);
    }

    function vote(string calldata encryptedVote) external {
        require(msg.sender != address(0), "Invalid sender address");
        require(myToken != MyToken(address(0)), "Token contract not set");
        require(myToken.balanceOf(msg.sender) >= 1, "Insufficient tokens to vote");
        require(myToken.balanceOf(msg.sender) < 2, "Balance exceedes normal balance, the tokens are more than two");

        // Transfer the fee to the voting system contract
        require(myToken.transferFrom(msg.sender, address(this), 1), "Token transfer failed");
        // Record the encrypted vote
        encryptedVotes.push(encryptedVote);
        voters.push(msg.sender); // Record the voter's address
        emit Voted(msg.sender, encryptedVote);
    }

    function getAllVoters() external view returns (address[] memory) {
        return voters;
    }

    function getEncryptedVotes() external view returns (string[] memory) {
        return encryptedVotes;
    }
}
```

Questo è il contratto che implementa la logica di voto.

```js
contract VotingSystem {
    MyToken public myToken;  // Reference to the ERC-20 token contract
    address public chairperson;  // Chairperson's address
    string[] private encryptedVotes;  // List to store encrypted votes

```
Queste sono le variabili pubbliche che ho dichiarato:
- myToken è il contratto dei token che verrà usato come moneta di scambio per il voto
- chairperson è l'indirizzo del chairperson, che nel nostro sistema è colui che fa il deployment del contratto sulla blockchain
- encryptedVotes: contiene sotto forma di lista i voti, questi dovranno essere criptati off chain, e saranno conservati dallo smart contract, saranno disponibili in ogni momento, ma saranno criptati.

```js
    constructor() {
        chairperson = msg.sender;
    }
```
il costruttore ha il solo compito di assegnare il "chairperson" a colui che ha fatto il deployment del contratto.
Il chairperson è l'unico indirizzo che può assegnare il token al contratto.

```js
    function setTokenContract(address _tokenAddress) external {
        require(msg.sender == chairperson, "Only the chairperson can set the token contract");
        myToken = MyToken(_tokenAddress);
    }
```
una volta che il contratto è stato pubblicato il chairperson deve indicare quale sarà il token che verrà utilizzato per le operazioni di voto. Il token in principio può essere qualsiasi token che implementa lo standard ERC20. Nel nostro caso sarà MyToken (MTK) che abbiamo implementato e pubblicato sulla blockchain.

### Vote()
```js
   function vote(string calldata encryptedVote) external {
        require(msg.sender != address(0), "Invalid sender address");
        require(myToken != MyToken(address(0)), "Token contract not set");
        require(myToken.balanceOf(msg.sender) >= 1, "Insufficient tokens to vote");
        require(myToken.balanceOf(msg.sender) < 2, "Balance exceedes normal balance, the tokens are more than two");

        // Transfer the fee to the voting system contract
        require(myToken.transferFrom(msg.sender, address(this), 1), "Token transfer failed");
        // Record the encrypted vote
        encryptedVotes.push(encryptedVote);
        voters.push(msg.sender); // Record the voter's address
        emit Voted(msg.sender, encryptedVote);
    }
```
Questa funzione viene chiamata dal voting booth e permette di effettuare un voto (passato come parametro della funzione).
Il voto DEVE essere criptato off chain. Il contratto non si occupa di criptare i voti. Di quello si occuperà l'applicazione python.
Condizione necessaria per votare è che:
1. sia stato specificato il contratto del token da utilizzare
2. la macchina che vota sia in possesso di un numero di token esattamente pari ad 1
3. che l'indirizzo che vota non sia nullo
4. che venga effettuato un trasferimento di fondi dall'indirizzo del votante all'indirizzo dello smart contract

Per effettuare quest'ultimo, il votante deve aver dato l'approvazione, tramite funzione "approve" (funzione parte dello standard ERC20), allo smart contract di spendere tokens in sua vece.

Quindi la quarta condizione, ne implica una quinta:
5. il votante deve aver dato l'autorizzazione ("allowance") al voting system di spendere i token in sua vece.

Se tutte queste condizioni sono soddisfatte allora il voto procede e la stringa criptata viene aggiunta alla lista di voti.

## Testing
A questo punto si può procedere con il testare i contratti.
Per questo task ho preparato una sezione a parte dove si spiega in dettaglio il tipo di test effettuati.
[[Testing| Qui trovate la sezione di testing completa]].
Per un utente non interessato ai dettagli implementativi i test possono essere effettuati come segue:
1. navigare fino alla directory "test"
	```bash
	cd ./test
	```
2. chiamare la funzione test di hardhat utilizzando lo script contenuto 
	```bash
	npx hardhat test votingSystemTest.js
	```
ci si attende un output di questo tipo

```js

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


  8 passing (755ms)


```

## Deployment su sepolia
Prima di procedere oltre, è il momento di fare il deployment di questi smart contract su una blockchain reale. 
Nel nostro caso stiamo comunque utilizzando un test net: "Sepolia".

Il test net di Sepolia è un'ambiente di sviluppo blockchain progettato per consentire agli sviluppatori di testare e validare i propri smart contract in un ambiente simile a quello del main net, ma senza utilizzare risorse finanziarie reali.

È doveroso ricordare che ci potrebbero comunque essere differenze tra il test net e il main net, come la presenza di meno nodi, minori livelli di sicurezza e tempi di conferma delle transazioni diversi. 

### Deploy smart contracts

Nel nostro caso l'indirizzo "chairperson" sarà:

![[Pasted image 20231206235036.png]]

Come si può vedere questo indirizzo è il possessore dei token, alcuni sono stati utilizzati in precedenti test.

Adesso effettuiamo il deployment del voting system contract:
Quando provo ad effettuare il deployment, metamask chiede l'autorizzazione in automatico.
![[Pasted image 20231206235249.png]]
Il deployment avviene con successo:
![[Pasted image 20231206235509.png]]

Qui lo smart contract, il deployment è stato fatto all'indirizzo 0x08ce7b80BBE57bDc750f8aFB61b10EC28Ca15283
![[Pasted image 20231206235721.png]]
Ovviamente non c'è alcun token assegnato al voting system.
Risalendo ad i token di chairperson tramite metamask possiamo vedere l'indirizzo pubblico del contratto dei token MTK.
![[Pasted image 20231207000025.png]]
l'indirizzo è 0x33286125410a9488d98C65AA18baB01213b5f035
Dopo aver chiamato la funzione setTokenContract, pagato il gas price, ed aspettato che la transazione venisse minata, il risultato è il seguente:
![[Pasted image 20231207000128.png]]

A questo punto la fase di Deployment è completata, possiamo passare ad una dimostrazione degli script python.

## Python: il lato applicativo

### Chairperson.py

La prima applicazione in ordine di utilizzo nel flusso di voto è sicuramente "chairperson.py": l'applicativo che gira sul terminale del chairperson.

```python
from web3 import Web3
import json
from encrypt_decrypt_password import decrypt_data_with_password
from ethereum_utils import *
# List of possible voting booths (addresses)
voting_booths = [
  BOOTH1_PUBLIC_ADDRESS,
  BOOTH2_PUBLIC_ADDRESS
##"0xAddress2",
##"0xAddress3",
]

def list_voting_booths():
    print("List of possible voting booths:")
    for i, address in enumerate(voting_booths, 1):
        print(f"{i} - {address}")

def add_voting_booth():
    address = input("Enter the Ethereum address to add as a voting booth: ")
    if web3.is_address(address):
        voting_booths.append(address)
        print(f"Address {address} added as a voting booth.")
    else:
        print("Invalid Ethereum address.")

def remove_voting_booth():
    list_voting_booths()
    choice = input("Enter the number of the booth to remove: ")
    try:
        index = int(choice) - 1
        if 0 <= index < len(voting_booths):
            removed_address = voting_booths.pop(index)
            print(f"Address {removed_address} removed from voting booths.")
        else:
            print("Invalid choice.")
    except ValueError:
        print("Invalid input. Please enter a number.")

def enable_voting(token_contract,sender_private_key):
    list_voting_booths()
    choice = input("Enter the number of the booth to enable for voting: ")
    try:
        index = int(choice) - 1
        if 0 <= index < len(voting_booths):
            recipient_address = voting_booths[index]
            balance = token_contract.functions.balanceOf(recipient_address).call()
            
            if balance == 0:
                # Sender's private key to fund the booth
                #sender_private_key = input("Enter the sender's private key to fund the booth: ")
                transaction_hash = mu_send_one_token_to_address(sender_private_key, recipient_address)
                print(f"Token transfer initiated. Transaction hash: {transaction_hash.hex()}")
            else:
                print(f"The booth already has a balance of {balance} tokens. No additional tokens sent.")
        else:
            print("Invalid choice.")
    except ValueError:
        print("Invalid input. Please enter a number.")

while True:
    print("\nOptions:")
    print("1 - Add a new possible voting booth")
    print("2 - Remove a voting booth from the list of possible voters")
    print("3 - Enable a booth to vote")
    print("4 - Quit")
    choice = input("Enter your choice: ")

    if choice == '1':
        add_voting_booth()
    elif choice == '2':
        remove_voting_booth()
    elif choice == '3':
        enable_voting(TOKEN_CONTRACT,sender_private_key=CHAIRPERSON_PRIVATE_KEY)
    elif choice == '4':
        print("Exiting the program.")
        break
    else:
        print("Invalid choice. Please select a valid option.")

```

### L'avvio
Una volta avviata l'applicazione chiederà all'utente di inserire una password: Questa password viene utilizzata per decodificare un file privato, tenuto all'interno del file system del progetto sotto il nome di: encrypted_keys.txt, in questo file sono contenute, la chiave privata dell'indirizzo del chairperson sul blockchain, e la chiave delle API del nodo ethereum (nel nostro caso le API di sepolia testnet).

Se la password non è stata configurata, o se si desiderano inserire una chiave privata diversa da quella fornita, basta utilizzare lo script: encrypted_file_generator_secure.py, dove verrà chiesto all'utente di inserire la chiave privata e la chiave delle API, poi una password nuova con cui verranno cifrate.

In [[Generazione del file segreto| questa sezione]] viene descritto in modo estensivo come il file viene generato e descrive nel dettaglio l'implementazione delle funzioni di cifratura che ho sviluppato. 

Una volta che la password è stata inserita correttamente l'applicazione offre all'utente una serie di opzioni, tra tutte, quella cruciale è la possibilità di abilitare un voting booth al voto. 
Le altre opzioni devono ancora essere implementate e sono lasciate (per ora) all'interno del codice come demo.

![[Pasted image 20231209213516.png]]

```python
while True:
    print("\nOptions:")
    print("1 - Add a new possible voting booth")
    print("2 - Remove a voting booth from the list of possible voters")
    print("3 - Enable a booth to vote")
    print("4 - Quit")
    choice = input("Enter your choice: ")

    if choice == '1':
        add_voting_booth()
    elif choice == '2':
        remove_voting_booth()
    elif choice == '3':
        enable_voting(TOKEN_CONTRACT,sender_private_key=CHAIRPERSON_PRIVATE_KEY)
    elif choice == '4':
        print("Exiting the program.")
        break
    else:
        print("Invalid choice. Please select a valid option.")

```

Se si sceglie l'opzione 3, dunque viene chiamata la funzione "enable_voting".
```python
def enable_voting(token_contract,sender_private_key):
    list_voting_booths()
    choice = input("Enter the number of the booth to enable for voting: ")
    try:
        index = int(choice) - 1
        if 0 <= index < len(voting_booths):
            recipient_address = voting_booths[index]
            balance=token_contract.functions.balanceOf(recipient_address).call()
            
            if balance == 0:
                # Sender's private key to fund the booth
                #sender_private_key = input("Enter the sender's private key to fund the booth: ")
                transaction_hash = mu_send_one_token_to_address(sender_private_key, recipient_address)
                print(f"Token transfer initiated. Transaction hash: {transaction_hash.hex()}")
            else:
                print(f"The booth already has a balance of {balance} tokens. No additional tokens sent.")
        else:
            print("Invalid choice.")
    except ValueError:
        print("Invalid input. Please enter a number.")

```
Questa funzione fa scegliere uno dei voting booth all'interno della lista di possibili indirizzi, ed invia un token all'indirizzo selezionato (attraverso al funzione "mu_send_one_token_to_address")
![[Pasted image 20231207002718.png]]
Quando una macchina viene scelta si verifica sempre che questa abbia 0 token di balance e, in caso sia così, si procede con la transazione.
Qui sotto l'output del programma se si prova ad inviare un token ad un indirizzo che ne ha già uno.
![[Pasted image 20231209220642.png]]
Di seguito la transazione effettuata dopo aver eseguito chairperson.py:
![[Pasted image 20231207002628.png]]
### voting_booth.py
Una volta inviato il token all'indirizzo corrispondente alla macchina di voto, l'utente viene indirizzato alla macchina corrispondente.
Per votare ci si interfaccia con il programma "voting_both.py", che è appunto il programma che gira sulle macchine di voto.
```python
from web3 import Web3
import time
import json
import rsa
from encrypt_decrypt_password import *
from ethereum_utils import * 

from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.backends import default_backend



def list_voting_booths():
    return voting_booths 

def list_candidates():
    return list_of_candidates

def main():
    print("Welcome to the Voting Booth Application!")
    
    # Step 1: Connect to an existing blockchain address
    print("Available voting booths:")
    for booth_address in list_voting_booths():
        print(booth_address)

    selected_address = input("Enter the address you want to connect to: ")

    # Step 2: Prompt for private key and validate
    private_key = input("Enter the private key for the selected address: ")
    if not validate_private_key(selected_address, private_key):
        print("Invalid private key. Exiting.")
        return

    # Main loop: over here the main voting booth logic after first boot
    while True:

        # Check if there's a token in the address of the voting booth
        print("waiting for permission to vote from the chairperson")
        while 1:
            if (mu_get_balance(selected_address)==1000000000000000000):
                print(f"balance is 1MTK now")
                break
        print("Connection successful!")

        # Step 3: Display candidates
        print("Available candidates:")
        for candidate in list_candidates():
            print(candidate)
        chosen = False

        # Step 4: User chooses a candidate
        while (not chosen):
            chosen_candidate = input("Choose a candidate: ")
            if chosen_candidate in list_candidates(): chosen=True
            else: print("candidate not in list")
        # Step 5: Confirm the choice
        confirm_choice = input(f"Are you sure you want to vote for {chosen_candidate}? (yes/no): ")
        if confirm_choice.lower() != "yes":
            print("Vote canceled.")
            continue

        # Step 6: Encrypt the sequence
        sequence_to_encrypt = chosen_candidate
        encrypted_sequence = encrypt_sequence(sequence_to_encrypt)
        encrypted_string=encrypted_sequence.hex()
        
        print("I created the encrypted sequence with type: ",type(encrypted_sequence))
        print("the sequence string is: ",encrypted_string)
        print("The decription of the sequence is: ",decrypt_sequence(bytes.fromhex(encrypted_string)))
        # Step 7: Approval transaction
        if (mu_get_balance(selected_address)!=1000000000000000000):
            print("balance is not right, please step out of the cabin")
            break

        if (get_allowance(TOKEN_CONTRACT,selected_address,VOTING_SYSTEM_CONTRACT_ADDRESS)==0):
            approval_transaction_hash = approve_address(private_key).hex()
            print("approval transaction hash: ",approval_transaction_hash)
        else: print("no need for approval")
        # Step 8: Call the vote function
        transaction_hash = cast_vote(encrypted_string,private_key,selected_address)
        print("vote submitted! Transaction hash: ",transaction_hash.hex())
        
        # Check the balance until it is zero
        while mu_get_balance(selected_address) > 0:
            print("Waiting for balance to become zero...")
            time.sleep(5)

        print("Thank you for voting! You are free to go.")

if __name__ == "__main__":
    main()


```

Il programma, quando viene avviato per la prima volta, deve essere avviato dal Chairperson.
All'avvio, infatti, il programma richiederà la password per ritirare la chiave delle API della rete, esattamente come per il programma precedente
![[Pasted image 20231209221132.png]]
Una volta inserita correttamente la password all'utente verrà chiesto di selezionare il voting booth a cui collegarsi.
![[Pasted image 20231209221346.png]]
Una volta selezionato dovrà essere inserita la chiave privata del booth selezionato.
Questa verrà inserita solamente in fase di avvio, e non verrà memorizzata in alcun file. Non sarà possibile cambiare la chiave senza riavviare il programma d'accapo.

Una volta inserito indirizzo e chiave privata il programma attenderà che la balance del proprio indirizzo diventi di 1 token.
![[Pasted image 20231209221637.png]]
Una volta che il chairperson avrà inviato il token, e che la balance dell'indirizzo sarà diventata 1MTK, allora si sbloccherà il programma, che chiederà all'utente di esprimere il proprio voto:

Programma chiarperson invia il token:
![[Pasted image 20231209221815.png]]
La balance dell'indirizzo adesso è di 1MTK
![[Pasted image 20231209221917.png]]
![[Pasted image 20231209221847.png]]
Una volta scelto il candidato, verrà chiesto di confermare la scelta. Se si inserisce come voto una stringa non appartenente alla lista verrà chiesto di reinserire l'input
![[Pasted image 20231209222127.png]]
Una volta confermato il programma eseguirà due operazioni:
1. Darà l'approvazione al sistema di voto di trasferire tokens in sua vece
2. Chiamerà la funzione di voto del VotingSystem 

La prima operazione viene effettuata perchè la funzione vote() del voting system necessita dell'approvazione dell'indirizzo della macchina di voto per prelevare il token di voto.

### Cifratura del voto
Prima di essere passato come argomento della funzione "vote", la stringa che contiene il voto viene cifrata.
Non cifrare il voto potrebbe portare alla compromissione dell'anonimato (se si sa che una persona ha votato FDI dalla cabina 1 in un determinato momento è facile inferire l'identità se si era presenti in sede di voto).
Inoltre non vogliamo che i voti siano visibili prima della fine delle elezioni, perchè questo potrebbe compromettere l'esito delle stesse, come discusso in precedenza.

La cifratura del voto avviene attraverso la funzione "encrypt_sequence()"
```python
sequence_to_encrypt = chosen_candidate
encrypted_sequence = encrypt_sequence(sequence_to_encrypt)
encrypted_string=encrypted_sequence.hex()
```

La funzione encrypt_sequence è stata sviluppata da me all'interno della libreria "ethereum_utils".
In [[ethereum utils| questa sezione]] trovate la documentazione dettagliata relativa a queste funzioni.
La funzione encrypt_sequence prende in input una sequenza di caratteri ed una chiave privata (che di default si trova nel file ./ministero_pub.pem) ed utilizza la chiave pubblica fornita per cifrare la sequenza.
Alla sequenza viene aggiunto un padding per evitare che sequenze di caratteri uguali vengano cifrate in modo diverso.

In questo esempio ci sono due sequenze uguali ("PD") che sono state cifrate con due sequenze diverse.
![[Pasted image 20231209224349.png]]
![[Pasted image 20231209224406.png]]

In questo esempio due stringhe di lunghezze diverse sono cifrate con stringhe di lunghezza uguale
![[Pasted image 20231209224612.png]]![[Pasted image 20231209224406.png]]

Qui c'è l'output completo del processo di voto:
![[Pasted image 20231209224712.png]]
Una volta che il voto viene confermato viene cifrata la stringa di voto (in questo caso FDI), poi viene chiamata la funzione approval ed infine la funzione di voto vera e propria.
Qui si può vedere la transazione corrispondente avvenuta su testnet Sepolia:
![[Pasted image 20231209224947.png]]
Una volta votato, l'utente è libero di uscire dalla cabina, ma, prima di poter essere libero di andare deve ricevere la conferma da parte dello staff del seggio che il suo voto sia andato a buon fine.
Principalmente questa misura viene implementata per evitare che una persona lasci pendente l'operazione di voto (con intento malevolo e non), che sarebbe l'equivalente di non consegnare la scheda di voto ed inserirla nell'urna.

### Verify.py
Verify è una semplice applicazione che fa il display in real time delle balances dei vari indirizzi delle macchine di voto.
```python
from ethereum_utils import *
import time
import curses

def display_balance_voting_booths(stdscr, voting_booths=voting_booths):
    curses.curs_set(0)  # Hide the cursor
    while True:
        stdscr.clear()
        for booth in voting_booths:
            balance_str = "The balance of the voting booth {} is: {}".format(booth, mu_get_balance(booth))
            stdscr.addstr(balance_str + "\n")

        stdscr.refresh()
        time.sleep(1)  # Adjust the sleep duration as needed

if __name__ == "__main__":
    curses.wrapper(display_balance_voting_booths, voting_booths)

```

Il programma utilizza un wrapper di una libreria chiamata curses, l'ho usata per evitare di stampare in loop gli indirizzi dei voting booths.
Nella gif qui sotto si può vedere il programma verify in esecuzione: con il terminale di sinistra invio un token al secondo indirizzo, che dopo qualche secondo risulta avere un token.
![[verify 1.gif]]
Una volta verificato dall'operatore che il voto è andato a buon fine (cioè che il token è stato speso) allora il votante è libero di andare.


## Conteggio dei voti
Si possono richiedere liberamente i voti in ogni momento della votazione tramite la funzione del voting System: "getEncryptedVotes()".
Però questi voti sono ovviamente cifrati.
![[EncryptedVotes.gif]]
I voti cifrati possono essere decifrati solamente quando l'autorità competente (il ministero dell'interno ad esempio), decide di rilasciare la chiave privata necessaria a decifrare la votazione. 
Questo assicura che il voto non possa essere visto da nessuno che non sia autorizzato direttamente dal ministero dell'interno prima della fine delle votazioni.
Una volta ottenuta la chiave privata del ministero dell'interno basta un semplice script come quello qui sotto per decifrare i voti:
```python
from ethereum_utils import *

votes_list_encrypted=get_encrypted_votes()

i=0
for encrypted_vote in votes_list_encrypted:
    i=i+1
    if len(encrypted_vote)>10:
        print("vote number "+str(i)+" is "+str(decrypt_sequence(bytes.fromhex(encrypted_vote)))+" and encrypted was:  "+encrypted_vote[1:10]+"...")
    else : print(str(encrypted_vote))
```
![[Pasted image 20231210002404.png]]

La funzione "decrypt_sequence" è la gemella della già citata "encrypt_sequence" che veniva chiamata dal voting booth per cifrare il voto.
In [[ethereum utils| questa sezione]] trovate la documentazione riguardante questa ed altre funzioni progettate da me ed utilizzate in questo progetto.