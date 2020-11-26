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
from scipy.stats import ttest_rel
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')
#dat0 =  pd.read_csv(data_folder/'factors7_0415.csv')
wld_origin = pd.read_csv(data_folder/'WLD_wta_originmarginal.csv')
cc_origin = pd.read_csv(data_folder/'CC_wta_originmarginal.csv')
nm_origin = pd.read_csv(data_folder/'NM_wta_originmarginal.csv')

wld_origin.head(3)


wld_ba= pd.read_csv(data_folder/'WLD_wta_bamarginal.csv')
cc_ba = pd.read_csv(data_folder/'CC_wta_bamarginal.csv')
nm_ba = pd.read_csv(data_folder/'NM_wta_bamarginal.csv')

wld_onlyatt= pd.read_csv(data_folder/'WLD_wta_onlyattmarginal.csv')
cc_onlyatt = pd.read_csv(data_folder/'CC_wta_onlyattmarginal.csv')
nm_onlyatt = pd.read_csv(data_folder/'NM_wta_onlyattmarginal.csv')


wld_onlyatt.mean()
cc_onlyatt.mean()
nm_onlyatt.mean()

wld_origin.mean()
cc_origin.mean()
nm_origin.mean()

wld_ba.mean()
cc_ba.mean()
nm_ba.mean()


wld_origin['Practice']="WLD"
cc_origin['Practice']="CC"
nm_origin['Practice']="NM"

wld_origin['Model'] = 'Model2'
cc_origin['Model'] = 'Model2'
nm_origin['Model'] = 'Model2'



wld_ba['Practice']="WLD"
cc_ba['Practice']="CC"
nm_ba['Practice']="NM"
wld_ba['Model']="Model3"
cc_ba['Model']="Model3"
nm_ba['Model']="Model3"



wld_onlyatt['Practice']="WLD"
cc_onlyatt['Practice']="CC"
nm_onlyatt['Practice']="NM"
wld_onlyatt['Model']="Model1"
cc_onlyatt['Model']="Model1"
nm_onlyatt['Model']="Model1"



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
      
whole_wta.head(4)   

# plt.figure(figsize=(30,10))
# g_org = sns.FacetGrid(whole_wta, col="Model", hue="Practice",sharey=False, sharex=False, palette="summer")
# g_org = g_org.map(sns.distplot, "MEAN", hist=False, rug= False)

# g_org.axes[0,0].set_xlabel('')
# #g_org.axes[0,0].set(xticks= np.arange(0, 500, 50))
# g_org.axes[0,1].set_xlabel('marginal WTA estimates ($/acre)')
# g_org.axes[0,2].set_xlabel('')
# g_org.axes[0,0].set_ylabel('Probability')
# g_org.add_legend()      
        

# plt.figure(figsize=(30,10))
# g_org = sns.FacetGrid(whole_wta, col="Model", hue="Practice",sharey=False, sharex=False, palette="summer")
# g_org = g_org.map(sns.distplot, "MEAN", hist=False, rug= False)


plt.figure(figsize=(30,10))
g_org = sns.FacetGrid(whole_wta, col="Practice", hue="Model",sharey=False, sharex=False)
g_org = g_org.map(sns.distplot, "MEAN", hist=False, rug= False, 
                  kde_kws=dict(linewidth=1.2))

g_org.axes[0,0].set_xlabel('')
g_org.axes[0,1].set_xlabel('marginal WTA estimates ($/acre)')
g_org.axes[0,2].set_xlabel('')
g_org.axes[0,0].set_ylabel('Probability')
g_org.add_legend()
g_org.savefig(data_folder/'marginalwta_compare.png', bbox_inches = 'tight',dpi=200)

wta_onlyatt = whole_wta.loc[whole_wta['Model'] == 'Model1']

sns.catplot(x="Practice",
y="MEAN",
data= wta_onlyatt,
kind="box")
plt.show()

stats.mannwhitneyu(wld_origin['MEAN'],wld_ba['MEAN'])


wld_onlyatt.mean()

wld_origin.mean()

nm_onlyatt.quantile([.25, .75])

nm_origin.quantile([.25, .75])

nm_ba.quantile([.25, .75])


ttest_rel(wld_origin['MEAN'],wld_ba['MEAN'])
ttest_rel(cc_origin['MEAN'],cc_ba['MEAN'])
ttest_rel(nm_origin['MEAN'],nm_ba['MEAN'])

ttest_rel(wld_onlyatt['MEAN'],wld_origin['MEAN'])
ttest_rel(cc_onlyatt['MEAN'],cc_origin['MEAN'])
ttest_rel(nm_onlyatt['MEAN'],nm_origin['MEAN'])


ttest_rel(wld_onlyatt['MEAN'],wld_ba['MEAN'])
ttest_rel(cc_onlyatt['MEAN'],cc_ba['MEAN'])
ttest_rel(nm_onlyatt['MEAN'],nm_ba['MEAN'])


plt.figure(figsize=(30,10))
g_org = sns.FacetGrid(whole_wta, col="Practice", hue="Model",sharey=False, sharex=False)
g_org = g_org.map(sns.distplot, "MEAN", hist=False, rug= False, 
                  kde_kws=dict(linewidth=1.2))

g_org.axes[0,0].set_xlabel('')
g_org.axes[0,1].set_xlabel('marginal WTA estimates ($/acre)')
g_org.axes[0,2].set_xlabel('')
g_org.axes[0,0].set_ylabel('Probability')
g_org.add_legend()