---
publish: true
---

Questo documento spiega come sono state calcolate le statistiche riguardanti la valutazione zero shot del modello Kosmos2 su vari dataset.

Alla fine della fase di evaluation, ho ottenuto un file chiamato "zero_shot_final.csv".
Questo file è una tabella di questo tipo:

|environment | entity_type | lexical_references | image_bbox | image_normal | bounding_box | kosmos_bounding_box | overlap_index | Match |
 |--- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2416 | Painting | ['quadro'] | Robocup/2416/images/LivingRoom/bounding_box/position_0/2416_LivingRoom_bounding_box_pos_0_180.jpg | Robocup/2416/images/LivingRoom/normal/position_0/2416_LivingRoom_pos_0_180.jpg | (0.24666666666666667, 0.2733333333333333, 0.8933333333333333, 0.5966666666666667) | (0.234375, 0.265625, 0.890625, 0.609375) | 0.9194192970203593 | True |
| 2644 | Painting | ['quadro'] | Simpleset/2644/images/LivingRoom/bounding_box/position_5/2644_LivingRoom_bounding_box_pos_5_90.jpg | Simpleset/2644/images/LivingRoom/normal/position_5/2644_LivingRoom_pos_5_90.jpg | (0.8866666666666667, 0.42, 0.9983333333333333, 0.755) | (0.015625, 0.015625, 0.359375, 0.703125) | 0.0 | False |
| 2746 | Dining Table | ['tavolo_da_pranzo'] | S4R/2746/images/LivingRoom/bounding_box/position_1/2746_LivingRoom_bounding_box_pos_1_270.jpg | S4R/2746/images/LivingRoom/normal/position_1/2746_LivingRoom_pos_1_270.jpg | (0.31333333333333335, 0.29, 0.385, 0.3616666666666667) | (0.015625, 0.015625, 0.328125, 0.859375) | 0.003959207069253051 | False |
| 2684 | Arm Chair | ['poltrona'] | S4R/2684/images/LivingRoom/bounding_box/position_3/2684_LivingRoom_bounding_box_pos_3_0.jpg | S4R/2684/images/LivingRoom/normal/position_3/2684_LivingRoom_pos_3_0.jpg | (0.36333333333333334, 0.315, 0.4583333333333333, 0.40166666666666667) | (0.359375, 0.296875, 0.453125, 0.421875) | 0.6394293865905849 | True |
| 2279 | Painting | ['quadro'] | Robocup/2279/images/LivingRoom/bounding_box/position_0/2279_LivingRoom_bounding_box_pos_0_0.jpg | Robocup/2279/images/LivingRoom/normal/position_0/2279_LivingRoom_pos_0_0.jpg | (0.5533333333333333, 0.07, 0.7283333333333334, 0.20333333333333334) | (0.546875, 0.078125, 0.734375, 0.203125) | 0.8786610878661091 | True |
| 3353 | Floor Lamp | ['lampada_da_terra'] | Rockin2/3353/images/LivingRoom/bounding_box/position_0/3353_LivingRoom_bounding_box_pos_0_0.jpg | Rockin2/3353/images/LivingRoom/normal/position_0/3353_LivingRoom_pos_0_0.jpg | (0.41, 0.26166666666666666, 0.5066666666666667, 0.4716666666666667) | (0.265625, 0.421875, 0.609375, 0.890625) | 0.02725175434888814 | False |
| 3385 | Garbage Can | ['pattumiera'] | Rockin2/3385/images/LivingRoom/bounding_box/position_3/3385_LivingRoom_bounding_box_pos_3_180.jpg | Rockin2/3385/images/LivingRoom/normal/position_3/3385_LivingRoom_pos_3_180.jpg | (0.5366666666666666, 0.605, 0.7216666666666667, 0.7733333333333333) | (0.515625, 0.609375, 0.734375, 0.796875) | 0.725219167164774 | True |
| 3068 | Chair | ['sedia'] | Rockin1/3068/images/LivingRoom/bounding_box/position_2/3068_LivingRoom_bounding_box_pos_2_90.jpg | Rockin1/3068/images/LivingRoom/normal/position_2/3068_LivingRoom_pos_2_90.jpg | (0.47833333333333333, 0.33666666666666667, 0.5533333333333333, 0.56) | (0.390625, 0.390625, 0.984375, 0.703125) | 0.06700181308719304 | False |
Dove sostanzialmente è contenuta: l'entità, l'immagine presa in considerazione, il boundig box target (preso come ground truth) , il bounding box generato dal modello, l'overlapping index, ed un valore booleano che indica se il modello è riuscito a trovare l'immagine o meno.

