## Don't Parse Generate
Rongali,Soldaini,Monti,Hamza

 it is an influential and early systematic demonstration of the significant benefits gained by combining pretrained transformer models (like BERT and RoBERTa) with sequence-to-sequence architectures explicitly for task-oriented semantic parsing.
## Handling Ontology Gaps in Semantic Parsing
Bacciu, Damonte,Basaldella, Monti
Un paper che parla di hallucination detection in semantic parsing.
Utilizza alcuni metodi per trovare allucinazioni prima che la risposta venga effettivamente data all'utente.

## Large Language Model Based Semantic Parsing for Intelligent Database Query Engine
2024 Zhizhoung Wu

Traditional SQL semantic parsing methods do it in two steps: Intend detection (detecting what the user wants to do) and Template filling (Filling a pre defined template with entities and slots). This approach requires to manually design templates and limits query flexibility.
This approach first disambi  guates entities using W2vec and then the model (GPT 3.5) identifies key entities and their relationships, and then generates the query. The query is executed and results are returned.
They also mention a human feedback+ RL step in the pipeline.

Trained and evaluated on WikiSQL and Spider.

# Schema linking
forse è un problema chiave nel parsing semantico tex2sql.
La mia opinione è che potremmo inserire nella pipeline un modello preaddestrato, magari basato su BERT o su un LLM (anche se forse è troppo), fine tuned per rispondere alle domande sulla struttura dello schema (o qualcosa del genere).
Un linker che capisce come è fatto lo schema.

# Investigate Natural Lnaguage Interfaces