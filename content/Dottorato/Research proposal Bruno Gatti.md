![[20240520_122932.jpg]]
## Summary
A long-term goal of Artificial Intelligence is to achieve a deeper semantic understanding of language. The research area involved in achieving this goal is Natural Language Understanding (NLU). Many NLU tasks focus on linking explicit knowledge to text, and one of those tasks is Semantic parsing.
Semantic parsing's objective is to convert sentences into machine-readable  representations of its underlying meaning, so that the dream of machines actually understanding human language may come true.
Explicit semantics annotations have proven very useful in many task related but not limited to the NLU field: it provides high-quality enrichment to training data that can be used to train more accurate and robust machine learning models, it enhances Question answering capabilities to understand and answer complex queries and, most of all, it gives NLP systems the potential to address many of its open problems.
Therefore I propose to develop a large-scale multilingual knowledge base of semantically annotated phrases: a knowledge base that will be acquired by plain text through an automatic process, therefore significantly mitigating costs of manual annotation and will serve as a powerful resource for semantic parsing to facilitate more accurate language understanding across multiple languages. 
This will prove extremely useful not only to address the Data paucity of the Semantic parsing field, but also to allow unlocking new capabilities of language models like Naturale language inference and reasoning.
My research will focus on creating this comprehensive resource, using it to train advanced neural network models for semantic parsing, and demonstrating its utility in improving NLU applications such as machine translation and information extraction. This approach aims to overcome current limitations in multilingual semantic representation and unlock the potential for machine reasoning and truly universal language understanding.


## State of the art of the research field
Abstract meaning representation (AMR) is arguably the most popular framework for Semantic Parsing. It has many promising applications including but not limited to: Machine transaltion, text summarization, Human Robot Interaction, Informal Extraction and Question aswering.
AMR models meaning using graphs where nodes are English lemmas or disambiguated predicate senses and edges are semantic relationships between them.
Even though many research effort have been made to adapt AMR to a larger set of languages (Barnescu et al 2013), there are challenges in this sense that are yet to be overcomed to make it a real fully semantic formalism, which by consequence makes it unfit to be an interlingua formalism.
One of these challenges is that AMR draws its concepts from English lexicon, and from Propbank, which is based on the English language. The second problem is the lack of a large scale annotated corpus. This problem is deeply connected to the lack of a multilingual fully semantic formalism. In that sense efforts have recently been made, to develop a truly semantic formalism: BMR [4], but both BMR and AMR rely on seq2 seq models for parsing, this means that there's a huge obstacle when dealing with the size of the vocabulary. BMR in particular deals with BabelNet concepts, in total this means 21,800,868 vocabulary terms, which is a prohibitive size.

## Objectives, content and methodology
The main focus of my research effort will be building a large scale corpus of multilingual annotated data for semantic parsing.
This will address the following challenges:

- Data Paucity in semantic parsing:  a general resource for semantic parsing has long been advocated in the field of natural language understanding, it has been shown, in fact, that semantic parser have a huge problem in performance when not dealing when examples from the same distribution as the training set. Developing a large annotated Knowledge base would be of great benefit.
- 



## Bibliografia
3. [17] Abelardo Carlos Mart´ınez Lorenzo, Marco Maru, and Roberto Navigli. Fully-Semantic Parsing and Generation: the BabelNet Meaning Representation. In Proceedings of the 60th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers), pages 1727– 1741, Dublin, Ireland, May 2022. Association for Computational Linguistics. URL: https://aclanthology.org/2022.acl-long.121, doi: 10.18653/v1/2022.acl-long.121.
4. Michele Bevilacqua, Rexhina Blloshmi, and Roberto Navigli. One spring to rule them both: Symmetric amr semantic parsing and generation without a complex pipeline. Proceedings of the AAAI Conference on Artificial Intelligence, 35(14):12564–12573, May 2021. URL: https://ojs.aaai.org/ index.php/AAAI/article/view/17489.



## Colloquio orale

### Info generali
data: 9 luglio alle 11 fino alle 11:30
durata presentazione: 15 minuti
durata totale colloquio: 30 minuti

### Presentazione

Vorrei mettere subito in evidenza i limiti dei modelli di linguaggio ed il motivo per cui potrebbe servire questa risorsa che ho proposto.

Gli LLMs hanno problemi --> Common sense, logical reasoning, knowledge base grounding
Structured data can be the solution --> Il problema è che i dati strutturati sono Pochi, non connessi, domain specific e annotati in maniera diversa


1. what is the difference between what you're proposing and MOSAICo
2. perchè non avere dati è un problema alla realizzazione di un parser BMR?
   multilingual data has been shown to improve the performance of state of the art semantic parsing, that have difficulty scaling outside of their domain. 