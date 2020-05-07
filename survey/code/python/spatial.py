import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import geopandas as gpd
from geopandas import GeoSeries, GeoDataFrame
from pathlib import Path
import seaborn as sns
import itertools

data_folder = Path('C:/Users/langzx/Desktop/github/DCM')
MRB = gpd.read_file(data_folder/"shapefilesMRB/3statesMRBclipped.shp")
MRB.crs
MRB.plot(color='white', edgecolor='grey')
MRB.columns
MRB_mn = MRB.loc[MRB['STATE_NAME'] == 'Minnesota']
county_all = pd.read_csv(data_folder/'survey/data/county_region.csv')
county_all.columns
mn = gpd.read_file(data_folder/"shapefilesMRB/MNcounties.shp")
mn.plot(color='grey', edgecolor= None)
mrb_region = pd.merge(MRB_mn, county_all,how='left',left_on='NAME', right_on='County')
mrb_region.plot(color='grey', edgecolor= None)




##region compare
region3 = pd.read_csv(data_folder/'survey/data/region_3.csv')
region3.columns

r3 = region3[['Region','MonthlyTax','Cashrental', 'impairedwater']]
r3_2 = region3[['Region','Living Cost','LandValue']]


regmelt = pd.melt(r3, id_vars=["Region"], value_vars=[
    'MonthlyTax','Cashrental', 'impairedwater' ])

regmelt2 = pd.melt(r3_2, id_vars=["Region"], value_vars=['Living Cost','LandValue'])


regmelt.head(5)

fig, (ax1, ax2) = plt.subplots(1, 2 ,figsize=(20, 20))

mn.plot(ax=ax1,color='lightgrey', linewidth=0.08 ,edgecolor='#B3B3B3')
mrb_region.plot(ax=ax1, column = 'Region_y', linewidth=0.8, cmap='summer_r',edgecolor='#B3B3B3', legend = True)
 
sns.barplot(data=regmelt, 
y="value",
x="variable",
hue="Region",
palette="summer_r")
plt.savefig(data_folder/'regioncompare.png', bbox_inches='tight', dpi=200)

               
plt.savefig(data_folder/'regionmap.png', bbox_inches='tight', dpi=200)
plt.show()


fig, (ax1, ax2) = plt.subplots(2, 1 ,figsize=(10, 10))


ax = sns.barplot(data=regmelt, 
y="value",
x="variable",
hue="Region",
palette="summer_r")

ax2 = ax.twinx()

sns.barplot(data=regmelt2, 
y="value",
x="variable",
hue="Region",
palette="summer_r",
ax = ax2)


plt.savefig(data_folder/'regioncompare.png', bbox_inches='tight', dpi=200)
