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
            {
                "start": 0,
                "end": 11,
                "role": "Theme"
            },
            {
                "start": 11,
                "end": 12,
                "role": "V"
            },
            {
                "start": 12,
                "end": 17,
                "role": "Attribute"
            }
        ]
    }
],
```

<span class="red">snt. Arthur Schnitzler (15 May 1862 – 21 October 1931)</span> <span class="blue"> was </span> <span class="green">an Austrian author and dramatist</span>.