A questo punto ho computato una serie di statistiche per ogni tipo diverso di entità:

## Il numero di occorrenze per ogni entità:

| entity_type | Number of Occurrences |
| ---- | ---- |
| Total | 10000 |
| Painting | 751 |
| Cell Phone | 628 |
| Remote Control | 518 |
| Book | 485 |
| Chair | 443 |
| Pen | 356 |
| Dining Table | 317 |
| Box | 214 |
| Key Chain | 207 |
| Counter Top | 204 |
| Bowl | 194 |
| Bottle | 192 |
| House Plant | 192 |
| Television | 185 |
| Statue | 169 |
| Plate | 165 |
| Sofa | 161 |
| Laptop | 161 |
| Fridge | 157 |
| Knife | 150 |
| Bed | 141 |
| Dresser | 141 |
| Wine Bottle | 138 |
| Garbage Can | 135 |
| Fork | 129 |
| Spoon | 128 |
| Pillow | 125 |
| Mug | 119 |
| Arm Chair | 114 |
| Bread | 114 |
| Spray Bottle | 113 |
| Vase | 110 |
| Soap Bottle | 106 |
| Spatula | 94 |
| Pencil | 91 |
| Toaster | 89 |
| Shelving Unit | 88 |
| Toilet | 86 |
| Kettle | 84 |
| TV Stand | 84 |
| Butter Knife | 83 |
| Newspaper | 76 |
| Apple | 75 |
| Cup | 73 |
| Washing Machine | 73 |
| Side Table | 72 |
| Candle | 70 |
| Sink | 64 |
| Floor Lamp | 64 |
| Credit Card | 60 |
| Pepper Shaker | 58 |
| Potato | 57 |
| Salt Shaker | 56 |
| Tomato | 56 |
| Stool | 55 |
| Pan | 54 |
| Garbage Bag | 54 |
| Faucet | 54 |
| Dish Sponge | 52 |
| Lettuce | 51 |
| Microwave | 46 |
| Toilet Paper | 46 |
| Watch | 43 |
| Teddy Bear | 43 |
| Paper Towel Roll | 38 |
| Desk Lamp | 37 |
| Plunger | 37 |
| Basket Ball | 35 |
| Pot | 35 |
| Dog Bed | 34 |
| Ladle | 34 |
| Baseball Bat | 33 |
| Cart | 32 |
| Tissue Box | 26 |
| Egg | 23 |
| Alarm Clock | 22 |
| Desk | 17 |
| Coffee Machine | 14 |
| Soap Bar | 13 |
| Tennis Racket | 11 |
| Safe | 11 |
| Cloth | 10 |
| Laundry Hamper | 9 |
| Vacuum Cleaner | 7 |
| Boots | 3 |
| Desktop | 2 |
| Room Decor | 2 |
| Table Top Decor | 1 |
| Ottoman | 1 |
Questo indica quante volte ognuna di queste entità è apparsa nei dati che abbiamo valutato

```python
# Group the DataFrame by 'entity_type'
grouped = df.groupby('entity_type')

# Iterate over each entity type
for entity_type, group in grouped:
    # Calculate statistics for the current entity type
    total_matches = group['Match'].sum()
```

## La percentuale di istanze corrette
Per ogni tipo di entità diverso, calcola la percentuale di istanze che il modello ha determinato correttamente

