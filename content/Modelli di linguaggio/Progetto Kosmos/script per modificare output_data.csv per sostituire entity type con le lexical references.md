Questo script prende in input il file "shuffled_output_data.csv", che è il file input della fase di evaluation, e restituisce un file che contiene come nome dell'entità  le sue lexical references.
Il file quindi risulta essere molto più massiccio di "shuffled_output_data.csv". Verrà, infatti, troncato alle prime 10k righe.

| **environment** | **entity_type** | **image_bbox** | **image_normal** | **bounding_box** |
| ---- | ---- | ---- | ---- | ---- |
| **2380** | phone | Robocup/2380/images/LivingRoom/bounding_box/position_1/2380_LivingRoom_bounding_box_pos_1_180.jpg | Robocup/2380/images/LivingRoom/normal/position_1/2380_LivingRoom_pos_1_180.jpg | (0.465, 0.31333333333333335, 0.475, 0.31333333333333335) |
| **2304** | keys | Robocup/2304/images/Bedroom/bounding_box/position_1/2304_Bedroom_bounding_box_pos_1_90.jpg | Robocup/2304/images/Bedroom/normal/position_1/2304_Bedroom_pos_1_90.jpg | (0.0, 0.425, 0.006666666666666667, 0.43) |
| **3489** | jar | Release1/3489/images/Kitchen/bounding_box/position_6/3489_Kitchen_bounding_box_pos_6_0.jpg | Release1/3489/images/Kitchen/normal/position_6/3489_Kitchen_pos_6_0.jpg | (0.5583333333333333, 0.2683333333333333, 0.575, 0.29) |
| **2192** | jam | Robocup/2192/images/Kitchen/bounding_box/position_1/2192_Kitchen_bounding_box_pos_1_90.jpg | Robocup/2192/images/Kitchen/normal/position_1/2192_Kitchen_pos_1_90.jpg | (0.49166666666666664, 0.375, 0.52, 0.39) |


```python
import pandas as pd

# Read the shuffled output data CSV file
df = pd.read_csv("shuffled_output_data.csv")

# Initialize an empty list to store rows
new_rows = []

# Iterate through each row of the DataFrame
for index, row in df.iterrows():
    # Split the lexical_references string into a list
    lexical_references = eval(row['lexical_references'])
    
    # If there are lexical references, create a new row for each one
    if lexical_references:
        for reference in lexical_references:
            # Create a new row with the lexical reference as the entity type
            new_row = row.copy()
            new_row['entity_type'] = reference
            # Append the new row to the list of new rows
            new_rows.append(new_row)
    else:
        # If there are no lexical references, keep the original row
        new_rows.append(row)

# Create a new DataFrame from the list of new rows
new_df = pd.DataFrame(new_rows)

# Drop the 'lexical_references' column
new_df.drop(columns=['lexical_references'], inplace=True)

# Write the new DataFrame to a new CSV file
new_df.to_csv("expanded_output_data.csv", index=False)


```