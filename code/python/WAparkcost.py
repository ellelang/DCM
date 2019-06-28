from __future__ import print_function
from pathlib import Path
data_folder = Path("C:/Users/langzx/Desktop/github/DCM/data")
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import numpy as np
import pandas as pd

df = pd.read_csv(data_folder/'WAParkCost.csv')

df.head()



df.describe()
a = df['Physiognomy'].value_counts()
a
wet_types = df.groupby(['Physiognomy']).size()
wet_types

wet_types_mean = df.groupby('Physiognomy').mean()
wet_types_mean

wet_types_median = df.groupby(['Physiognomy']).median()
wet_types_median

wet_types_max = df.groupby(['Physiognomy']).max()
wet_types_max

wet_types_min = df.groupby(['Physiognomy']).min()
wet_types_min

import seaborn as sns

ax = sns.barplot(x="Physiognomy", y="Cost_acre_year_2018", data=df)


fig, ax = plt.subplots(1, 1, figsize=(6, 6))
wet_types_mean.plot(kind='bar', y='Cost_acre_year_2018',
        align='center', width=1, edgecolor='none', ax=ax)

fmt = '${x:,.0f}'
tick = mtick.StrMethodFormatter(fmt)
ax.yaxis.set_major_formatter(tick) 
plt.xticks(rotation=75)
plt.show()


b = df['Location'].value_counts()
b
location = [92,28,17,1]
slocation = sum(location)
plocation = [x / slocation for x in location]
plocation