| entity_type | Percentage of Matches |
| ---- | ---- |
| Total | 22.2700 |
| Painting | 40.3462 |
| Cell Phone | 2.0701 |
| Remote Control | 1.7375 |
| Book | 8.8660 |
| Chair | 25.0564 |
| Pen | 0.0000 |
| Dining Table | 58.6751 |
| Box | 10.2804 |
| Key Chain | 0.4831 |
| Counter Top | 37.7451 |
| Bowl | 5.6701 |
| Bottle | 6.7708 |
| House Plant | 46.3542 |
| Television | 63.7838 |
| Statue | 20.7101 |
| Plate | 4.2424 |
| Sofa | 65.8385 |
| Laptop | 16.7702 |
| Fridge | 66.2420 |
| Knife | 2.6667 |
| Bed | 52.4823 |
| Dresser | 61.7021 |
| Wine Bottle | 13.7681 |
| Garbage Can | 66.6667 |
| Fork | 0.0000 |
| Spoon | 0.0000 |
| Pillow | 15.2000 |
| Mug | 4.2017 |
| Arm Chair | 54.3860 |
| Bread | 7.8947 |
| Spray Bottle | 15.0442 |
| Vase | 8.1818 |
| Soap Bottle | 6.6038 |
| Spatula | 0.0000 |
| Pencil | 1.0989 |
| Toaster | 12.3596 |
| Shelving Unit | 61.3636 |
| Toilet | 66.2791 |
| Kettle | 5.9524 |
| TV Stand | 35.7143 |
| Butter Knife | 0.0000 |
| Newspaper | 5.2632 |
| Apple | 2.6667 |
| Cup | 4.1096 |
| Washing Machine | 69.8630 |
| Side Table | 40.2778 |
| Candle | 1.4286 |
| Sink | 71.8750 |
| Floor Lamp | 59.3750 |
| Credit Card | 0.0000 |
| Pepper Shaker | 0.0000 |
| Potato | 5.2632 |
| Salt Shaker | 0.0000 |
| Tomato | 8.9286 |
| Stool | 56.3636 |
| Pan | 7.4074 |
| Garbage Bag | 68.5185 |
| Faucet | 11.1111 |
| Dish Sponge | 0.0000 |
| Lettuce | 11.7647 |
| Microwave | 13.0435 |
| Toilet Paper | 4.3478 |
| Watch | 0.0000 |
| Teddy Bear | 48.8372 |
| Paper Towel Roll | 7.8947 |
| Desk Lamp | 8.1081 |
| Plunger | 24.3243 |
| Basket Ball | 31.4286 |
| Pot | 8.5714 |
| Dog Bed | 44.1176 |
| Ladle | 2.9412 |
| Baseball Bat | 15.1515 |
| Cart | 46.8750 |
| Tissue Box | 3.8462 |
| Egg | 0.0000 |
| Alarm Clock | 18.1818 |
| Desk | 47.0588 |
| Coffee Machine | 35.7143 |
| Soap Bar | 0.0000 |
| Tennis Racket | 9.0909 |
| Safe | 36.3636 |
| Cloth | 0.0000 |
| Laundry Hamper | 44.4444 |
| Vacuum Cleaner | 57.1429 |
| Boots | 0.0000 |
| Desktop | 0.0000 |
| Room Decor | 0.0000 |
| Table Top Decor | 0.0000 |
| Ottoman | 100.0000 |
|  |  |
```python
    std_total_matches = group['Match'].std()
    # Calculate percentage of times there's a match
    if total_instances > 0:
        percentage_match = (total_matches / total_instances) * 100
    else:
        percentage_match = 0
```

## Overlapping index medio

