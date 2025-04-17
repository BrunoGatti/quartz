
# Per il 22 Gennaio

Primo obiettivo è quello di riprodurre i risultati di arie cattan.
Il readme dice che bisogna fare i seguenti passi

#### Tuning threshold for agglomerative clustering

The training above will save 10 models (one for each epoch) in the specified directory, while each model is composed of a span_repr, a span scorer and a pairwise scorer. In order to find the best model and the best threshold for the agglomerative clustering, you need to do an hyperparameter search on the 10 models + several values for threshold, evaluated on the dev set. To do that, please set the `config_clustering.json` (`split`: `dev`) and run the two following scripts:

```
python tuned_threshold.py --config configs/config_clustering.json

python run_scorer.py [path_of_directory_of_conll_files] [mention_type]
```


Problema è che run_scorer ha qualcosa che non va

```
python run_scorer.py /home/martinelli/xcoref/coref/data/ecb/gold_singletons/ events
```
Intatno gli unici file "conll" che abbiamo all'interno del progetto sono all'interno di una directory chiamata "gold_singletons". Che però in teoria non è quello che ci interessa perchè noi non vogliamo i singletons.
Secondo anche mandando lo script con questo file otteniamo un errore:

```
(xcoref) martinelli@martinelli:~/xcoref/coref$ python run_scorer.py /home/martinelli/xcoref/coref/data/ecb/gold_singletons/ events
Processing file: dev_entities_topic_level.conll
Traceback (most recent call last):
  File "run_scorer.py", line 85, in <module>
    main()
  File "run_scorer.py", line 33, in main
    keep_singletons, min_span)
  File "run_scorer.py", line 49, in evaluate
    remove_nested, keep_singletons, min_span)
  File "/home/martinelli/xcoref/coval/coval/conll/reader.py", line 387, in get_coref_infos
    key_doc_lines = get_doc_lines(key_file)
  File "/home/martinelli/xcoref/coval/coval/conll/reader.py", line 310, in get_doc_lines
    with open(file_name) as f:
FileNotFoundError: [Errno 2] No such file or directory: 'data/ecb/gold/dev_events_topic_level.conll'
```

Questo errore indica che lo script sta cercando un file chiamato "'data/ecb/gold/dev_events_topic_level.conll'" 
Questo file non esiste. Il che mi torna perchè non trovo le "gold" mentions ma solo le golld_singleton mentions.
I file conll sono "estratti" da ECB+ usando uno script di cattan chiamato "get_ecb_data.py"
Ma non sembra che lo script abbia nessuna intenzione di creare una cartella chiamata in questo modo.

```
mentions_path = os.path.join(args.output_dir, 'mentions')

gold_conll_path = os.path.join(args.output_dir, 'gold_singletons')
```
Queste sembrerebbero essere le uniche linee di codice che creano una directory. Ed infatti torna con il fatto che le uniche directory a mia disposizione sono proprio mentions e gold_singletons.

Dentro mentions non abbiamo file di tipo conll ma solo file json. Mentre gold_singletons:

![[Pasted image 20250116133844.png]]
Di nuovo, questo potrebbe significare che questi sono i file corretti con le gold mentions? Però non sembrerebbe così. Ma sono gli unici file conll che abbiamo.

A questo punto direi di continuare ed andare avanti e provare a replicare i risultati usando il modello numero 6. Sperando che sia quello ottimo. Per quanto riguarda il treshold userò anche quello di default specificato nel file di configurazione da Arie Cattan, senza quindi fare grid search sugli iperparametri. Che mi risulta impossibile.

## Cosa abbiamo

Il gold file

"coref/models/pairwise_scorers/test_entities_average_0.75_model_6_topic_level.conll"

```
(xcoref) martinelli@martinelli:~/xcoref$ python /home/martinelli/xcoref/coreference_resolution_evaluation/util/corefconversion/conll2jsonlines.py coref/models/pairwise_scorers/test_entities_average_0.75_model_6_topic_level.conll ./prova.html
Doing 41
Traceback (most recent call last):
  File "/home/martinelli/xcoref/coreference_resolution_evaluation/util/corefconversion/conll2jsonlines.py", line 200, in <module>
    main()
  File "/home/martinelli/xcoref/coreference_resolution_evaluation/util/corefconversion/conll2jsonlines.py", line 194, in main
    par_col=args.par_col,
  File "/home/martinelli/xcoref/coreference_resolution_evaluation/util/corefconversion/conll2jsonlines.py", line 124, in conll2jsonlines
    [token[int(speaker_col)] for token in sent] for sent in doc
  File "/home/martinelli/xcoref/coreference_resolution_evaluation/util/corefconversion/conll2jsonlines.py", line 124, in <listcomp>
    [token[int(speaker_col)] for token in sent] for sent in doc
  File "/home/martinelli/xcoref/coreference_resolution_evaluation/util/corefconversion/conll2jsonlines.py", line 124, in <listcomp>
    [token[int(speaker_col)] for token in sent] for sent in doc
IndexError: list index out of range
```


Il predicted file

"coref/models/pairwise_scorers/test_entities_average_0.75_model_6_topic_level.conll"


# Per 29

Analisi del problema: quanto il context inficia LD e CD coreference.
Una volta capito quanto è importante dobbiamo risolverlo.

Run experiments to analyze the behaviour.


