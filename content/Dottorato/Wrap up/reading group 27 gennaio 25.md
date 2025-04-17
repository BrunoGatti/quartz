## Introduction
I think this is a really paper, not only because the finding itself is really cool, but also because even tho the experiments are quite simple in its core, the prblem itself you'll see is quite elementary, and the scientific process is straightforward.
This was a major issue for many reviewers.

## Zero Shot capabilities of LLMs are scaling
Great performances of Large language models have been observed on various benchmarks across a broad range of tasks especially in the past years. We all know that current large language model excelled in many NLP tasks solving in "zero shot" many open problems and outperforming previous State of the art.
Now of course failures are observed and have been pointed out in the litterature multiple times, but there's debate wether these kind of failures are merely a prompt engineering problem or an actual structural deficit of Large Language models' capabilities.
## AIW: alice in wonderland
To shed light on this question the authors formulated a simple logic problem inspired (but made easier) by junior Math olympiads.

>[!hint]-
>Alice has N brothers and M sisters. How many sisters does Alice's Brother has?

This is obviously a very easy problem.  The (parametric) solution is M+1. And the solution relies on the fact that Alice herself, by being a girl, is one of the sisters of her brother.

Preview: Authors observed a completely collapse of performance of state of the art models

## Formulating the problem
The authors submitted 4 different variation of the problem's parameters to the large language models.
With 3 different type of prompts: STANDARD, THINKING and RESTRICTED.
Standard being a simple formulation of the problem, Thinking being a prompt encouraging the model to reflect on the induction process necessary to solve the problem.
These variations get submitted to the models and the answers are collected, extracted and evaluated.

## Technical part

## 1:Low correct response rates 

![[Pasted image 20250127171036.png]]
Firstly it's important to notice that the vast majority of the models can't even pass the 0.2 threshold (where 0.2 is the probability of getting it right). 
The clear winners are GPT 4o and Claude 3 Opus. The only open weights model in this set of virtuous players is LLama-2 70B chat.

But does this abysmal difference translates on other well known metrics?


## 2: Strong performance fluctuations across slight AIW problem variations
The second observation is that there are strong fluctuations when it comes to performance on different variants of the same problem.
You would think that a model that has a sound comprehension of the task shouldn't struggle on the same problem with different parameters.

>[!hint]-
>Variation 1: Brothers = 3, Sisters = 6, Correct answer=7
>Variation 2: Brothers = 4, Sisters = 2, Correct answer=3
>Variation 3: Brothers = 1, Sisters = 4, Correct answer=5
>Variation 4: Brothers = 4, Sisters = 1, Correct answer=2


![[Pasted image 20250127173350.png]]

Strong fluctuations are also observed in different prompt types, but this in particular on different parameter values actually shows that the models did not understand the problem and are not able to formulate a general pattern to solve it reliably.

## These differences in performance do not translate in the usual benchmarks
Point one highlights the fact that these differences in performance in the models are not highlighted in normal benchmarks.
This figure shows that many models that perform extremely poorly in AIW have extremely good results in the MMLU benchmark.

![[Pasted image 20250127175807.png]]

A pattern can be easily observed

## "Go small, Go home"
All the models that show good performance in MMLU but terrible performance in AIW are small models.
For the authors any value p<0.1 actually means random guessing (debatable since the solution has an infinite range), and these models performa around 0.2 or less. While performing 0.8 on the MMLU benchmark, which is remarkable.
Authors go as far as to say that "We hypothesize here that the claimed strong functions of smaller scale models might be a mere illusion corroborated by broken benchmarks"
OOF.

## Overconfidence and confabulating
Remarkably tho, authors observed that even if the response was wrong, with wrong reasoning and wrong final answer, the model actually claims high quality of its answers when prompted to evaluate its reasoning process (THINKING prompting type).

![Michael Scott handshaking himself : r/MemeTemplatesOfficial](https://i.redd.it/6o5tajqclle91.jpg)

Another frequent observation can be made regarding "confabulations". Authors call a confabulation when models generate a persuasive explaination that contains reasoning-like or plausible sounding statements to backup their wrong answer.
Another type of "confabulation" that has been observed is the model refusing to answer based on some made up "privacy concerns" or supposedly ill formed problem formulation.

## AIW + : even the strongest will fall
The authors developed AIW+, a problem that uses the same logic as AIW but features additional hierarchy and distractors when describing relational family structure.
The results are an even stronger collapse of the Models, and even the strongest models on the AIW problem have a performance that's below random guessing.

![[Pasted image 20250127195049.png]]

## "Female power boost"
Another interesting experiment that was carried on by the authors was adding the redundant information "Alice is female".
I remind you that the key to the problem's solution was to infer that since Alice was referred as a "she", she was in fact a girl, therefore, part of the "sisters" count.
Clearly stating this information, although redundant, lifts the model from the duty of inferring this information from the context.
The authors observe an increasing in the average correct response, despite the information being redundant.
However the strong fluctuations that took place between different parametric versions of the problem are still there.

![[Pasted image 20250127195514.png]]

## Claude 3.5 Sonnet, an interesting story of data contamination

At the time of the first draft of this paper, Claude 3.5 Sonnet was not out yet.
So, of course when it came out the authors tested AIW on it, and surprisingly correct response rates were 1 on all  variants of the problem except for Variant 1.

![[Pasted image 20250127195916.png]]

This was suspicious to say the least, and the authors clearly suspected that the data of the work was incorporated in the training data for Claude 3.5 Sonnet.
Although we cannot be sure this happened, the authors tested Claude 3.5 Sonnet on a non released version of the AIW problem (AIW ext).
This problem has the exact parameters as the AIW problem but it's formulated differently: "Alice and Bob are sister and brother, Alice has 3 sisters and Bob has 1 brother, how many brothers does Alice have?"
The results revelaed strikingly different behviour compared to AIW.

![[Pasted image 20250127200318.png]]

As you can see performances plummeted.

## Conclusions
The dramatic breakdown of LLMs performance when confrontend with the AIW task hints on serious deficits in basic reasoning capabilities of large language models. The overall breakdown is manifested in 1. overall low correct response rates and 2. strong performance fluctuation on slight variations of the problems.
The models produce answers that are also overconfident and tend to justify their wrong answers using confabulations and illogical reasoning.
The authors als hypotesize that the performance of lower weights models on reasoning tasks may be a mere illusion corroborated by broken benchmarks.

## Personal conclusions
Personally i think that the authors don't stress enough the fact that they exposed larger models to be unable to make a simple inference and that explicitly providing that information (although superfluous) boosts performances, in some cases, dramatically.

![[Pasted image 20250127204307.png]]
Highlighting that inference may be indeed a missing link in today's language models.

## Common concerns

This paper may seem "anecdotal", but it is not. They conduct systematic evaluation of correct response rates fo various SOTA models and execute control experiments to rule out various low level issues as source of observed failures and fluctuations.

>[!hint]- Authors dont have enough evidence to say why this happens"
>the scope of this paper is pointing out the failure and rule out low level issues that might've caused this failure. As to why this happens, this is the scope of future research.

>[!hint]- It's common opinion between the authors that one example is not sufficient to say much about a model's capabilities. 
>
>Main goal of the study is to provide convincing flasification of the hypothesis that posits strong zero-shot generalization and robust basic reasoning exhibited by current SOTA LLMs

>[!hint]- "what does this paper add to the conversation about wether LLMs can reason or generalize"
>

