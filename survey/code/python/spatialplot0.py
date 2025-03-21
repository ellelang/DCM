#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 24 15:55:26 2021

@author: ellelang
"""

import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import geopandas as gpd
from geopandas import GeoSeries, GeoDataFrame
from pathlib import Path
import seaborn as sns
import cmasher as cmr
import matplotlib.colors

import itertools

#colors_3 = cmr.take_cmap_colors('gray', 3, cmap_range=(0.25, 0.85), return_fmt='hex')
colors_3 = ['#696969','#A9A9A9', '#C0C0C0']
cmap_3= matplotlib.colors.ListedColormap(colors_3)
matplotlib.colors.cnames


#data_folder = Path('C:/Users/langzx/Desktop/github/DCM')
data_folder = Path('/Users/ellelang/Desktop/github/DCM')
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
mrb_region.loc[mrb_region['County'] =="Dakota", 'Region_y'] = "Southcentral"
mrb_region.loc[mrb_region['County'] =="Otter Tail", 'Region_y'] = "Westcentral"


##region compare
region3 = pd.read_csv(data_folder/'survey/data/region_3.csv')
region3.columns

r3 = region3[['Region','MonthlyTax','Cashrental', 'impairedwater']]
r3_2 = region3[['Region','Living Cost','LandValue']]


regmelt = pd.melt(r3, id_vars=["Region"], value_vars=[
    'MonthlyTax','Cashrental', 'impairedwater' ])

regmelt2 = pd.melt(r3_2, id_vars=["Region"], value_vars=['Living Cost','LandValue'])


regmelt.head(5)
# Wanted palette details
#enmax_palette = ["#808282", "#C2CD23", "#918BC3"]

#sns.set_palette(palette=enmax_palette)

colors = ['#C0C0C0','#696969', "#000000"]
# Set your custom color palette
sns.set_palette(sns.color_palette(colors))

fig, (ax1, ax2) = plt.subplots(1, 2 ,figsize=(10, 4))

mn.plot(ax=ax1,color='gainsboro', linewidth=0.08 ,edgecolor='#B3B3B3')
mrb_region.plot(ax=ax1, column = 'Region_y', linewidth=0.8, cmap= 'summer_r', edgecolor='#B3B3B3', legend = True)
ax1.set(xlabel='Longitude', ylabel= 'Latitude')
ax1.legend(prop=dict(size=7))  
             
sns.barplot(data=regmelt, 
y="value",
x="variable",
hue="Region",
palette= 'summer_r',
ax = ax2)
ax2.set(xlabel='Regional characteristics')

plt.savefig(data_folder/'regioncompare.png', bbox_inches='tight', dpi=300)