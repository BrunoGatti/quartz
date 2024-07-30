This title is pretty self explainatory. And admittedly a bit smug... but, the thing is that, up until now, electronic voting sucked.
It still sucks to this day, and there are many good reasons why it does.

## Why online voting sucks
Online voting has always been a fascinating field of study.
Letting people vote through the internet would be incredibly useful for many reasons:
1. Disabled people could have the possibility to vote from home
2. Military personnel could vote while on duty
3. Not having to take work days off during elections
Therefore increasing the number of people voting, and increasing the overall validity of the elections, while cutting the spending.

It all sounds wonderfull. Except it isn't.
Web applications (which these voting system are based on) are notoriously vulnerable, and elections are so incredibly vital for the well being of democracies that these issues should not be overlooked.
And they haven't been overlooked by researchers, that were ALWAYS very vocal about the insecurities of online voting. But that didn't stop jurisdictions and state regulators from adopting it anyways, especially after the COVID-19 pandemic.
One notable example is the Omni Ballot platform used in Delaware, West Virginia, and New Jersey in the USA, this platform had critical security issues, especially if the client or server were infected by malware. This platform also relied on many third party proprietary software, and sensible user information would pass through Amazon's servers.
For a more in depth analysis of the Omni Ballot platform, please refer to [this Specter and Alderman article](https://internetpolicy.mit.edu/wp-content/uploads/2020/06/OmniBallot.pdf).
But this is far from being news,[ this letter](https://www.aaas.org/programs/epi-center/internet-voting-letter) from leading experts in Cybersecurity already urged governors to refrain from using online voting systems.
This is a very good starting point for this project because it highlights the main issues with online voting in general, and some issues arising even with online voting using blockchain technology.

### The issues, one by one
Let's see what are the main problems:

#### malware and denial of service attacks
Personal computers and phones are susceptible to malware attacks. This is hardly news, and that's why we should design a voting system keeping in mind that, if we are using a personal computer, the device could be infected.
Denial of service attacks are also very effective since, if the voting system runs on a centralized server, this could, in the best case, cause the halting of the voting process, and in the worst case, create inconsistencies and bugs, that could ultimately invalidate the election.

#### voter authentication
This is another very complicated topic.
How can we be sure that the user using the terminal (logged into his institutional account) is the real person and not someone voting for him? This step, if we're voting from home, could mean that users should be authenticated through video or biometric scans, but even if this was possible there are two issues:
1. Can we be sure that after the user is authenticated nobody is still voting for him?
2. Can we be sure that even if he's actually voting he's not taking a screenshot of his vote (to sell his vote)?

In my opinion the answer is a big, fat, NO.
#### ballot protection
How do we protect the ballot from:
1. Being altered
2. Being destroyed
3. Being seen
This is the most arguable of these three steps. Some may argue that electronic ballots inside a server are as secure as ballots inside a paper box, if not more.
I personally think that the problem here is not the centralization of the ballots into one or more servers (even if this is certainly problematic), but more the fact that it is impossible to guarantee the integrity of the ballot, if the user's phone is infected, or if the server itself is.

#### How can we keep the voter anonymous?
This is easy for in person voting.
The voter just casts his vote into a paper box and there's no way of knowing who voted for which candidate.
This is not true for electronic voting, were each candidate has an identity, that can lead to a malicious user to map the vote to the electronic identity.
Many blockchain and "cryptographically secure" voting systems, still use a 1 on 1 correspondence between a user and a public key.
This means the if we discover that public key: 123 has voted for "Joe Biden", and then that public key 123 belongs to "John smith", we know that john smith voted for Biden.
And if you think that this is unlikely, keep in mind that the user himself could want a proof that he voted for a certain candidate (maybe because he wants to sell his vote), therefore revealing his electronic identity to a malicious entity.

#### Proof of vote
How do we prove that the vote has been cast correctly, and that has been counted?
This is pretty tricky even for in person voting.
As we saw in the 2016 USA elections, just saying "There's been election fraud, trust me", is enough to cast doubts in people's minds. 
Of course, for in presence voting, the correct counting of votes is guaranteed by the presence of public officials. But what about developing countries where public officials are possibly not on the people's side?

## Let's solve some problems (by not solving them)
As you can see, researchers have concluded, that to this day, in person voting is still superior in all aspects to online voting.
The solution? Instead of reinventing the wheel, let's just not abandon in person voting. Let's improve on it!
Instead of using technology to radically change the system, we can use it to improve it, to make it faster, more transparent, more efficient, and resistant to frauds (and fraud claims in return).

### No more online authentication
If we keep in person voting, we can cross many vulnerabilities of the voting system.
1. We don't have to worry anymore about electronically authenticating the user
2. We don't have to develop fancy systems to manage sensible user data.
3. We can be sure that the voter himself voted

### Authorized terminals only
We don't have to worry about users being infected by malware too, since the voters will only vote with terminals that are set up by the election officials. And while yes, the terminal itself could in principle be infected, this is not likely unless the officials themselves are colluded (which is still a disastrous perspective even when talking about in person voting as it is today).!

### This is not a revolutionary idea
something similar was already implemented for Obama Romney in 2012.
With famously disastrous outcomes:

![[tumblr_inline_nxcbjfnbyd1shsvef_1280.gif]]

But this was a machine glitch, not a problem with the design of the voting system.
And this is still not enough!

### There are still tons of issues
Namely we still don't know how to handle voting privacy, anonimity, vote integrity, we still can't give the user a verifiable proof of his vote.
And here's why blockchain cold be actually pretty useful.

## Blockchain voting systems (and why they suck)
If you've been living under a rock for the past ten years, blockchain is a technology that's been around for a decade or so, invented by Satoshi Nakamoto and proposed in [this historic paper](https://bitcoin.org/bitcoin.pdf).
The cool thing about blockchain is that you don't need a centralized authority to manage a ledger, that, in the case of monetary transaction, records the various transaction between accounts (identified by a public key).
So blockchain offers a public, transparent yet secure and decentralized system.

### The catch with traditional voting system based on blockchain
So far, to my knowledge, voting system based on blockchain, are either modeled as fully remote or have another critical flaw: each address on the blockchain identifies a user.
The idea behind this kind of voting systems is that a user can sign transactions using his public key (maybe assigned by the government) and votes on the blockchain, leveraging the power of Decentralized applications.
The main problem in my opinion is that doing so exposes user privacy.
A one to one mapping between keys and people means that users are eventually identifiable.
The nature of the blockchain offers transaction transparency, so anyone can see the the address that issued a specific transaction. This means that who's in charge of counting the votes, can also see who cast it (in the form of its key).
At that point, it's only a matter of knowing who's key it is to compromise vote anonimity.
Again, if you think this is stupid, just remember that a voter may WANT to be identifiable, this way he can sell his vote!

## My voting system

### The basic idea
Now that we saw what i think are the systems that suck, let's see why mine does not.
First of all my system is a hybrid voting system, just like i said before, instead of trying to solve the problem of user identification by creating a ton of other problems, the identification will be held in presence (remember, we're not here to make the impossible possible, we're just trying to improve the state of the art).

**The main difference, with traditional voting systems, is that the voters WILL NOT HAVE their own private key to vote.**
**The only owners of the address on the blockchain will be the voting machines**

This removes all the risks of 
1. User selling their keys 
2. Users being able to decipher their vote to prove who they voted for
3. Malicious entities compromising user anonimity

The flow of a voting operation will be as such:
1. The voter gets identified by a public officer
2. The chairperson (which is the physical person responsible of the voting process) will abilitate one of the voting machines to vote
3. to abilitate the voting machine, the chairperson will send one token ("ERC20 standard" so basically a coin), this token will have the same function as a "voting ballot": the user cannot vote if there's not a voting ballot inside the booth, and the voting ballot itself can only be given by the chairperson. There's also no connection whatsoever between the voting ballot and the voter (just like there's no connection between the token and the voter).
4. Once the machine is been abilitated the voter will go to the booth and will cast a vote
5. The machine itself will interface with the smart contract that manages the voting system. Calling a vote function, encrypting the vote with the public key of the president of the country.
6. The vote will only go well if the Voting System smart contract will be able to take one token from the machine. If it's not able to, the vote won't be cast.
7. When the voting process is complete the user will receive the transaction hash of its voting transaction. This will be the proof of vote: the user can be sure that the vote has been succesfully cast (because there's a succesfull transaction associated with it) while simultaneously he won't be able to prove to nobody who he voted for
8. The voter is free to go only when the token is confirmed to not be in the machine's balance anymore. This is done to avoid people just "leaving the ballot" inside the cabin.

Here's a graph to illustrate the voting process
![[Pasted image 20240207154059.png]]

## What ifs and FAQs
### what if the user stays in the cabin?
The vote can be cast only if there's a token inside the cabin, just restarting the software of the voting booth isn't enough to cast a vote

### What if the user does not vote and leaves
The officials in charge will be able to see that the person didn't send the ballot because the machine's balance will be "1" even after the person left. The official will proceed with revoking the token to the machine, and a new person can vote.

### Wait a minute, can i just download the blockchain ledger and see all the votes in real time?
No, that's because the votes will be encrypted. Unless the central authority (which in case of the political elections will be the prime minister) releases the decryption key. Therefore the security of the vote is outsourced to the prime minister, leaving the system to be less vulnerable.

### What if the user wants to be sure of its vote?
Once the vote has been cast there's no way of checking who you voted, just like in the real elections, there's no way you would just shove your hand inside the ballot box and fish out your ballot to verify.
That being said the transaction hash of the voting transaction is an incrontrovertible proof that the vote has been succesfully cast.

## This system does not suck
so again, we solved many all of the issues that were proposed at the beginning of this article, and while yes, we did compromise on the utopia of voting from home we were able to implement a system that is far better than today's voting process.
It is more transparent, more efficient, quicker and offers a concrete proof of vote.
It solved the issues we posed at the beginning:
1. malware and denial of service attacks: while it is still possible to infect the terminals, it is much more unlikely than it is 
2. 