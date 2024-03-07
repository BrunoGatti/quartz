This is an example of how i plot statistics using plotly, pandas and numpy.

## The data i'm plotting
I'm plotting a table that contains the evaluation of a LLM called [[Kosmos 2]], i used it to find the bounding boxes of certain objects in computer generated images. 
What i found, computing statistics, is that there's a correlation between the dimension of the object and the precision of my model: namely my model is more precise when the object is big, and way less precise when the object is small.

| entity_type | Average BBox Dimensions (All) | Percentage of Matches |
| ---- | ---- | ---- |
| Total | 0.0222 | 22.2700 |
| Painting | 0.0355 | 40.3462 |
| Cell Phone | 0.0011 | 2.0701 |
| Remote Control | 0.0010 | 1.7375 |
| Book | 0.0043 | 8.8660 |
| Chair | 0.0196 | 25.0564 |
| Pen | 0.0004 | 0.0000 |
| Dining Table | 0.0549 | 58.6751 |
| Box | 0.0062 | 10.2804 |
| Key Chain | 0.0004 | 0.4831 |
| Counter Top | 0.1126 | 37.7451 |
| Bowl | 0.0033 | 5.6701 |
| Bottle | 0.0023 | 6.7708 |
| House Plant | 0.0172 | 46.3542 |
| Television | 0.0716 | 63.7838 |
| Statue | 0.0059 | 20.7101 |
| Plate | 0.0018 | 4.2424 |
| Sofa | 0.0772 | 65.8385 |
| Laptop | 0.0084 | 16.7702 |
| Fridge | 0.1582 | 66.2420 |
| Knife | 0.0018 | 2.6667 |
| Bed | 0.0869 | 52.4823 |
| Dresser | 0.0830 | 61.7021 |
| Wine Bottle | 0.0059 | 13.7681 |
| Garbage Can | 0.0217 | 66.6667 |
| Fork | 0.0007 | 0.0000 |
| Spoon | 0.0004 | 0.0000 |
| Pillow | 0.0054 | 15.2000 |
| Mug | 0.0019 | 4.2017 |
| Arm Chair | 0.0419 | 54.3860 |
| Bread | 0.0029 | 7.8947 |
| Spray Bottle | 0.0027 | 15.0442 |
| Vase | 0.0031 | 8.1818 |
| Soap Bottle | 0.0030 | 6.6038 |
| Spatula | 0.0020 | 0.0000 |
| Pencil | 0.0003 | 1.0989 |
| Toaster | 0.0060 | 12.3596 |
| Shelving Unit | 0.1030 | 61.3636 |
| Toilet | 0.0598 | 66.2791 |
| Kettle | 0.0044 | 5.9524 |
| TV Stand | 0.0538 | 35.7143 |
| Butter Knife | 0.0002 | 0.0000 |
| Newspaper | 0.0024 | 5.2632 |
| Apple | 0.0019 | 2.6667 |
| Cup | 0.0017 | 4.1096 |
| Washing Machine | 0.0764 | 69.8630 |
| Side Table | 0.0327 | 40.2778 |
| Candle | 0.0008 | 1.4286 |
| Sink | 0.0604 | 71.8750 |
| Floor Lamp | 0.0830 | 59.3750 |
| Credit Card | 0.0003 | 0.0000 |
| Pepper Shaker | 0.0019 | 0.0000 |
| Potato | 0.0021 | 5.2632 |
| Salt Shaker | 0.0005 | 0.0000 |
| Tomato | 0.0008 | 8.9286 |
| Stool | 0.0181 | 56.3636 |
| Pan | 0.0048 | 7.4074 |
| Garbage Bag | 0.0167 | 68.5185 |
| Faucet | 0.0120 | 11.1111 |
| Dish Sponge | 0.0006 | 0.0000 |
| Lettuce | 0.0019 | 11.7647 |
| Microwave | 0.0133 | 13.0435 |
| Toilet Paper | 0.0013 | 4.3478 |
| Watch | 0.0003 | 0.0000 |
| Teddy Bear | 0.0088 | 48.8372 |
| Paper Towel Roll | 0.0025 | 7.8947 |
| Desk Lamp | 0.0056 | 8.1081 |
| Plunger | 0.0061 | 24.3243 |
| Basket Ball | 0.0038 | 31.4286 |
| Pot | 0.0049 | 8.5714 |
| Dog Bed | 0.0273 | 44.1176 |
| Ladle | 0.0013 | 2.9412 |
| Baseball Bat | 0.0065 | 15.1515 |
| Cart | 0.0559 | 46.8750 |
| Tissue Box | 0.0026 | 3.8462 |
| Egg | 0.0005 | 0.0000 |
| Alarm Clock | 0.0046 | 18.1818 |
| Desk | 0.0876 | 47.0588 |
| Coffee Machine | 0.0151 | 35.7143 |
| Soap Bar | 0.0005 | 0.0000 |
| Tennis Racket | 0.0052 | 9.0909 |
| Safe | 0.0094 | 36.3636 |
| Cloth | 0.0026 | 0.0000 |
| Laundry Hamper | 0.0352 | 44.4444 |
| Vacuum Cleaner | 0.0250 | 57.1429 |
| Boots | 0.0011 | 0.0000 |
| Desktop | 0.0316 | 0.0000 |
| Room Decor | 0.0130 | 0.0000 |
| Table Top Decor | 0.0027 | 0.0000 |
| Ottoman | 0.1021 | 100.0000 |
So i plotted it to find out if there actually was a correlation between those values


