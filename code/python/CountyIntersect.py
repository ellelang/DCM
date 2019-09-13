from __future__ import print_function
from pathlib import Path
data_folder = Path("C:/Users/langzx/Desktop/github/DCM/data")
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import numpy as np
import pandas as pd

inter_data = pd.read_csv(data_folder/"intersect_data.csv")
inter_data
inter_data.info()
inter_data.sort_values(by=['Subbasin'])
grouped = inter_data.groupby('Subbasin')['Inter_acre']

pd.DataFrame({'count' : inter_data.groupby( 'Subbasin' ).size()}).reset_index()

def f(group):
     return pd.DataFrame({'original' : group, 'weight' : group / group.sum()}).reset_index()

weight_df = grouped.apply(f)

weight_df.replace('', np.nan, inplace=True)
weight_df.info()
weight_df
weight_df.to_csv(data_folder/'weights_area.csv')



####################
weights_intersect = pd.read_csv(data_folder/"weights_intersect.csv")
weights_intersect.info()

weights_intersect['WLD_w'] = weights_intersect['WLD'] * weights_intersect['weight'] 
weights_intersect['CC_w'] = weights_intersect['CC'] * weights_intersect['weight'] 
weights_intersect['NM_w'] = weights_intersect['NM'] * weights_intersect['weight'] 
weights_intersect['ASC_w'] = weights_intersect['ASC_obs'] * weights_intersect['weight'] 


grouped_w = weights_intersect.groupby('Subbasin')
weighted_costs = pd.DataFrame( grouped_w[['WLD_w','CC_w','NM_w','ASC_w']].sum()).reset_index()
weighted_costs.to_csv(data_folder/'weighted_costs.csv', index=False)
