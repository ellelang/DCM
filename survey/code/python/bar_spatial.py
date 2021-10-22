#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 22 10:29:34 2021

@author: ellelang
"""
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as mpatches
import pandas as pd
import numpy as np
import cmasher as cmr
import matplotlib.colors
import geopandas as gpd
from geopandas import GeoSeries, GeoDataFrame
from pathlib import Path


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





# prep values for map extents and more
llcrnrlat = 46.351611
llcrnrlon = -11.543011
urcrnrlat = 60.417133
urcrnrlon = 6.2743413
mid_lon = (urcrnrlon+llcrnrlon)/2.0
hr_lon = (urcrnrlon-llcrnrlon)/2.0
mid_lat = (urcrnrlat+llcrnrlat)/2.0
hr_lat = (urcrnrlat-llcrnrlat)/2.0

# function to create inset axes and plot bar chart on it
# this is good for 3 items bar chart
rng = np.arange(0, 70, 10)
def build_bar(mapx, mapy, ax, width, xvals=['a','b','c'], yvals=[1,4,2], fcolors=['r','y','b'], hatch_pattern = ['xx', '..', '/']):
    ax_h = inset_axes(ax, width=width, \
                    height=width, \
                    loc=3, \
                    bbox_to_anchor=(mapx, mapy), \
                    bbox_transform=ax.transData, \
                    borderpad=0, \
                    axes_kwargs={'alpha': 0.35, 'visible': True})
    rects = ax_h.patches
    
    for x,y,c,h in zip(xvals, yvals, fcolors, hatch_pattern):
        ax_h.bar(x, y, label=str(x), fc = c, hatch = h)
        
        #print(rects)
    for i in range(len(rects)):
        rect = rects[i]
        yi = yvals[i]
        #print([yi, rect])
        height  = rect.get_height()
        ax_h.text(rect.get_x() + rect.get_width() / 2, height + 6, f'{yi}%', family = 'serif', weight = 'bold',\
                  ha="center", va="bottom", color = 'black', size=9)
    
    #ax.xticks(range(len(xvals)), xvals, fontsize=10, rotation=30)
    ax_h.set_yticks(rng)
    ax_h.axis('off')
    return ax_h







fig, ax = plt.subplots(figsize=(10, 9))  # bigger is better

bm = Basemap(llcrnrlat= llcrnrlat,
             llcrnrlon= llcrnrlon,
             urcrnrlat= urcrnrlat,
             urcrnrlon= urcrnrlon,
             ax = ax,
             resolution='i', projection='tmerc', lon_0=-2, lat_0=49)

bm.fillcontinents(color='lightyellow', zorder=0)
bm.drawcoastlines(color='gray', linewidth=0.3, zorder=2)

plt.title('site_scores', fontsize=20)

# ======================
# make-up some locations
# ----------------------
n = 5   # you may use 121 here
lon1s = mid_lon + hr_lon*(np.random.random_sample(n)-0.5)
lat1s = mid_lat + hr_lat*(np.random.random_sample(n)-0.5)

# make-up list of 3-values data for the locations above
# -----------------------------------------------------
bar_data = np.random.randint(1,5,[n,3])  # list of 3 items lists
bar_data[0]

sc = np.array([52, 38, 35])
sw = np.array([15, 26, 32])
wc = np.array([23,33,29])

centroids = mrb_region.centroid
centroids
wc_centroid = [-96.08256, 45.28033]
sc_centroid = [-94.21259, 43.69028]
sw_centroid = [-96.25023, 44.23813]

centroid_all = [wc_centroid, sc_centroid, sw_centroid]

x_coord = centroids.x[0]
y_coord = centroids.y[0]


bar_data = [wc, sc, sw]
bar_data[0][0]

colors_map = ['#D3D3D3',"#808080", "#3D3D3D"]

bar_width = 0.8  # inch
bar_colors = ['#F5F5F5','#F5F5F5','#F5F5F5']
hatches = ['++', '..', r'\\\\']

fig, ax1 = plt.subplots(1,1,figsize=(15, 8))
#mn.plot(ax=ax1,color='gainsboro', linewidth=0.08 ,edgecolor='#B3B3B3')
mrb_region.plot(ax=ax1, column = 'Region_y', linewidth=0.8 ,cmap= matplotlib.colors.ListedColormap(colors_map), edgecolor='#B3B3B3', legend = False)
for i in range(len(bar_data)):
    x1, y1 = centroid_all[i][0], centroid_all[i][1]
    bax = build_bar(x1, y1, ax1, bar_width, xvals=['a','b','c'], \
              yvals=bar_data[i], fcolors=bar_colors, hatch_pattern=hatches)

# create legend (of the 3 classes)
patch0 = mpatches.Patch(facecolor=bar_colors[0], alpha=1, hatch = '++', label='C0: Engaging-absentee')
patch1 = mpatches.Patch(facecolor=bar_colors[1], alpha=1, hatch = '..', label='C1: Adoption-averse')
patch2 = mpatches.Patch(facecolor=bar_colors[2], alpha=1, hatch= r'\\\\',  label='C2: Environmentally-conscious')
ax1.legend(handles=[patch0,patch1,patch2], loc=1)
plt.show()

#####

##region compare
region3 = pd.read_csv(data_folder/'survey/data/region_3.csv')
region3.columns

r3 = region3[['Region','MonthlyTax','Cashrental', 'impairedwater']]
r3_2 = region3[['Region','Living Cost','LandValue']]


regmelt = pd.melt(r3, id_vars=["Region"], value_vars=[
    'MonthlyTax','Cashrental', 'impairedwater' ])

regmelt2 = pd.melt(r3_2, id_vars=["Region"], value_vars=['Living Cost','LandValue'])


regmelt.head(5)


fig, (ax1, ax2) = plt.subplots(1, 2 ,figsize=(14,7))
mrb_region.plot(ax=ax1, column = 'Region_y', linewidth=0.8 ,cmap= matplotlib.colors.ListedColormap(colors_map), edgecolor='#B3B3B3', legend = False)
for i in range(len(bar_data)):
    x1, y1 = centroid_all[i][0], centroid_all[i][1]
    bax = build_bar(x1, y1, ax1, bar_width, xvals=['a','b','c'], \
              yvals=bar_data[i], fcolors=bar_colors, hatch_pattern=hatches)

# create legend (of the 3 classes)
patch0 = mpatches.Patch(facecolor=bar_colors[0], alpha=1, hatch = '++', label='C0: Engaging-absentee')
patch1 = mpatches.Patch(facecolor=bar_colors[1], alpha=1, hatch = '..', label='C1: Adoption-averse')
patch2 = mpatches.Patch(facecolor=bar_colors[2], alpha=1, hatch= r'\\\\',  label='C2: Environmentally-conscious')
ax1.legend(handles=[patch0,patch1,patch2], loc=1)
ax1.set(xlabel='Longitude', ylabel= 'Latitude')

sns.barplot(data=regmelt, 
y="value",
x="variable",
hue="Region",
palette= "Greys",
ax = ax2)
ax2.set(xlabel='Regional characteristics')
plt.savefig(data_folder/'regioncompare_bar_greyscale.png', bbox_inches='tight', dpi=300)