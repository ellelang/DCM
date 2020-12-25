import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import geopandas as gpd
from geopandas import GeoSeries, GeoDataFrame
from matplotlib.lines import Line2D
from pathlib import Path
import seaborn as sns
import itertools
import matplotlib.image as mpimg

data_folder = Path('C:/Users/langzx/Desktop/github/DCM')
#data_folder = Path('/Users/ellelang/Documents/github/DCM')
MRB = gpd.read_file(data_folder/"shapefilesMRB/3statesMRBclipped.shp")
MRB.crs
LSBGD = gpd.read_file(data_folder/"shapefilesMRB/LS_BGD.shp")
streams = gpd.read_file(data_folder/"shapefilesMRB/RiversMN.shp")
#streams = streams.loc[streams.STRM_LEVEL == 3]
river_names = ['Minnesota River' ]

streams = streams.loc[streams['NAME'].isin (river_names)]
# "NAME" = 'Minnesota River' OR 



MRB.plot(color='grey', edgecolor='face', linewidth=0.4)
LSBGD.plot(color='grey', edgecolor='face', linewidth=0.4)
usa = gpd.read_file(data_folder/"shapefilesMRB/USA.shp")
usa_bgd = usa.loc[(usa.STATE_NAME != 'Alaska')&(usa.STATE_NAME != 'Hawaii')] 
usa_bgd.plot(color='lightgrey', edgecolor='#B3B3B3', linewidth=0.4)
MN = usa.loc[(usa.STATE_NAME == 'Minnesota')] 
MN.plot(color='lightgrey', edgecolor='#B3B3B3', linewidth=0.4)


f, ax = plt.subplots(nrows = 2, ncols = 1, figsize=(24, 12))
plt.subplots_adjust(bottom=0.3, top=0.6, hspace=0)
ax[0].set_title('')
ax[0].axis('off')
ax[1].set_title('')
ax[1].axis('off')

usa_bgd.plot(ax = ax[0], color='whitesmoke', edgecolor='#B3B3B3', linewidth=0.4)
MN.plot(ax = ax[0], color='lightgrey', edgecolor='#B3B3B3', linewidth=0.4)
MRB.plot(ax = ax[0], color='silver', edgecolor='face', linewidth=0.4)
LSBGD.plot(ax = ax[0], color='gray', edgecolor='face', linewidth=0.4)
#streams.plot(ax = ax, color = 'blue', legend = False, linewidth = 3.2)

MN.plot(ax = ax[1], color='lightgrey', edgecolor='#B3B3B3', linewidth=0.4, label= "Minnesota State", legend = True)
MRB.plot(ax = ax[1], color='silver', edgecolor='face', linewidth=0.4, label = 'Minnesota River Basin', legend = True)
LSBGD.plot(ax = ax[1], color='gray', edgecolor='face', linewidth=0.4, label = 'Le Sueur River Watershed', legend = True)
#streams.plot(ax = ax, color = 'blue', legend = False, linewidth = 3.2)
custom_lines1 = [Line2D([0],[0], color='lightgrey', lw=7),
                Line2D([0], [0], color='silver', lw=7),
                Line2D([0], [0], color='gray', lw=7)
                ]
legend1 = ax[0].legend(custom_lines1, ['Minnesota State', 'Minnesota River Basin', 'Le Sueur River Watershed'], fontsize=7, loc='lower left')
legend1.get_frame().set_facecolor('white')
legend1.get_frame().set_linewidth(0.0)
plt.savefig(data_folder/'usabgd.png', bbox_inches='tight', dpi=300)
#ax[1].legend(loc='lower left')



subbasin = gpd.read_file(data_folder/"shapefilesMRB/LS_subbasins.shp")	
subbasin['geometry'].head()
#subbasin['geometry'] = subbasin['geometry'].to_crs(epsg=4326)
# destination coordinate syste
#subbasin= subbasin.to_crs({'init': 'epsg:4326'})
ls_stream =  gpd.read_file(data_folder/ "shapefilesMRB/LS_stream.shp")
#ls_stream = ls_stream.to_crs({'init' :'epsg:4326'})
gage = gpd.read_file(data_folder/"shapefilesMRB/LSgage2.shp")
#gage = gage.to_crs({'init' :'epsg:4326'})
gs = GeoSeries([Point(-120, 45), Point(-121.2, 46), Point(-122.9, 47.5),Point(-122.9, 47.5),Point(-122.9, 47.5)])
 

subbasin['coords'] = subbasin['geometry'].apply(lambda x: x.representative_point().coords[:])
subbasin['coords'] = [coords[0] for coords in subbasin['coords']]
#####################
cmap1 = plt.cm.summer_r
cmap2 = plt.cm.Paired
#fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(42, 42))
fig, ax1 = plt.subplots(1, 1, figsize=(24, 29))
# cmap = summer_r
subbasin.plot(ax = ax1, column = 'watershed', linewidth=1.5, cmap=cmap1,edgecolor='#B3B3B3', legend = True)
ls_stream.plot(ax = ax1, edgecolor='blue')
gage.plot(ax = ax1, marker='*', color='red', markersize=800)
for idx, row in subbasin.iterrows():
    ax1.annotate(s=row['Zone'], xy=row['coords'],
                 verticalalignment='center',fontsize=20,arrowprops=dict(facecolor='black', shrink=0.05))
#ax1.set_title('LeSueur River Watershed and hydrologic subbasins')
custom_lines1 = [Line2D([0],[0], color='w', lw=20),
                Line2D([0], [0], color=cmap1(0.), lw=20),
                Line2D([0], [0], color=cmap1(.5), lw=20),
                Line2D([0], [0], color=cmap1(1.), lw=20),
                Line2D([0], [0], marker='*', color='w',markersize=20, markerfacecolor='red'),
                Line2D([0], [0],  color='w',markersize=20, markerfacecolor='w'),
                Line2D([0], [0],  color='w',markersize=20, markerfacecolor='w'),
                Line2D([0], [0],  color='w',markersize=20, markerfacecolor='w')]
legend1 = ax1.legend(custom_lines1, ['Subwatersheds:','Cobb River', 'LeSueur River', 'Maple River','Gages','Zone 1 = Upland','Zone 2 = Transitional','Zone 3 = Incised'], fontsize=20)
legend1.get_frame().set_facecolor('white')
legend1.get_frame().set_linewidth(0.0)
#ax1.text(-0.1, 1.1, 'A', transform=ax1.transAxes, 
#            size=60, weight='bold')
#ax1.grid(False)
#ax1.axis('off')
plt.savefig(data_folder/'introma.png', bbox_inches='tight', dpi=500)
#################
from PIL import Image
mosm = Image.open(data_folder/'intromap.png')
plt.imshow(mosm)
bgd = Image.open(data_folder/'usabgd.png')

f, ax = plt.subplots(nrows = 1, ncols = 2, figsize=(24, 24))
ax[0].set_title('')
ax[0].axis('off')
ax[1].set_title('')
ax[1].axis('off')
ax[0].imshow(bgd)
ax[1].imshow(mosm)
plt.savefig(data_folder/'chp2.png', bbox_inches='tight', dpi=500)


