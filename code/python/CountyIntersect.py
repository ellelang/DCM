from __future__ import print_function
from pathlib import Path
data_folder = Path("C:/Users/langzx/Desktop/github/DCM/data")
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import numpy as np
import pandas as pd
from pathlib import Path
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')

#inter_data = pd.read_csv(data_folder/"intersect_data.csv")
inter_data = pd.read_csv(data_folder/"intersect_3counties_data.csv")
inter_data
inter_data.info()

##Sort by subbasin and inter_acre, save it to a new file!!! 
inter_data = inter_data.sort_values(by=['Subbasin','inter_acre'])
inter_data
inter_data.to_csv(data_folder/"intersect_3counties_sorted.csv",index = False)

inter_data = pd.read_csv(data_folder/"intersect_3counties_sorted.csv")
grouped = inter_data.groupby('Subbasin')['inter_acre']

pd.DataFrame({'count' : inter_data.groupby( 'Subbasin' ).size()}).reset_index()

def f(group):
     return pd.DataFrame({'original' : group, 'weight' : group / group.sum()})

weight_df = grouped.apply(f)

weight_df.replace('', np.nan, inplace=True)
weight_df.info()
weight_df
weight_df['Subbasin'] = inter_data ['Subbasin']
weight_df.to_csv(data_folder/'weights_area_3counties.csv')

inter_data.info()
inter_data.index.name = 'Index'
####################
weight_area = pd.read_csv(data_folder/"weights_area_3counties.csv")
weight_area.info
weight_area.index.name = 'Index'

new_df2 = pd.merge(inter_data, weight_area,  how='inner', left_on=['Subbasin','Index'], right_on = ['Subbasin','Index'])

new_df2.info()
new_df2.to_csv(data_folder/"new_intersect_3counties.csv")


weights_intersect = new_df2
weights_intersect['WLD_w'] = weights_intersect['WLD'] * weights_intersect['weight'] 
weights_intersect['CC_w'] = weights_intersect['CC'] * weights_intersect['weight'] 
weights_intersect['NM_w'] = weights_intersect['NM'] * weights_intersect['weight'] 
weights_intersect['ASC_w'] = weights_intersect['ASC_obs'] * weights_intersect['weight'] 


grouped_w = weights_intersect.groupby('Subbasin')
weighted_costs = pd.DataFrame( grouped_w[['WLD_w','CC_w','NM_w','ASC_w']].sum()).reset_index()
weighted_costs.to_csv(data_folder/'weighted_costs_3counties.csv', index=False)
