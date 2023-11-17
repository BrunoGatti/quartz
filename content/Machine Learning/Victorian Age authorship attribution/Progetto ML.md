## Il task
Victorian Age [[authorship attribuition]], questo [dataset](https://dataworks.iupui.edu/handle/11243/23)è il più grande dataset per l'attribuzione di autore di Era Vittoriana.
In questo dataset ci sono 50 autori dell'età vittoriana. O meglio, 45 vengono forniti nel training set e 50 vengono forniti nei dati di testing, questo per creare un problema non esaustivo. Ogni istanza è rappresentata da un testo di 1000 parole.
Per rendere le cose più difficili, tra il training set e il testing set sono stati individuati diversi libri per ogni autore.

## La struttura del progetto
L'idea è quella di fare uno showcase di alcuni possibili approcci a questo problema per poi vedere quale è il migliore.

### Struttura:
1. [[#Dataset pre processing]]
2. Feature extraction techniques:
	- Word2Vec
	- Bag of words: tf-IDF
	- tf-IDF piped with n-grams
	- DistilBert(?)
3. Reducing the number of features: SVD
4.  Testing the classifiers:
	- Naive Bayes: the baseline
	- SVM 
	- DistilBert (?)
5. Risultati ottenuti

## Dataset pre processing

Il dataset ha solamente due colonne: 'text' e 'author', che indicano rispettivamente l'intera porzione di testo e l'autore del suddetto.

```python
# Load your training dataset
train_data = pd.read_csv('/content/drive/MyDrive/progetto ML/Gungor_2018_VictorianAuthorAttribution_data-train.csv', encoding='latin1')

train_data.head()
```

![[Pasted image 20231116112213.png]]

Il pre processing del dataset è stato fatto con 