![[plot 1.html]]

And there obviously is. To view a more in depth analysis of this correlation see: [[Kosmos 2 lavoro svolto finora]]

## The code

First of all we read the csv file and we exclude the total from the plot (we want to know the correlation for each entity type we don't really care about the total)

```python
```python
import pandas as pd
import plotly.graph_objects as go
import numpy as np

# Read the CSV file into a DataFrame
df = pd.read_csv("entity_statistics_with_std_rounded.csv")

# Exclude the 'Total' row from the DataFrame
df = df[df['entity_type'] != 'Total']
```

now we extract the required columns to compute these statistics: these are

| number of Occurrences | Average BBox Dimensions (All) | Percentage of Matches |
| ---- | ---- | ---- |

```python
# Extract required columns
percentage_matches = df['Percentage of Matches']
avg_bbox_dimensions = df['Average BBox Dimensions (All)']
num_occurrences = df['Number of Occurrences']

```

Now one cool thing i did was to scale the color of the points:
a green dot means that there are a lot of occurrences and that the dot is "trusted"
red is the opposite.
If i just use a raw scale where dark green is a dot that represented an entity that occurred 700 times (which is the max) then there would be very few green dots (since there are only a bunch of entities that occur around 700 times) and many red dots.
So the gradient needs to concentrate around the mean value of "number of Occurrences"

```python
# Calculate the mean of the values of "Number of Occurrences"
mean_num_occurrences = num_occurrences.mean()

# Create normalized values based on the mean
normalized_values = 0.5 + (num_occurrences - mean_num_occurrences) / (2 * mean_num_occurrences)
normalized_values = np.clip(normalized_values, 0, 1)  # Clip values to [0, 1] range

```
This gives us a range [0,1] that can be used as a scale for the color parameter in a plotly figure
```python
# Create scatter plot using Plotly
fig = go.Figure(data=go.Scatter(
    x=avg_bbox_dimensions,
    y=percentage_matches,
    mode='markers',
    marker=dict(
        color=normalized_values,
        colorscale='RdYlGn',  # Red-Yellow-Green colormap
        line_width=1
    )
))
```
The scale is Red Yellow Green and uses the normalized values.
Then it just exports the plot as an html file:

```python
# Update layout
fig.update_layout(
    title='Correlation between BBox Dimensions and Percentage of Matches',
    xaxis_title='Average BBox Dimensions (All)',
    yaxis_title='Percentage of Matches',
    plot_bgcolor='rgba(0,0,0,0)'
)

# Export the plot to an HTML file
fig.write_html("plot.html")
```

This is the whole file:

```python
import pandas as pd
import plotly.graph_objects as go
import numpy as np

# Read the CSV file into a DataFrame
df = pd.read_csv("entity_statistics_with_std_rounded.csv")

# Exclude the 'Total' row from the DataFrame
df = df[df['entity_type'] != 'Total']

# Extract required columns
percentage_matches = df['Percentage of Matches']
avg_bbox_dimensions = df['Average BBox Dimensions (All)']
num_occurrences = df['Number of Occurrences']

# Calculate the mean of the values of "Number of Occurrences"
mean_num_occurrences = num_occurrences.mean()

# Create normalized values based on the mean
normalized_values = 0.5 + (num_occurrences - mean_num_occurrences) / (2 * mean_num_occurrences)
normalized_values = np.clip(normalized_values, 0, 1)  # Clip values to [0, 1] range

# Create scatter plot using Plotly
fig = go.Figure(data=go.Scatter(
    x=avg_bbox_dimensions,
    y=percentage_matches,
    mode='markers',
    marker=dict(
        color=normalized_values,
        colorscale='RdYlGn',  # Red-Yellow-Green colormap
        line_width=1
    )
))

# Update layout
fig.update_layout(
    title='Correlation between BBox Dimensions and Percentage of Matches',
    xaxis_title='Average BBox Dimensions (All)',
    yaxis_title='Percentage of Matches',
    plot_bgcolor='rgba(0,0,0,0)'
)

# Export the plot to an HTML file
fig.write_html("plot.html")


```