| entity_type | Average Overlapping Index | Average Overlapping Index (Matched) | Average Overlapping Index (Unmatched) |
| ---- | ---- | ---- | ---- |
| Total | 0.1784 | 0.7687 | 0.0093 |
| Painting | 0.3207 | 0.7896 | 0.0037 |
| Cell Phone | 0.0169 | 0.6653 | 0.0032 |
| Remote Control | 0.0153 | 0.6365 | 0.0043 |
| Book | 0.0693 | 0.7046 | 0.0075 |
| Chair | 0.2052 | 0.7385 | 0.0269 |
| Pen | 0.0011 |  | 0.0011 |
| Dining Table | 0.4669 | 0.7749 | 0.0296 |
| Box | 0.0849 | 0.7023 | 0.0142 |
| Key Chain | 0.0043 | 0.6105 | 0.0013 |
| Counter Top | 0.3100 | 0.8014 | 0.0121 |
| Bowl | 0.0428 | 0.6360 | 0.0071 |
| Bottle | 0.0475 | 0.6471 | 0.0040 |
| House Plant | 0.3412 | 0.7155 | 0.0178 |
| Television | 0.4931 | 0.7677 | 0.0095 |
| Statue | 0.1470 | 0.6560 | 0.0140 |
| Plate | 0.0334 | 0.7049 | 0.0036 |
| Sofa | 0.5580 | 0.8274 | 0.0389 |
| Laptop | 0.1320 | 0.7259 | 0.0123 |
| Fridge | 0.5615 | 0.8449 | 0.0053 |
| Knife | 0.0227 | 0.7009 | 0.0042 |
| Bed | 0.4395 | 0.8191 | 0.0202 |
| Dresser | 0.5399 | 0.8548 | 0.0326 |
| Wine Bottle | 0.0986 | 0.6525 | 0.0102 |
| Garbage Can | 0.5233 | 0.7666 | 0.0367 |
| Fork | 0.0019 |  | 0.0019 |
| Spoon | 0.0014 |  | 0.0014 |
| Pillow | 0.1168 | 0.6873 | 0.0146 |
| Mug | 0.0310 | 0.6205 | 0.0052 |
| Arm Chair | 0.4404 | 0.7965 | 0.0159 |
| Bread | 0.0632 | 0.6982 | 0.0088 |
| Spray Bottle | 0.1057 | 0.6653 | 0.0066 |
| Vase | 0.0639 | 0.6518 | 0.0115 |
| Soap Bottle | 0.0466 | 0.6285 | 0.0054 |
| Spatula | 0.0058 |  | 0.0058 |
| Pencil | 0.0070 | 0.5701 | 0.0007 |
| Toaster | 0.0912 | 0.6816 | 0.0080 |
| Shelving Unit | 0.5259 | 0.8304 | 0.0421 |
| Toilet | 0.5122 | 0.7458 | 0.0529 |
| Kettle | 0.0475 | 0.6470 | 0.0096 |
| TV Stand | 0.2836 | 0.7525 | 0.0230 |
| Butter Knife | 0.0045 |  | 0.0045 |
| Newspaper | 0.0392 | 0.6769 | 0.0037 |
| Apple | 0.0223 | 0.6565 | 0.0050 |
| Cup | 0.0306 | 0.6311 | 0.0049 |
| Washing Machine | 0.5904 | 0.8256 | 0.0452 |
| Side Table | 0.3204 | 0.7835 | 0.0081 |
| Candle | 0.0216 | 0.8907 | 0.0090 |
| Sink | 0.5634 | 0.7741 | 0.0251 |
| Floor Lamp | 0.4851 | 0.7990 | 0.0264 |
| Credit Card | 0.0010 |  | 0.0010 |
| Pepper Shaker | 0.0020 |  | 0.0020 |
| Potato | 0.0349 | 0.6414 | 0.0012 |
| Salt Shaker | 0.0010 |  | 0.0010 |
| Tomato | 0.0581 | 0.6345 | 0.0016 |
| Stool | 0.4302 | 0.7595 | 0.0049 |
| Pan | 0.0531 | 0.6368 | 0.0064 |
| Garbage Bag | 0.5245 | 0.7509 | 0.0318 |
| Faucet | 0.1033 | 0.7218 | 0.0260 |
| Dish Sponge | 0.0045 |  | 0.0045 |
| Lettuce | 0.0811 | 0.6854 | 0.0006 |
| Microwave | 0.1258 | 0.7665 | 0.0297 |
| Toilet Paper | 0.0321 | 0.6579 | 0.0037 |
| Watch | 0.0009 |  | 0.0009 |
| Teddy Bear | 0.3605 | 0.6945 | 0.0417 |
| Paper Towel Roll | 0.0512 | 0.5987 | 0.0043 |
| Desk Lamp | 0.0821 | 0.7218 | 0.0257 |
| Plunger | 0.1827 | 0.6990 | 0.0168 |
| Basket Ball | 0.2573 | 0.6320 | 0.0856 |
| Pot | 0.0637 | 0.7074 | 0.0033 |
| Dog Bed | 0.3621 | 0.8205 | 0.0003 |
| Ladle | 0.0248 | 0.7196 | 0.0038 |
| Baseball Bat | 0.1196 | 0.7497 | 0.0071 |
| Cart | 0.3785 | 0.8061 | 0.0012 |
| Tissue Box | 0.0357 | 0.7297 | 0.0079 |
| Egg | 0.0015 |  | 0.0015 |
| Alarm Clock | 0.1260 | 0.6687 | 0.0055 |
| Desk | 0.4079 | 0.8446 | 0.0197 |
| Coffee Machine | 0.2354 | 0.6260 | 0.0183 |
| Soap Bar | 0.0010 |  | 0.0010 |
| Tennis Racket | 0.0718 | 0.5645 | 0.0226 |
| Safe | 0.2719 | 0.7300 | 0.0101 |
| Cloth | 0.0000 |  | 0.0000 |
| Laundry Hamper | 0.3525 | 0.7875 | 0.0044 |
| Vacuum Cleaner | 0.4380 | 0.7664 | 0.0000 |
| Boots | 0.0068 |  | 0.0068 |
| Desktop | 0.0408 |  | 0.0408 |
| Room Decor | 0.0123 |  | 0.0123 |
| Table Top Decor | 0.0558 |  | 0.0558 |
| Ottoman | 0.9066 | 0.9066 |  |
|  |  |  |  |
|  |  |  |  |

