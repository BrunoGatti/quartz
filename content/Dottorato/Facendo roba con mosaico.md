## Estrazione di alberi semantici
L'idea è quella di prendere le frasi di SRL ed estrarre alberi semantici. Quegli alberi devono essere associati alla frase.
C'è inoltre il problema di individuare le teste semantiche in una frase.

```json
[
{
        "predicate": {
            "token_idx": 11,
            "label": "COPULA"
        },
        "arguments": [
            {#rosso
                "start": 0,
                "end": 11,
                "role": "Theme"
            },
            {#ble
                "start": 11,
                "end": 12,
                "role": "V"
            },
            {#verde
                "start": 12,
                "end": 17,
                "role": "Attribute"
            }
        ]
    }
],
```

<span class="red">snt. Arthur Schnitzler (15 May 1862 – 21 October 1931)</span> <span class="blue"> was </span> <span class="green">an Austrian author and dramatist</span>.

Ovviamente questo non è un albero semantico perchè le due frasi 

<span class="red">snt. Arthur Schnitzler (15 May 1862 – 21 October 1931)</span> e <span class="green">an Austrian author and dramatist</span>
non sono disambiguate, ma l'idea è che dovrebbero essere degli alberi semantici anche loro che però hanno una testa semantica che non è un verbo.
Intanto per estrarre la testa semantica di questi complementi. Per questo c'è l'articolo di tommaso che devo leggere ancora bene ma sostanzialmente permetterebbe di trovare le teste semantiche e l'albero relativo.

Inoltre c'è la questione di AMR. Questi alberi sono semplici relazioni di semantic role labeling ma noi abbiamo anche AMR trees. 