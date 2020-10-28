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
#data_folder = Path('/Users/ellelang/Documents/github/DCM')
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

#MRB_counties.iloc[37,]
#MRB_counties[MRB_counties['Region'].isnull()].NAME

MRB_counties.plot(column = 'Region', linewidth=0.8, cmap='Set2',edgecolor='#B3B3B3', legend = True, alpha=0.6)


MRB_5_sub = gpd.read_file(data_folder/"shapefilesMRB/MRB_5_subbasins.shp")
MRB_5_sub = MRB_5_sub.to_crs("EPSG:4326") # world.to_crs(epsg=3395) would also work
MRB_5_sub.plot(color='white', edgecolor='grey')
MRB_5_sub.columns
sub_counties = pd.read_csv(data_folder/"data/intersect_3counties_sorted.csv")
MRB_5_sub_state = pd.merge(MRB_5_sub, sub_counties, how='left',left_on='Subbasin', right_on='Subbasin')



weighted_cost = pd.read_csv(data_folder/"data/weighted_costs_3counties_all0923.csv")
MRB_sub_weighted =  pd.merge(MRB_5_sub_state, weighted_cost, how='left',left_on='Subbasin', right_on='Subbasin')
mnsub = MRB_sub_weighted.loc[MRB_sub_weighted['State']=='Minnesota']
mnsub.plot(column = 'CC_w', linewidth=0.08, cmap='summer_r',edgecolor='#B3B3B3', legend = True)
MRB_sub_weighted.plot(column = 'CC_w', linewidth=0.08, cmap='summer_r',edgecolor='#B3B3B3', legend = True)
#######################
#subbasin_counties
import matplotlib.image as mpimg
from PIL import Image
MRBimage = Image.open(data_folder/"shapefilesMRB/Minnesotarivermap.png")


f, axarr = plt.subplots(figsize=(35,15))

axarr.imshow(MRBimage)
axarr.axis('off')
