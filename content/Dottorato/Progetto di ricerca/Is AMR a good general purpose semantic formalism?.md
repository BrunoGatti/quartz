La mia intuizione è che per quanto AMR cerchi di essere un formalismo adatto alla semantica generale, non credo lo sia esattamente.
AMR, come del resto altri formalismi, cattura solo un aspetto della semantica delle frasi, trascurandone altri, come ad esempio gli entailment logici.

"Alice has 3 brothers and 2 sisters"

```pennman
(b / brother
    :domain (p / person :name "Alice")
    :quant 3
    :poss (a / alice)
    :mod (q / question
        :op1 (s / sister
            :quant ?
            :poss (b2 / brother
                :poss (a)
                :quant 3))))
```

The fact is that we are not able to correctly perform induction or deduction on this set of statements.

But.

My guess was that using a deduction/induction compatible formalism like fist order logic would have solved this.
This does not seem to be the case, even if the llm does a correct formalization of the problem in FOL it then generates a wrong answer nonetheless.

![[Pasted image 20250301111924.png]]

Stessa cosa se gli chiedo di formalizzare con prolog: la formalizzazione risulta giusta, ma GPT da come risultato atteso di questa formalizzazione "3".

![[Pasted image 20250301112035.png]]

![[Pasted image 20250301112109.png]]

Questo però è il risultato previsto da chat GPT non la vera esecuzione del programma che ha scritto, che invece è 4:

![[Pasted image 20250301112155.png]]

Che sarebbe poi la risposta giusta.
Se infatti mettiamo il programma dentro swi prolog il risultato è 4: cioè il risultato corretto.
Questo potrebbe significare che i current state of the art LLMs possiedono già la capacità di formalizzare correttamente i problemi di logica del primo ordine, ma non hanno la capacità di effettuare un ragionamento induttivo/deduttivo automatico.
Questo però potrebbe essere risolto aggiungendo prolog nella pipeline del modello.

## Come procedere

Testare altri quesiti difficili per gli LLMs e formalizzarli in logica del primo ordine con prolog, vedere poi se il risultato di prolog è costantemente migliore rispetto a quello di GPT.
