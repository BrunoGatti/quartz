## LM based approach
Hanno consegnato due notebook Colab. Uno per il feature exctraction e un'altro con il vero e proprio modello
### Feature extraction
They extracted some additional info.
1. **has_origin_country**: boolean if it has a country of origin or not
2. **num_origin_countries**: the count of origin countries
3. **num_sitelinks**: number of sitelinks 
4. **has_traditional_keyword**: They made a list of "Traditional keywords", did the same thing for "universal" keywords and added a boolean flag
5. **has_universal_keyword**:

The feature extraction process is minimal, but looks effective, nothing too fancy. But no redundant or messy information.
The "traditional keyword" and "universal keyword" list is a nice heuristic, i wonder why they didn't make it a count. They could also have expanded the list a little bit.

``` python
# Keywords

traditional_keywords = ["traditional", "tradition", "heritage", "typical", "national", "historic", "ethnic"]

universal_keywords = ["universal", "global", "worldwide", "international"]
```

### Actual model
To do the classification step they did the following: They took all the features and piped them together as a string, then encoded that string using DeBerta.

``` python
def wikidata_features_to_text(row):
    parts = []
    if row.get("has_origin_country"):
        parts.append("Has origin country")
    parts.append(f"Number of origin countries: {row.get('num_origin_countries', 'unknown')}")
    parts.append(f"Number of Wikipedia sitelinks: {row.get('num_sitelinks', 'unknown')}")
    if row.get("has_traditional_keyword"):
        parts.append("Traditional")
    if row.get("has_universal_keyword"):
        parts.append("Universal")
    return " - ".join(parts)

df["wikidata_text"] = df.apply(wikidata_features_to_text, axis=1)
df_val["wikidata_text"] = df_val.apply(wikidata_features_to_text, axis=1)
  

df["text"] = df["name"] + " - " + df["description"] + " - " + df["type"] + " - " + df["category"] + " - " + df["subcategory"] + " - " + df["wikidata_text"]

df_val["text"] = df_val["name"] + " - " + df_val["description"] + " - " + df_val["type"] + " - " + df_val["category"] + " - " + df_val["subcategory"] + " - " + df_val["wikidata_text"]
```

The classifier is a small MLP that handles the classification. Nothing too fancy, it gets the job done apparently.
This is their confusion matrix on dev:

![[Pasted image 20250503162420.png]]

+1 point for color selection. Very A E S T H E T I C .

These are the performances on the val set:

{'eval_loss': 0.22367186844348907, 'eval_accuracy': 0.77, 'eval_f1': 0.7626396470075597, 'eval_precision': 0.7788261084500204, 'eval_recall': 0.77, 'eval_runtime': 2.7483, 'eval_samples_per_second': 109.158, 'eval_steps_per_second': 6.913, 'epoch': 2.0}

## Non-lm approach: feature extraction

in this case they extracted more features. Why?

```python
def get_combined_features(qid):
	features = {
		"qid": qid,
		"has_origin_country": False,
		"num_origin_countries": 0,
		"num_sitelinks": 0,
		"has_traditional_keyword": False,
		"has_universal_keyword": False,
		"has_low_sitelink_count": False,
		"known_globally": False,
		"is_traditional_instance": False,
		"has_heritage_status": False,
	}
```

| **Feature Name**        | **Present in LM Version?** | **Present in Non-LM Version?** |
| ----------------------- | -------------------------- | ------------------------------ |
| has_origin_country      | ✅ Yes                      | ✅ Yes                          |
| num_origin_countries    | ✅ Yes                      | ✅ Yes                          |
| num_sitelinks           | ✅ Yes                      | ✅ Yes                          |
| has_traditional_keyword | ✅ Yes                      | ✅ Yes                          |
| has_universal_keyword   | ✅ Yes                      | ✅ Yes                          |
| has_low_sitelink_count  | ❌ No                       | ✅ Yes                          |
| known_globally          | ❌ No                       | ✅ Yes                          |
| is_traditional_instance | ❌ No                       | ✅ Yes                          |
| has_heritage_status     | ❌ No                       | ✅ Yes                          |

Moreover it looks like they ditched some of these stuff in the end:

``` python
columns_to_use = [
    "has_origin_country",
    "num_origin_countries",
    "num_sitelinks",
    "has_traditional_keyword",
    "has_universal_keyword",
    "has_low_sitelink_count",
    "known_globally"
]
```

Namely they ditched "is_traditional_instance" and "has_heritage_status".
That again, is fine, and likely due to the fact that the information is indeed redundant with other features. But they didn't justify it in the code whatsoever.

### Non-Lm classification

Also when it comes to the actual vectorization they encoded the scalar value with standard scaler.

``` python
scaler = StandardScaler()
X_wiki_train_scaled = scaler.fit_transform(df_train[wikidata_columns])
```
while for the text data they used a concatenation + w2vec encoding method:

```python
name + description + type + category + subcategory
```
this is not bad in itself. But many of the textual data that's been encoded could've been converted into scalars. Like Type, category and subcategory.
I'm not saying that this is a 100% of the time better approach, but at least an effort could've been made in order to justify this choice.

As for the classifier, they apparently used XGboost, which is a decision tree basically. Again, it gets the job done, but no other classification methods were tested?

Performances are decent:


![[Pasted image 20250503170542.png]]

![[Pasted image 20250503170637.png]]