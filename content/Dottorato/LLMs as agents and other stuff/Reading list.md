## SFT Memorizes, RL Generalizes:
https://arxiv.org/pdf/2501.17161

Reinforcement Learning (RL) is commonly used in tuning large language models (LLMs) through **Reinforcement Learning from Human Feedback (RLHF)** and other **reward-based optimization techniques**. Here’s a breakdown of how RL is applied in LLM post-training, along with details from the experimental setup in the paper.

**How RL is Used in Tuning Large Language Models**

  

LLMs, such as GPT-4, Gemini, and LLaMA, undergo multiple stages of training:

1. **Pre-training** – The model learns from massive corpora in a self-supervised manner (e.g., next-token prediction).

2. **Supervised Fine-Tuning (SFT)** – The model is trained on specific tasks using human-labeled data.

3. **Reinforcement Learning (RL) Fine-Tuning** – The model is optimized using a reward signal to align better with desired behaviors.

  

**RL Fine-Tuning Process**

  

Reinforcement Learning in LLMs typically follows these steps:

  

**Step 1: Initial Model Training (Pretraining + SFT)**

• A base model (e.g., LLaMA, GPT) is first trained using standard pretraining objectives.

• SFT is applied using labeled data to improve instruction-following abilities.

  

**Step 2: Reward Model Training**

• A separate **reward model** is trained to score model outputs based on human preference.

• Human labelers rank multiple responses to the same prompt (e.g., “Which response is better?”).

• These rankings are used to train a reward model that assigns scores to generated responses.

  

**Step 3: RL Optimization (Typically PPO - Proximal Policy Optimization)**

• The LLM generates responses and receives a reward signal based on the **reward model**.

• The RL algorithm (e.g., **PPO**) optimizes the LLM’s policy to maximize the reward.

• This process helps the model **align better with human expectations** (e.g., factual accuracy, helpfulness, safety).

**Experimental Setup from the Paper**

  

The study compared **SFT-only** models with **RL-fine-tuned models** to measure their generalization capabilities. Here’s how the RL was implemented:

  

**1. RL Framework**

• **Proximal Policy Optimization (PPO)**: The same RL algorithm used in RLHF.

• **Sequential Revision**: The model revises its outputs iteratively, refining responses based on verification steps.

• **Outcome-Based Reward**: The model receives feedback on whether it followed rules correctly.

  

**2. Tasks Used for RL Evaluation**

1. **GeneralPoints (Arithmetic Task)**

• Evaluates the model’s ability to compute numerical solutions.

• Compares models trained via **SFT-only vs. SFT+RL** on both text and image inputs.

1. **V-IRL (Visual Navigation)**

• Evaluates spatial reasoning abilities.

• Models must follow navigation instructions and recognize landmarks in images.

  

**3. RL Training Details**

• **Backbone Model:** LLaMA-3.2-Vision-11B

• **Compute Scaling:** RL training is conducted **after** SFT.

• **Evaluation Metrics:**

• **In-distribution (ID) performance:** Performance on tasks similar to training data.

• **Out-of-distribution (OOD) generalization:** Performance on unseen variations.

**Are These Results Recreated on Small Models?**

• The paper **only used a large model (LLaMA-3.2-Vision-11B)**.

• There’s no mention of testing on **smaller models** like LLaMA-7B or LLaMA-3B.

• However, **previous studies** (e.g., DeepSeek-R1) suggest that **smaller models benefit less from RL** than larger ones.

• **Smaller models may rely more on memorization**, which explains why RL’s advantages are more pronounced in **large-scale models**.

**Key Takeaways**

1. **RL Improves Generalization** – The paper shows that RL helps LLMs move beyond memorization.

2. **PPO is Commonly Used** – Just like in RLHF, the study used PPO to optimize responses.

3. **RL Boosts Visual Recognition** – Unlike SFT, RL helped the model recognize new images better.

4. **Results Focus on Large Models** – No small models were tested, but RL’s benefits may be more pronounced at scale.

**Next Steps: What Would You Like to Explore?**

• Would you like a **deeper dive into PPO and RL algorithms** used in LLM tuning?

• Want me to **find research on RL for smaller models**?

• Interested in **practical applications of RL in industry**?

  

Let me know how you’d like to proceed! 🚀


## blah