```python
    average_overlap_index_all = df['overlap_index'].mean()
    std_average_overlap_index_matched = group[group['Match']]['overlap_index'].std()
    std_average_overlap_index_unmatched = group[~group['Match']]['overlap_index'].std()
```


## Dimensione media dei bounding box

| entity_type | Avg BBox Dimensions (Correct) | Avg BBox Dimensions (Incorrect) | Average BBox Dimensions (All) |
| ---- | ---- | ---- | ---- |
| Total | 0.0763 | 0.0067 | 0.0222 |
| Painting | 0.0672 | 0.0141 | 0.0355 |
| Cell Phone | 0.0063 | 0.0010 | 0.0011 |
| Remote Control | 0.0098 | 0.0008 | 0.0010 |
| Book | 0.0195 | 0.0028 | 0.0043 |
| Chair | 0.0444 | 0.0113 | 0.0196 |
| Pen |  | 0.0004 | 0.0004 |
| Dining Table | 0.0732 | 0.0289 | 0.0549 |
| Box | 0.0164 | 0.0051 | 0.0062 |
| Key Chain | 0.0055 | 0.0003 | 0.0004 |
| Counter Top | 0.1864 | 0.0679 | 0.1126 |
| Bowl | 0.0098 | 0.0029 | 0.0033 |
| Bottle | 0.0105 | 0.0017 | 0.0023 |
| House Plant | 0.0320 | 0.0045 | 0.0172 |
| Television | 0.1015 | 0.0191 | 0.0716 |
| Statue | 0.0165 | 0.0032 | 0.0059 |
| Plate | 0.0153 | 0.0012 | 0.0018 |
| Sofa | 0.1050 | 0.0236 | 0.0772 |
| Laptop | 0.0271 | 0.0047 | 0.0084 |
| Fridge | 0.2056 | 0.0652 | 0.1582 |
| Knife | 0.0139 | 0.0015 | 0.0018 |
| Bed | 0.1410 | 0.0271 | 0.0869 |
| Dresser | 0.1222 | 0.0198 | 0.0830 |
| Wine Bottle | 0.0093 | 0.0054 | 0.0059 |
| Garbage Can | 0.0274 | 0.0102 | 0.0217 |
| Fork |  | 0.0007 | 0.0007 |
| Spoon |  | 0.0004 | 0.0004 |
| Pillow | 0.0200 | 0.0028 | 0.0054 |
| Mug | 0.0116 | 0.0015 | 0.0019 |
| Arm Chair | 0.0597 | 0.0206 | 0.0419 |
| Bread | 0.0155 | 0.0018 | 0.0029 |
| Spray Bottle | 0.0110 | 0.0012 | 0.0027 |
| Vase | 0.0206 | 0.0015 | 0.0031 |
| Soap Bottle | 0.0101 | 0.0025 | 0.0030 |
| Spatula |  | 0.0020 | 0.0020 |
| Pencil | 0.0028 | 0.0003 | 0.0003 |
| Toaster | 0.0181 | 0.0042 | 0.0060 |
| Shelving Unit | 0.1446 | 0.0368 | 0.1030 |
| Toilet | 0.0835 | 0.0132 | 0.0598 |
| Kettle | 0.0128 | 0.0039 | 0.0044 |
| TV Stand | 0.1123 | 0.0213 | 0.0538 |
| Butter Knife |  | 0.0002 | 0.0002 |
| Newspaper | 0.0225 | 0.0013 | 0.0024 |
| Apple | 0.0037 | 0.0019 | 0.0019 |
| Cup | 0.0072 | 0.0015 | 0.0017 |
| Washing Machine | 0.0982 | 0.0260 | 0.0764 |
| Side Table | 0.0557 | 0.0172 | 0.0327 |
| Candle | 0.0061 | 0.0007 | 0.0008 |
| Sink | 0.0772 | 0.0175 | 0.0604 |
| Floor Lamp | 0.1211 | 0.0273 | 0.0830 |
| Credit Card |  | 0.0003 | 0.0003 |
| Pepper Shaker |  | 0.0019 | 0.0019 |
| Potato | 0.0039 | 0.0020 | 0.0021 |
| Salt Shaker |  | 0.0005 | 0.0005 |
| Tomato | 0.0044 | 0.0005 | 0.0008 |
| Stool | 0.0257 | 0.0081 | 0.0181 |
| Pan | 0.0166 | 0.0039 | 0.0048 |
| Garbage Bag | 0.0218 | 0.0055 | 0.0167 |
| Faucet | 0.0227 | 0.0107 | 0.0120 |
| Dish Sponge |  | 0.0006 | 0.0006 |
| Lettuce | 0.0104 | 0.0007 | 0.0019 |
| Microwave | 0.0431 | 0.0089 | 0.0133 |
| Toilet Paper | 0.0064 | 0.0011 | 0.0013 |
| Watch |  | 0.0003 | 0.0003 |
| Teddy Bear | 0.0152 | 0.0027 | 0.0088 |
| Paper Towel Roll | 0.0072 | 0.0021 | 0.0025 |
| Desk Lamp | 0.0269 | 0.0037 | 0.0056 |
| Plunger | 0.0121 | 0.0042 | 0.0061 |
| Basket Ball | 0.0083 | 0.0018 | 0.0038 |
| Pot | 0.0248 | 0.0031 | 0.0049 |
| Dog Bed | 0.0434 | 0.0146 | 0.0273 |
| Ladle | 0.0095 | 0.0011 | 0.0013 |
| Baseball Bat | 0.0229 | 0.0036 | 0.0065 |
| Cart | 0.0781 | 0.0362 | 0.0559 |
| Tissue Box | 0.0087 | 0.0024 | 0.0026 |
| Egg |  | 0.0005 | 0.0005 |
| Alarm Clock | 0.0103 | 0.0034 | 0.0046 |
| Desk | 0.1419 | 0.0392 | 0.0876 |
| Coffee Machine | 0.0185 | 0.0132 | 0.0151 |
| Soap Bar |  | 0.0005 | 0.0005 |
| Tennis Racket | 0.0099 | 0.0047 | 0.0052 |
| Safe | 0.0163 | 0.0055 | 0.0094 |
| Cloth |  | 0.0026 | 0.0026 |
| Laundry Hamper | 0.0599 | 0.0154 | 0.0352 |
| Vacuum Cleaner | 0.0301 | 0.0183 | 0.0250 |
| Boots |  | 0.0011 | 0.0011 |
| Desktop |  | 0.0316 | 0.0316 |
| Room Decor |  | 0.0130 | 0.0130 |
| Table Top Decor |  | 0.0027 | 0.0027 |
| Ottoman | 0.1021 |  | 0.1021 |

