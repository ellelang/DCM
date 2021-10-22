#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 24 15:38:23 2021

@author: ellelang
"""

from scipy import stats
import pandas as pd
import numpy as np
from numpy import random
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from pathlib import Path
#data_folder = Path('C:/Users/langzx/Desktop/github/DCM/survey/data')
data_folder = Path('/Users/ellelang/Desktop/github/DCM/survey/data')
#dat0 =  pd.read_csv(data_folder/'factors7_0415.csv')
dat0 = pd.read_csv(data_folder/'scoresall_0501.csv')




dat0.columns

dat = dat0[['concern','att_wld_unfav','att_nm_unfav','comp', 'norm_control', 'aware','past', 'appreciate','social']]
#dat = dat0[['aware','past','appreciate','resp']]

dat.columns
minlist = dat.min()
minlist['aware']

aware_log = np.log(dat['aware']-minlist['aware'] + 1).astype('float64')
past_log = np.log(dat['past']-minlist['past'] + 1).astype('float64')
app_log = np.log(dat['appreciate']-minlist['appreciate'] + 1).astype('float64')
social_log = np.log(dat['social']-minlist['social'] + 1).astype('float64')

concern_log = np.log(dat['concern']-minlist['concern'] + 1).astype('float64')
norm_log = np.log(dat['norm_control']-minlist['norm_control'] + 1).astype('float64')
wldunfav_log = np.log(dat['att_wld_unfav']-minlist['att_wld_unfav'] + 1).astype('float64')
nmunfav_log = np.log(dat['att_nm_unfav']-minlist['att_nm_unfav'] + 1).astype('float64')
comp_log= np.log(dat['comp']-minlist['comp'] + 1).astype('float64')
#dat = dat[['aware','past','appreciate','landcontrol']]

sns.distplot(app_log)
dat_log = pd.DataFrame({
                        
                        'Aware': aware_log,
                        'Past_experience': past_log,
                        'Appreciation': app_log,
                        'Social_norms': social_log,
                        'Concern': concern_log,
                        'Behavior_control': norm_log,
                        'Attitude_unfavorable_wld': wldunfav_log,
                        'Attitude_unfavorable_nm': nmunfav_log,
                        'Attitude_favorable': comp_log
                        })

dat_log.columns
data_log_sel = dat_log[['Aware','Past_experience','Appreciation','Social_norms']]
data_log_sel.mean()
data_log_sel.std()
sns.violinplot(data = data_log_sel)
sns.violinplot(data = data_log_sel)
dataaaa = dat_log[['Concern', 'Social_norms', 'Attitude_unfavorable_wld','Attitude_unfavorable_nm', 'Attitude_favorable']]
sns.violinplot(data = dataaaa)


from sklearn.preprocessing import StandardScaler
# Initialize a scaler
scaler = StandardScaler()

# Fit the scaler
scaler.fit(dat_log)

# Scale and center the data
data_normalized = scaler.transform(dat_log)

# Create a pandas DataFrame
data_normalized = pd.DataFrame(data_normalized , columns=dat_log.columns)


from sklearn.cluster import KMeans
sse =  {}

for k in range(1,11):
  
    # Initialize KMeans with k clusters
    kmeans = KMeans(n_clusters=k, random_state=1)
    
    # Fit KMeans on the normalized dataset
    kmeans.fit(data_normalized)
    
    # Assign sum of squared distances to k element of dictionary
    sse[k] = kmeans.inertia_

plt.title('The Elbow Method')

# Add X-axis label "k"
plt.xlabel('k')

# Add Y-axis label "SSE"
plt.ylabel('SSE')

# Plot SSE values for each key in the dictionary
sns.pointplot(x=list(sse.keys()), y=list(sse.values()))
plt.show()

# Initialize KMeans
# Initialize KMeans
kmeans = KMeans(n_clusters =3, random_state =1) 

# Fit k-means clustering on the normalized data set
kmeans.fit(data_normalized)

# Extract cluster labels
cluster_labels = kmeans.labels_ 
#cluster_labels = cluster_labels
cluster_labels
# Create a DataFrame by adding a new cluster label column
data_k3 = dat.assign(Cluster=cluster_labels)

data_k3.head(5)	
data_k3.columns
# Group the data by cluster
grouped = data_k3.groupby(['Cluster'])
data_k3['Cluster']
# Calculate average RFM values and segment sizes per cluster value
grouped.agg('mean').round(3)

data_k3 = pd.read_csv(data_folder/"fscore_0504_9_cluster.csv")

data_normalized['Cluster'] = data_k3['Cluster']
data_normalized['id'] = dat0['id']
datanormalized_melt = pd.melt(
  					data_normalized, 
                        
# Assign CustomerID and Cluster as ID variables
                    id_vars=['id','Cluster'],

# Assign RFM values as value variables
                    value_vars=[ 
                                'Appreciation', 'Aware','Behavior_control','Concern',
'Attitude_unfavorable_wld','Attitude_unfavorable_nm', 'Past_experience','Social_norms','Attitude_favorable'], 
                        
# Name the variable and value
                    var_name='Constructs', value_name ='Log(ln) transformed average factor scores'
					)

datanormalized_melt.columns
datanormalized_melt.head(3)

plt.xlabel('Constructs')

# Add the y axis label
plt.ylabel('Log transformed factor scores')

#current_palette = sns.color_palette()
#sns.color_palette("tab10")
#plt.figure(figsize=(10,8))
# Plot a line for each value of the cluster variable
g= sns.lineplot(data=datanormalized_melt,
             x='Constructs', y='Log(ln) transformed average factor scores', hue='Cluster'
             )
leg = g.axes.get_legend()
leg.texts
new_labels = ['C0: Engaging-absentee', 'C1: Adoption-averse', 'C2: Environmentally-conscious']
for t, l in zip(leg.texts, new_labels): t.set_text(l)
#plt.show()
plt.xticks(rotation=25, fontsize = 8)
plt.savefig(data_folder/'snakeplot.png',dpi=300, bbox_inches='tight')
plt.show()