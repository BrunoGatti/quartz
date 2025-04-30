### Report
First of all you will need to release a report.
We're giving two pages as a constraint, since we think it should be enough to convey your project's ideas, but it's two pages not counting Tables, Figures, Listings, Algorithms and Bibliography (if any). All of these things should be put into the Appendix and referenced in the two main pages.
A general structure for your report should be

- Introduction
- Methodology
- Experiments
- Results
- Appendix

### The code
The general guidelines for releasing the code are the following:
1. The code must be released as a Google Colab notebook. 
2. This notebook must be runnable.

These are the two main things you have to keep in mind when submitting your code. 
That being said, we want to address some doubts that you manifested in the past Q&As:

#### Additional files
Many of you enhanced the training set with additional informations.
If you did, obviously, you need to provide this file to us in order for your script to work.
There are several ways you can do this:

#### Google Drive

The preferred way is to host your data on a SHARED (emphasis on shared, or i will not be able to run it) google drive folder, and you directly open the files from you google Colab.
You will upload every file you're using in your script in said folder, so that you have everything nice and organized for me to run.
The share directory should be situated in your "MyDrive", this will make my life much easier so that i don't have to manually change the path when i run your code.
This is usually the best method (for you and for us), as it minimizes the unexpected behavior of your code.

![[Pasted image 20250429111917.png]]

![[Pasted image 20250429112047.png]]

![[Pasted image 20250429112100.png]]

![[Pasted image 20250429112158.png]]
Share it with me and all the TAs.
Here's our emails:
castro@diag.uniroma1.it
gatti@diag.uniroma1.it
xu@diag.uniroma1.it
moroni@diag.uniroma1.it
gioffre@diag.uniroma1.it

Then you integrate the files in your colab notebook:

```
from google.colab import drive
drive.mount('/content/drive')

import pandas as pd

path = '/content/drive/MyDrive/Nome_Gruppo_shared_folder/data.csv'
df = pd.read_csv(path)
df.head() # Or whatever you need to do with the file
```

#### A zip file
Alternatively you can share a zip file containing the files we need.
But be aware that we will not play hide and seek with your files. 
We'll take the files and upload them to colab. If we have trouble finding files, if there are broken paths or stuff that don't work for whatever reason, we'll not fix it for you.

So remember that if you want to use this method you need to unzip the file first in the colab notebook. So that you can verify that when we do it, it actually works.

```
import zipfile
import os

zip_path = "zipped_files.zip"

with zipfile.ZipFile(zip_path, 'r') as zip_reference:
    zip_reference.extractall("unzipped_data")  # extract to a folder named

os.listdir("unzipped_data") # proceed with your code
```


Also this method cannot be used if the files are too big to be downloaded, uploaded and used in a reasonable amount of time. Let's say, if the zip file takes more than 20 minutes to be uploaded than you must use the google drive method.

## The models
Can you upload your models to Huggingface? Yes you can.
But we have to be able to replicate the training using you colab notebook, or else there's not way for us to check if you used shady practices to train and then corrected said shady practices in the notebook.

Again, the rule of thumb here is that:
1. We need to able to replicate the training
2. We need to be able to run the inference ourselves to verify your output

## The output of the inference
Once we give you the test set, we want you to run the inference on the test set.
The output of your model has to be a csv or tsv file.
It must contain AT LEAST the columns "item", "name" and "label".
We'll run the numbers for you and will make a ranking based on the results.
Since you're submitting two approaches you'll obviously need to send us 2 csv files containing the result of the inference.

## File naming convention
Some of you guys asked us for some strict naming convention of the files.
When uploading to a shared folder on google Colab, please name the shared folder with the name of your group.
This also goes for the output flles.
For instance:

Nome_gruppo_output_modello1.csv


### Homework submission
Send us an email with the shared folder, and submit the details of the homework to this link:  [https://forms.gle/kWCTCEUMEMZ3t3qV8](https://forms.gle/kWCTCEUMEMZ3t3qV8)
Can you put the notebook in the shared folder? Yes but also send the link in this form. Please.

### Including "expanded" files
Many of you used a plethora of techniques in order to enhance the dataset, you most definitely need to include the data, already "expanded" with the additional features you'll need in the next phases. But. You will also need to include the code that led to that file, in case we find your data "strange" and we want to verify that you didn't cheat.

### Do we need two notebooks one for each model?
It's not important, you can either submit two notebooks (one for each model) or one. The important thing is that the code is readable and the process understandable.