```python
    avg_bbox_correct = group[group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).mean()
    avg_bbox_incorrect = group[~group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).mean()
    avg_bbox_dimensions = group['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1]))
```

## Standard deviation
Inoltre ho calcolato la deviazione standard per ogni valore

```python
    # Calculate standard deviations
    std_total_matches = group['Match'].std()
    std_average_overlap_index = group['overlap_index'].std()
    std_average_overlap_index_matched = group[group['Match']]['overlap_index'].std()
    std_average_overlap_index_unmatched = group[~group['Match']]['overlap_index'].std()
    std_avg_bbox_correct = group[group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).std()
    std_avg_bbox_incorrect = group[~group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).std()
    
```

## Ulteriori operazioni
Altre operazioni su questo dataset sono:
1. Convertire in float i valori
2. Ordinare per numero di occorrenze
3. troncare i valori al quarto decimale

```python
# Create a DataFrame from the list of calculated statistics
stats_df = pd.DataFrame(entity_stats)

# Convert all numeric columns to float
stats_df = stats_df.apply(pd.to_numeric, errors='ignore')
# Sort the DataFrame by the 'Number of Occurrences' column in descending order
stats_df = stats_df.sort_values(by='Number of Occurrences', ascending=False)

# Export the DataFrame to a CSV file
stats_df.to_csv("entity_statistics_with_std_rounded.csv", index=False, float_format='%.4f')
```

