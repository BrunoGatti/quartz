# Trouble replicating the results for entities

I'm having trouble replicating the results for entities using gold mentions.

As the Readme suggests i'm only training the pairwise scorer since i'm using gold mentions:

``` bash
python train_pairwise_scorer.py --config configs/config_pairwise.json
```

The configuration file is the following. Left untouched by default settings exception made for "mention_type" which i set to "entities" and "use_gold_mentions" which was set to "true".
I also added the hyperparameters suggested in the paper for entities: top_k= 0.35 and max_mention_span=15.


```
{
"gpu_num" : [0],
"bert_model": "roberta-large",
"bert_hidden_size": 1024,
"hidden_layer": 1024,
"dropout": 0.3,
"with_mention_width": true, 
"with_head_attention": true,
"embedding_dimension": 20,
  
"max_mention_span": 15,
"use_gold_mentions": true,
"mention_type": "entities",
"top_k": 0.35,
"training_method": "continue",
"subtopic": true,
"use_predicted_topics": false,
"segment": true,
  
"random_seed": 0,
"epochs": 10,
"batch_size": 32,
"learning_rate": 1e-4,
"weight_decay": 0,
"loss": "bce",
"optimizer": "adam",
"adam_epsilon": 1e-8,
"segment_window": 512,
"neg_samp": true,
"exact": false,
  
"log_path": "logs/pairwise_scorer/",
"data_folder": "data/ecb/mentions",
"span_repr_path": "models/span_scorers/events_span_repr_0",
"span_scorer_path": "models/span_scorers/events_span_scorer_0",
"model_path": "models/pairwise_scorers"
}
```

After training the pairwise scorer i ran the tuned_threshold.py script

```
python tuned_threshold.py
```

with the following configuration

```
{
"gpu_num" : [0],
  
"bert_model": "roberta-large",
"hidden_layer": 1024,
"dropout": 0.3,
"with_mention_width": true,
"with_head_attention": true,
"embedding_dimension": 20,

"max_mention_span": 15,
"use_gold_mentions": true,
"mention_type": "entities",
"top_k": 0.35,
"split": "dev",
"training_method": "continue",
"subtopic": true,
"use_predicted_topics": false,
"segment_window": 512,
"exact": false,

"topic_level": true,
"predicted_topics_path": "/home/nlp/ariecattan/coreference/event_entity_coref_ecb_plus/data/external/document_clustering/predicted_topics",
  
"data_folder": "data/ecb/mentions",
"save_path": "models/pairwise_scorers",
"model_path" : "models/pairwise_scorers",
"model_num": 6,
"keep_singletons": true,
  
"threshold": 0.75,
"linkage_type": "average"
}
```

I set "use_gold_mentions" to "True", metion_type to "entities", subtopic was set to true (as the previous configuration file), set "use_predicted_topics" to "False" and set "topic_level" to "True".
Of course "split" was set to "dev".

Then i ran the evaluation script to evaluate the performance on the dev set to select the best model and best threshold:

```
python run_scorer.py models/pairwise_scorers/ entities
```

Best model seems to be model 6 with 0.75 threshold

```
('dev_entities_model_6_average_0.75_topic_level.conll', 77.62412834041776)
```

Performance of 77.62 does not repete on the test set tho.
I proceeded to predict changing the config file "split" to "test":

```
python predict.py
```

And in the end run the evaluation.
The evaluation script is a modified version of "run_scorer" preovided in the repo, that leverages the "coval" library to evaluate all sys files (containing the prediction output) in a target directory.

Here's the script if you want to look into it, but it's a very slight modification of what's already in the repo:

```
import sys
from coval.conll import reader
from coval.conll import util
from coval.eval import evaluator
import pandas as pd
import os
from utils import *



def main():
    allmetrics = [('mentions', evaluator.mentions), ('muc', evaluator.muc),
            ('bcub', evaluator.b_cubed), ('ceafe', evaluator.ceafe),
            ('lea', evaluator.lea)]

    NP_only = 'NP_only' in sys.argv
    remove_nested = 'remove_nested' in sys.argv
    keep_singletons = ('remove_singletons' not in sys.argv
                       and 'removIe_singleton' not in sys.argv)
    min_span = False

    path = sys.argv[1] #path to prediction output directory (conll file) 
    mention_type = sys.argv[2]
    key_file = 'data/ecb/gold_singletons/test_{}_topic_level.conll'.format(mention_type)
    print(key_file)

    all_scores = {}
    max_conll_f1 = (None, 0)

    for sys_file in os.listdir(path):
        if sys_file.endswith('conll') and 'topic' in sys_file: # and sys_file.startswith('dev'):
            print('Processing file: {}'.format(sys_file))
            sys_file_full_path = os.path.join(path, sys_file)
            scores = evaluate(key_file, sys_file_full_path, allmetrics, NP_only, remove_nested,
                    keep_singletons, min_span)
            all_scores[sys_file] = scores
            if scores['conll'] > max_conll_f1[1]:
                max_conll_f1 = (sys_file, scores['conll'])

    df = pd.DataFrame.from_dict(all_scores)
    df.to_csv(os.path.join(path, 'all_scores.csv'))


    print(max_conll_f1)



def evaluate(key_file, sys_file, metrics, NP_only, remove_nested,
        keep_singletons, min_span):
    doc_coref_infos = reader.get_coref_infos(key_file, sys_file, NP_only,
            remove_nested, keep_singletons, min_span)

    conll = 0
    conll_subparts_num = 0

    scores = {}

    for name, metric in metrics:
        recall, precision, f1 = evaluator.evaluate_documents(doc_coref_infos,
                metric,
                beta=1)

        scores['{}_{}'.format(name, 'recall')] = recall
        scores['{}_{}'.format(name, 'precision')] = precision
        scores['{}_{}'.format(name, 'f1')] = f1

        if name in ["muc", "bcub", "ceafe"]:
            conll += f1
            conll_subparts_num += 1

        # print(name.ljust(10), 'Recall: %.2f' % (recall * 100),
        #         ' Precision: %.2f' % (precision * 100),
        #         ' F1: %.2f' % (f1 * 100))

    scores['conll'] = (conll / 3) * 100


    return scores

    # if conll_subparts_num == 3:
    #     conll = (conll / 3) * 100
    #     print('CoNLL score: %.2f' % conll)


if __name__ == '__main__':

    main()


```

The result is that the performance on the test set is:

```
('test_entities_average_0.75_model_6_topic_level.conll', 65.87620331732849)
```

|                    |                                                      |
| ------------------ | ---------------------------------------------------- |
|                    | test_entities_average_0.75_model_6_topic_level.conll |
| bcub_f1            | 0.6382328556153098                                   |
| bcub_precision     | 0.662919620803559                                    |
| bcub_recall        | 0.6153187219437987                                   |
| ceafe_f1           | 0.5135578624471377                                   |
| ceafe_precision    | 0.4686215494830131                                   |
| ceafe_recall       | 0.5680261205854704                                   |
| conll              | 65.87620331732849                                    |
| lea_f1             | 0.6124714927436816                                   |
| lea_precision      | 0.6366462211440892                                   |
| lea_recall         | 0.590065526346465                                    |
| mentions_f1        | 0.8902112466527821                                   |
| mentions_precision | 0.8707799767171129                                   |
| mentions_recall    | 0.9105295191722459                                   |
| muc_f1             | 0.8244953814574069                                   |
| muc_precision      | 0.8152909336941814                                   |
| muc_recall         | 0.8339100346020761                                   |