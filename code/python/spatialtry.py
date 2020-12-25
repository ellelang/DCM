from pathlib import Path
data_folder = Path('C:/Users/langzx/Desktop/github/DCM')
#data_folder = Path('/Users/ellelang/Documents/github/DCM/data')
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import altair as alt
from vega_datasets import data
import geopandas as gpd
from geopandas import GeoSeries, GeoDataFrame


data_folder = Path('C:/Users/langzx/Desktop/github/DCM')
#data_folder = Path('/Users/ellelang/Documents/github/DCM')
MRB = gpd.read_file(data_folder/"shapefilesMRB/3statesMRBclipped1.shp")
MRB.crs
MRB.plot(color='white', edgecolor='grey')
MRB.columns
MRB.NAME 

MRB.loc[(MRB.STATE_NAME == 'South Dakota')&(MRB.NAME == 'Grant'), 'NAME'] = 'Grant_sd'

#MRB = MRB.loc[MRB['STATE_NAME'] == 'Minnesota']


cost_counties = pd.read_csv(data_folder/"data/cost_region1027.csv")
MRB_counties = pd.merge(MRB, cost_counties,how='left',left_on='NAME', right_on='County')
MRB_counties.columns
#len(MRB_counties.geometry)
# regionname = cost.Region.unique().tolist()
# regionname_sort = ['Northeast',
#  'Northwest',
#  'Westcentral',
#  'Southcentral',
#  'Southwest',
#  'Iowa',
#  'South Dakota'
#  ]
airports = data.airports.url
airports
points = alt.Chart(airports).transform_aggregate(
    latitude='mean(latitude)',
    longitude='mean(longitude)',
    count='count()',
    groupby=['state']
)
points.show()


states = alt.topo_feature(MRB_counties, feature='STATE_NAME')

background = alt.Chart(MRB_counties).mark_geoshape(
    fill='lightgray',
    stroke='white'
).properties(
    width=500,
    height=300
).project('albersUsa')

background.show()



df1 = cost.melt(id_vars=['County'], 
              value_vars=['WLD', 'CC', 'NM', 'ASC_obs'],
              var_name='Types', value_name='WTAs')

df1.head(3)
alt.renderers.enable('altair_viewer')
bar = alt.Chart(df1).mark_bar().encode(
    x='County',
    y='WTAs',
    color='Types'
    )

bar.show()
df2 = pd.merge(df1, MRB, how='left', left_on='County', right_on='NAME')
df2.lon
df2.columns

background + bars




df2 = df2[['County', 'Types' ,'WTAs','lat','lon']]
# airport positions on background
points = alt.Chart(df2).transform_aggregate(
    latitude='mean(lat)',
    longitude='mean(lon)',
    count='count()',
    groupby=['County']
).mark_circle().encode(
    longitude='longitude:Q',
    latitude='latitude:Q',
    size=alt.Size('count:Q', title='Number of Airports'),
    color=alt.value('steelblue'),
    tooltip=['County:N','count:Q']
).properties(
    title='Number of airports in US'
)
points.show()


bars = alt.Chart(df2).transform_aggregate(
    latitude='mean(lat)',
    longitude='mean(lon)',
    groupby=['County'],
    totalwta = 'sum(WTAs)'
).mark_circle(size=78).encode(
    longitude='longitude:Q',
    latitude='latitude:Q',
    color='totalwta:Q',
    
    #color=alt.value('steelblue'),
    tooltip=['County:N','totalwta:Q']
).properties(
    title='Counties WTAs (WLD+CC+NM+ASC)'
)

#bars.show()

total = background + bars   
total.show()



mark_bar().encode(
    longitude='longitude:Q',
    latitude='latitude:Q',
    x='County',
    y='WTAs'    
    )

bars.show()