## File completo

```python
import pandas as pd
import numpy as np

# Read the CSV file into a DataFrame
df = pd.read_csv("zero_shot_final.csv")

# Initialize a list to store calculated statistics for each entity type
entity_stats = []

# Calculate statistics for the entire dataset
total_instances_all = len(df)
total_matches_all = df['Match'].sum()
average_overlap_index_all = df['overlap_index'].mean()
average_overlap_index_matched_all = df[df['Match']]['overlap_index'].mean()
average_overlap_index_unmatched_all = df[~df['Match']]['overlap_index'].mean()
avg_bbox_correct_all = df[df['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).mean()
avg_bbox_incorrect_all = df[~df['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).mean()

# Calculate standard deviations
std_total_matches_all = df['Match'].std()
std_average_overlap_index_all = df['overlap_index'].std()
std_average_overlap_index_matched_all = df[df['Match']]['overlap_index'].std()
std_average_overlap_index_unmatched_all = df[~df['Match']]['overlap_index'].std()
std_avg_bbox_correct_all = df[df['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).std()
std_avg_bbox_incorrect_all = df[~df['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).std()

# Calculate average bounding box dimensions for all instances
avg_bbox_dimensions_all = df['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1]))
average_bbox_dimensions_all = avg_bbox_dimensions_all.mean()
std_avg_bbox_dimensions_all = avg_bbox_dimensions_all.std()

# Calculate percentage of times there's a match for the entire dataset
if total_instances_all > 0:
    percentage_match_all = (total_matches_all / total_instances_all) * 100
else:
    percentage_match_all = 0

# Append the calculated statistics for the entire dataset to the list
entity_stats.append({
    'entity_type': 'Total',
    'Number of Occurrences': total_instances_all,
    'Percentage of Matches': percentage_match_all,
    'Average Overlapping Index': average_overlap_index_all,
    'Std Average Overlapping Index': std_average_overlap_index_all,
    'Average Overlapping Index (Matched)': average_overlap_index_matched_all,
    'Std Average Overlapping Index (Matched)': std_average_overlap_index_matched_all,
    'Average Overlapping Index (Unmatched)': average_overlap_index_unmatched_all,
    'Std Average Overlapping Index (Unmatched)': std_average_overlap_index_unmatched_all,
    'Avg BBox Dimensions (Correct)': avg_bbox_correct_all,
    'Std Avg BBox Dimensions (Correct)': std_avg_bbox_correct_all,
    'Avg BBox Dimensions (Incorrect)': avg_bbox_incorrect_all,
    'Std Avg BBox Dimensions (Incorrect)': std_avg_bbox_incorrect_all,
    'Average BBox Dimensions (All)': average_bbox_dimensions_all,
    'Std Average BBox Dimensions (All)': std_avg_bbox_dimensions_all
})

# Group the DataFrame by 'entity_type'
grouped = df.groupby('entity_type')

# Iterate over each entity type
for entity_type, group in grouped:
    # Calculate statistics for the current entity type
    total_instances = len(group)
    total_matches = group['Match'].sum()
    average_overlap_index = group['overlap_index'].mean()
    average_overlap_index_matched = group[group['Match']]['overlap_index'].mean()
    average_overlap_index_unmatched = group[~group['Match']]['overlap_index'].mean()
    avg_bbox_correct = group[group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).mean()
    avg_bbox_incorrect = group[~group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).mean()
    
    # Calculate standard deviations
    std_total_matches = group['Match'].std()
    std_average_overlap_index = group['overlap_index'].std()
    std_average_overlap_index_matched = group[group['Match']]['overlap_index'].std()
    std_average_overlap_index_unmatched = group[~group['Match']]['overlap_index'].std()
    std_avg_bbox_correct = group[group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).std()
    std_avg_bbox_incorrect = group[~group['Match']]['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1])).std()
    
    # Calculate average bounding box dimensions for current entity type
    avg_bbox_dimensions = group['bounding_box'].apply(eval).apply(lambda x: (x[2]-x[0])*(x[3]-x[1]))
    average_bbox_dimensions = avg_bbox_dimensions.mean()
    std_avg_bbox_dimensions = avg_bbox_dimensions.std()
    
    # Calculate percentage of times there's a match
    if total_instances > 0:
        percentage_match = (total_matches / total_instances) * 100
    else:
        percentage_match = 0

    # Append the calculated statistics to the list
    entity_stats.append({
        'entity_type': entity_type,
        'Number of Occurrences': total_instances,
        'Percentage of Matches': percentage_match,
        'Average Overlapping Index': average_overlap_index,
        'Std Average Overlapping Index': std_average_overlap_index,
        'Average Overlapping Index (Matched)': average_overlap_index_matched,
        'Std Average Overlapping Index (Matched)': std_average_overlap_index_matched,
        'Average Overlapping Index (Unmatched)': average_overlap_index_unmatched,
        'Std Average Overlapping Index (Unmatched)': std_average_overlap_index_unmatched,
        'Avg BBox Dimensions (Correct)': avg_bbox_correct,
        'Std Avg BBox Dimensions (Correct)': std_avg_bbox_correct,
        'Avg BBox Dimensions (Incorrect)': avg_bbox_incorrect,
        'Std Avg BBox Dimensions (Incorrect)': std_avg_bbox_incorrect,
        'Average BBox Dimensions (All)': average_bbox_dimensions,
        'Std Average BBox Dimensions (All)': std_avg_bbox_dimensions
    })

# Create a DataFrame from the list of calculated statistics
stats_df = pd.DataFrame(entity_stats)

# Convert all numeric columns to float
stats_df = stats_df.apply(pd.to_numeric, errors='ignore')
# Sort the DataFrame by the 'Number of Occurrences' column in descending order
stats_df = stats_df.sort_values(by='Number of Occurrences', ascending=False)

# Export the DataFrame to a CSV file
stats_df.to_csv("entity_statistics_with_std_rounded.csv", index=False, float_format='%.4f')


```