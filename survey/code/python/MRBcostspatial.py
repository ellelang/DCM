import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import geopandas as gpd
from geopandas import GeoSeries, GeoDataFrame
from pathlib import Path
import seaborn as sns
import itertools

#data_folder = Path('C:/Users/langzx/Desktop/github/DCM')
data_folder = Path('/Users/ellelang/Documents/github/DCM')
MRB = gpd.read_file(data_folder/"shapefilesMRB/3statesMRBclipped.shp")
MRB.crs
MRB.plot(color='white', edgecolor='grey')
MRB.columns
MRB.NAME 

MRB.loc[(MRB.STATE_NAME == 'South Dakota')&(MRB.NAME == 'Grant'), 'NAME'] = 'Grant_sd'

#MRB = MRB.loc[MRB['STATE_NAME'] == 'Minnesota']


cost_counties = pd.read_csv(data_folder/"data/cost_region1027.csv")
MRB_counties = pd.merge(MRB, cost_counties,how='left',left_on='NAME', right_on='County')
MRB_counties.columns
MRB_counties.plot(column = 'STATE_NAME', linewidth=0.8, cmap='Wistia',edgecolor='#B3B3B3', legend = True)
MRB_counties.plot(column = 'WLD', linewidth=0.8, cmap='summer_r',edgecolor='#B3B3B3', legend = True)

MRB_counties['coords'] = MRB_counties['geometry'].apply(lambda x: x.representative_point().coords[:])
MRB_counties['coords'] = [coords[0] for coords in MRB_counties['coords']]

list(MRB_counties['coords'])
MRB_counties['coords_m'] = (MRB_counties['coords']/10) + 1.1*np.sign(MRB_counties['coords'])

MRB_5_sub = gpd.read_file(data_folder/"shapefilesMRB/MRB_5_subbasins.shp")
MRB_5_sub = MRB_5_sub.to_crs("EPSG:4326") # world.to_crs(epsg=3395) would also work
MRB_5_sub.plot(color='white', edgecolor='grey')
MRB_5_sub.columns
sub_counties = pd.read_csv(data_folder/"data/intersect_3counties_sorted.csv")
MRB_5_sub_state = pd.merge(MRB_5_sub, sub_counties, how='left',left_on='Subbasin', right_on='Subbasin')


weighted_cost = pd.read_csv(data_folder/"data/weighted_costs_3counties_all0923.csv")
MRB_sub_weighted =  pd.merge(MRB_5_sub_state, weighted_cost, how='left',left_on='Subbasin', right_on='Subbasin')
#mnsub = MRB_sub_weighted.loc[MRB_sub_weighted['State']=='Minnesota']
#mnsub.plot(column = 'CC_w', linewidth=0.08, cmap='summer_r',edgecolor='#B3B3B3', legend = True)
MRB_sub_weighted.plot(column = 'WLD_w', linewidth=0.08, cmap='summer_r',edgecolor='#B3B3B3', legend = True)


f, ax = plt.subplots(1, figsize=(10, 10))
ax.set_title('')
for idx, row in MRB_counties.iterrows():
    ax.annotate(s=row['County'], xy=row['coords'],
                  verticalalignment='center',fontsize=8)

#MRB_counties.iloc[37,]
#MRB_counties[MRB_counties['Region'].isnull()].NAME
#MRB_counties.plot(ax = ax, column = 'Region', linewidth=0.8, cmap='jet',edgecolor='#B3B3B3', legend = True, alpha=0.6)
MRB_counties.plot(ax = ax, column = 'WLD', linewidth=0.8, cmap='summer_r',edgecolor='#B3B3B3', legend = True)
MRB_sub_weighted.plot(column = 'WLD_w', linewidth=0.08, cmap='summer_r',edgecolor='#B3B3B3', legend = True)



#######################
#subbasin_counties
import matplotlib.image as mpimg
from PIL import Image
MRBimage = Image.open(data_folder/"shapefilesMRB/Minnesotarivermap.png")
imgplot= plt.imshow(MRBimage)

f, axarr = plt.subplots(figsize=(35,15))

axarr.imshow(MRBimage)
axarr.axis('off')


import matplotlib.pylab as pylab
params = {'legend.fontsize': 'x-large',
          'figure.figsize': (15, 5),
         'axes.labelsize': 'x-large',
         'axes.titlesize':'x-large',
         'xtick.labelsize':'x-large',
         'ytick.labelsize':'x-large'}
pylab.rcParams.update(params)


fig1 = plt.figure(figsize=(35,24))
# fig2 = plt.figure()  # more figures are easily accessible
# fig3 = plt.figure()  # more figures are easily accessible

ax11 = fig1.add_subplot(222)  # add subplot into first position in a 2x2 grid (upper left)
ax12 = fig1.add_subplot(224)  # add to third position in 2x2 grid (lower left) and sharex with ax11
ax13 = fig1.add_subplot(121)  

ax11.axis('off')
ax12.axis('off')
ax13.axis('off')

ax12.legend(loc=2, prop={'size': 1})
ax11.legend(loc=2, prop={'size': 1})

for idx, row in MRB_counties.iterrows():
    ax11.annotate(s=row['County'], xy=row['coords'],
                  verticalalignment='bottom',fontsize=17)

MRB_counties.plot(ax = ax11, column = 'WLD', linewidth=1.8, cmap='summer_r',edgecolor='#B3B3B3', legend = True)
ax11.set_title('County-level WTA spatial distribution', size=36)

MRB_sub_weighted.plot(ax = ax12, column = 'WLD_w', linewidth=1.8, cmap='summer_r',edgecolor='#B3B3B3', legend = True)
ax12.set_title('Subbasin-level WTA spatial distribution', size=36)
#fontweight="bold",
ax13.imshow(MRBimage)
fig1.tight_layout(pad=1.0)

fig1.savefig(data_folder/'data/weightedcost.png' ,dpi = 300)

#bbox_inches = 'tight'