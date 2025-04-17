A well known problem in machine translation is dealing with Entity Names. The challenge comes from the fact that the translation of entity names may not be a literal transaltion from the source language, but what's called a [[transcreation]] ([Diaz-Millon and Olver-Lobo 2023](https://www.tandfonline.com/doi/full/10.1080/0907676X.2021.2004177)).
Questo paper utilizza wikidata, uno dei sistemi più popolari per knowledge graphs multilingua, per aumentare l'affidabilità delle traduzioni di named entities per sistemi di machine translation.
Questo sistema è chiamato "Wiki-MT"

### Knowledge retriever
The first step is to use a Knowledge retriever that, given an input query $q$, collects from Wikidata the top-$n$ entities $$E = \{e1,e2,e3 ... en\}$$ That are most relevant to $q$.
This is done leveraging the vector representation of the document and the query and computing the cosine similarity.

### Translation step
Given a source language $L_{s}$ and a target language $L_t$ we want to translate a query $Q$.
This system also takes as input the set of top-n entities of the previous step $E=\{e1,e2,e3\}$
For each entity we obtain from the documents the translation in the target language.

$q'=q\ \bigoplus\ [META]\ name(e1,l_s)\ [AS]\ name(e1,l_t)\ \bigoplus\ [META]\ name(e2,l_s)\ [AS]\ name(e2,l_t)\ \bigoplus\ [META]\ name(e3,l_s)\ [AS]\ name(e3,l_t)$

$\bigoplus$ is the append operation and $[META]$  and $[AS]$ are special tokens used to separate entities and name translations.

![[Pasted image 20241118110851.png]]