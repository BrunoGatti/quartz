How do we align diverse languages in one semantic space?

### Semantic Hub hypothesys
LLMs learn a common hub where semantically similar inputs from different langauges have similar representations in the intermediate layers.

### Cross Lingual inconsistencies
LLMs give different answers or representations for the same question asked in different languages. So, semantic representations are not fully generalized in the multilingual context.

## IDEA
Dovremmo addestrare un modello piccolo con un dataset sbilanciato di lingue, uno bilanciato e uno parallelo e vedere in quali si ha maggiore share di knowledge.

In un real world setting la conoscenza deve essere condivisa anche se il dataset di addestramento non è bilanciato.
Dovremmo inventarci un sistema perchè questo accada. 
Allineare la rappresentazione interna interlingua? Oppure aumentando il dataset con traduzione automatica?

## Lens
Lens fa proprio questo, allinea la rappresentazione interna del modello per unificare le lingue.
Reject a ICLR 2025. Però da leggere. Inoltre nelle rebuttal il metareviewer dice che il lavoro è molto simile ad altri, il che vuol dire che c'è altra roba da leggere.
