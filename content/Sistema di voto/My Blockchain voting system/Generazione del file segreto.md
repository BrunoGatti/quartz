All'avvio sia delle applicazioni di voting booth, sia a quella del chairperson verrà richiesto l'inserimento di una password.
Questa password viene usata per decifrare il contenuto di un file che contiene la chiave privata e le API keys del nodo ethereum.

Il file è stato generato utilizzando questo script python

```python
from encrypt_decrypt_password import encrypt_data_with_password

#run this script to generate the file containing the password protected secrets.

# User-provided password
password = input("Enter a password: ")

# Sensitive data to encrypt (e.g., private key and API key)
private_key = input('insert the private key of the chairperson')
api_key = input('insert the api key of the chain')

# Encrypt and store data in a file
encrypted_private_key = encrypt_data_with_password(password, private_key)
encrypted_api_key = encrypt_data_with_password(password, api_key)

with open("encrypted_keys.txt", "wb") as file:
    file.write(encrypted_private_key)
    file.write(b"\n")  # Separate private key and API key
    file.write(encrypted_api_key)

```

Viene chiesto all'utente di inserire una password da memorizzare, la chiave privata del "chairperson" e la chiave API del nodo ethereum.
In questo modo possiamo evitare di conservare in chiaro questi importanti dati all'interno del file system del progetto.

La funzione "encrypt_data_with_password" è una funzione sviluppata da me.
Qui sotto ci sono le funzioni utilizzate per criptare e decriptare il file.

```python
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import serialization
from cryptography.fernet import Fernet
import base64
import os


#This file contains the utilities necessary to encrypt and decrypt the sensible files that the program needs to access,
#namely the API key and the private key of the chairperson, those files are locked and unlocked using a password, and the secrets are hashed using a sha256 based algorith based algorit based algorithmhmm

def generate_key_from_password(password, salt):
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        iterations=100000,  # Adjust the number of iterations as needed
        salt=salt,
        length=32  # Key length (256 bits)
    )
    key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
    return key

def encrypt_data_with_password(password, data):
    salt = os.urandom(16)  # Generate a random salt
    key = generate_key_from_password(password, salt)
    fernet = Fernet(key)
    encrypted_data = fernet.encrypt(data.encode())
    return salt + encrypted_data

def decrypt_data_with_password(password, encrypted_data):
    salt = encrypted_data[:16]  # Extract the salt from the data
    key = generate_key_from_password(password, salt)
    fernet = Fernet(key)
    decrypted_data = fernet.decrypt(encrypted_data[16:]).decode()
    return decrypted_data

def read_and_decrypt(file_path,password):
    with open(file_path,"rb") as file:
        chairperson_private_key = decrypt_data_with_password(password,file.readline().strip())
        api_key= decrypt_data_with_password(password,file.readline().strip())
    return chairperson_private_key,api_key

```

### "encrypt_data_with_password"
1. Genera una sequenza di "salt" di 16 caratteri randomici
2. chiama la funzione generate_key_from_password che genera la chiave di cifratura a partire dalla password scelta e dal sale
3. Genera un istanza di [Fernet](https://github.com/fernet/spec/): un'implementazione di cifratura a chiave simmetrica
4. utilizza Fernet per cifrare i dati 

### "generate_key_from_password"
La funzione "generate key from password" viene chiamata dalla funzione "encrypt_data_with_password" come mezzo per generare una chiave sicura a partire dalla password fornita dall'utente e dal sale.
Per farlo viene utilizzata "PBKDF2HMAC" che è una "key derivation function".
Le "key derivation functions" derivano dei byte adeguati alle operazioni crittografiche dalle password o da altre fonti utilizzando un PRF (pseudo random function).
La chiave viene poi codificata usando base64 per renderla leggibile testualmente.