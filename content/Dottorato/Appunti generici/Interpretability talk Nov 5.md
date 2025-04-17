## Perturbation atribution for language Models
Changing the inputs of the model and see how it affects the prediction

"Welcome back ladies and----" Gentlemen 90% confidence
"Welcome back ---- and -----" Gentlemen now has 2% confidence

WE can confront the two distributions on the vocabulary using KL divergence of these distributions.

If you don't have access to the structure of the model this is as good as it gets. This is a BLACK BOX aproach.
This could be applied to closed source models like chat gpt


## Gradient based feature importance
Choose the input token that is influencing the most an output token.
INSEQ: interpretability for sequence generation models

Given any open source model what you can provide is an api
![[Pasted image 20241105112708.png]]

### An example
An example of this. In this example we can see something fishy: in this equation it is not looking at the answer!

![](https://lh7-rt.googleusercontent.com/slidesz/AGV_vUdng3Xo2CK3wTccCzdcovMm4Wty1rT9VuyjmFTXyauHOPiwpU3lWiO3nQxRcI8QgVEClDBb_hGWEWPIMJr0kJBz01jEmvkHg8Oolq1F6PsFGu23c4Ai0aw6rdzOUti2x5YlM8_mZUm3MfNvAS55T4JRAv6ZMkbU=s2048?key=owy-Bm35ZJXO8MLC3_-66wHH)**

## Contrastive attribution
A new approach 

"Can you stop the dog from ----"
output: barking

Why barking? Why didn't the model said "crying"? Because it's a dog of course. Instead of taking the probability of one option lets take the probability of the two tokens.
We can do contrastive attribution to see the difference in generation probability for these two outputs

## Local explainability <sub>sampling methods </sub>

both feature and data attribution have issues in benchmarkings. I dont know if the results are correct/meaningful/ the best ones.

Sampling methods are different. If before most of the methods are based on linearization with sampling methods you take the model and replace with another one.

### Surrogate models

![[Pasted image 20241210215417.png]]

![[Pasted image 20241210222942.png]]

![[Pasted image 20241210223214.png]]
![[Pasted image 20241210223559.png]]
![[Pasted image 20241210224256.png]]