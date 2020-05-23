# -*- coding: utf-8 -*-
from scipy import stats
import pandas as pd
import numpy as np
from numpy import random
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from pathlib import Path
from scipy.stats import ttest_ind
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')
#dat0 =  pd.read_csv(data_folder/'factors7_0415.csv')

cluster = pd.read_csv(data_folder/'merged_cluster_0504.csv')
wld_origin = pd.read_csv(data_folder/'WLD_wta_0422_origin.csv')
cc_origin = pd.read_csv(data_folder/'CC_wta_0422_origin.csv')
nm_origin = pd.read_csv(data_folder/'NM_wta_0422_origin.csv')

wld_ba= pd.read_csv(data_folder/'WLD_wta_0422.csv')
cc_ba = pd.read_csv(data_folder/'CC_wta_0422.csv')
nm_ba = pd.read_csv(data_folder/'NM_wta_0422.csv')

wld_onlyatt= pd.read_csv(data_folder/'WLD_wta_onlyatt.csv')
cc_onlyatt = pd.read_csv(data_folder/'CC_wta_onlyatt.csv')
nm_onlyatt = pd.read_csv(data_folder/'NM_wta_onlyatt.csv')

fig, axes = plt.subplots(1, 3,sharey=True)
sns.distplot(wld_onlyatt[['MEAN']], hist=False, rug=False, ax=axes[0])
sns.distplot(cc_onlyatt[['MEAN']], hist=False, rug=False,ax=axes[1] )
sns.distplot(nm_onlyatt[['MEAN']], hist=False, rug=False, ax=axes[2])


wld_onlyatt.mean()
cc_onlyatt.mean()
nm_onlyatt.mean()

wld_origin.mean()
cc_origin.mean()
nm_origin.mean()
110
wld_ba.mean()
cc_ba.mean()
nm_ba.mean()


wld_origin['Practice']="WLD"
cc_origin['Practice']="CC"
nm_origin['Practice']="NM"

wld_origin['Model'] = 'Model2'
cc_origin['Model'] = 'Model2'
nm_origin['Model'] = 'Model2'

wld_origin['Cluster']= cluster.Cluster
cc_origin['Cluster']= cluster.Cluster
nm_origin['Cluster']= cluster.Cluster
wld_origin['Id']= cluster.id
cc_origin['Id']=cluster.id
nm_origin['Id']=cluster.id


wld_ba['Practice']="WLD"
cc_ba['Practice']="CC"
nm_ba['Practice']="NM"
wld_ba['Model']="Model3"
cc_ba['Model']="Model3"
nm_ba['Model']="Model3"

wld_ba['Cluster']= cluster.Cluster
cc_ba['Cluster']= cluster.Cluster
nm_ba['Cluster']= cluster.Cluster
wld_ba['Id']= cluster.id
cc_ba['Id']=cluster.id
nm_ba['Id']=cluster.id

wld_onlyatt['Practice']="WLD"
cc_onlyatt['Practice']="CC"
nm_onlyatt['Practice']="NM"
wld_onlyatt['Model']="Model1"
cc_onlyatt['Model']="Model1"
nm_onlyatt['Model']="Model1"

wld_onlyatt['Cluster']= cluster.Cluster
cc_onlyatt['Cluster']= cluster.Cluster
nm_onlyatt['Cluster']= cluster.Cluster
wld_onlyatt['Id']= cluster.id
cc_onlyatt['Id']=cluster.id
nm_onlyatt['Id']=cluster.id

frames = [wld_onlyatt,cc_onlyatt,nm_onlyatt,
          wld_origin, cc_origin, nm_origin,
          wld_ba, cc_ba,nm_ba]

whole_wta = pd.concat(frames)
whole_wta.columns
whole_wta.head(5)
wta_origin = whole_wta.loc[whole_wta['Model'] == 'Model2']
#wta_origin.shape
wta_ba = whole_wta.loc[whole_wta['Model'] == 'Model3']
wta_onlyatt = whole_wta.loc[whole_wta['Model'] == 'Model1']
wta_onlyatt.shape
      
        

plt.figure(figsize=(30,10))
g_org = sns.FacetGrid(whole_wta, col="Model", hue="Practice",sharey=False, sharex=False)
g_org = g_org.map(sns.distplot, "MEAN", hist=False, rug= False)

g_org.axes[0,0].set_xlabel('')
g_org.axes[0,1].set_xlabel('WTA estimates ($/acre)')
g_org.axes[0,2].set_xlabel('')
g_org.axes[0,0].set_ylabel('Probability')
g_org.add_legend()
g_org.savefig(data_folder/'wta_compare.png', bbox_inches = 'tight',dpi=200)



sns.catplot(x="Practice",
y="MEAN",
hue = 'Model',
data= whole_wta,
kind="box")
plt.show()



ttest_ind(wld_origin['MEAN'],wld_ba['MEAN'])
ttest_ind(cc_origin['MEAN'],cc_ba['MEAN'])
ttest_ind(nm_origin['MEAN'],nm_ba['MEAN'])

ttest_ind(wld_origin['CI_L'],wld_ba['CI_L'])

wta_onlyatt.columns
sns.catplot(x= 'Practice',
y="MEAN",
hue='Cluster',
data = wta_ba,
kind = "box")
plt.show()


ttest_ind(wld_onlyatt['MEAN'],wld_ba['MEAN'])
ttest_ind(cc_onlyatt['MEAN'],cc_ba['MEAN'])
ttest_ind(nm_onlyatt['MEAN'],nm_ba['MEAN'])

ttest_ind(wld_onlyatt['MEAN'],wld_origin['MEAN'])
ttest_ind(cc_onlyatt['MEAN'],cc_origin['MEAN'])
ttest_ind(nm_onlyatt['MEAN'],nm_origin['MEAN'])

