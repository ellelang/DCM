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
wld_origin = pd.read_csv(data_folder/'WLD_wta_0422_origin.csv')
cc_origin = pd.read_csv(data_folder/'CC_wta_0422_origin.csv')
nm_origin = pd.read_csv(data_folder/'NM_wta_0422_origin.csv')

wld_ba= pd.read_csv(data_folder/'WLD_wta_0422.csv')
cc_ba = pd.read_csv(data_folder/'CC_wta_0422.csv')
nm_ba = pd.read_csv(data_folder/'NM_wta_0422.csv')

wld_origin['Practice']="WLD"
cc_origin['Practice']="CC"
nm_origin['Practice']="NM"
wld_origin['Model'] = 'Socio-demo'
cc_origin['Model'] = 'Socio-demo'
nm_origin['Model'] = 'Socio-demo'

wld_ba['Practice']="WLD"
cc_ba['Practice']="CC"
nm_ba['Practice']="NM"
wld_ba['Model']="B-Att"
cc_ba['Model']="B-Att"
nm_ba['Model']="B-Att"

frames = [wld_origin, cc_origin, nm_origin,
          wld_ba, cc_ba,nm_ba]

whole_wta = pd.concat(frames)
whole_wta.columns
wta_origin = whole_wta.loc[whole_wta['Model'] == 'Socio-demo']
wta_origin.shape
wta_ba = whole_wta.loc[whole_wta['Model'] == 'B-Att']


plt.figure(figsize=(20,10))
g_org = sns.FacetGrid(whole_wta, col="Model", hue="Practice")
g_org = g_org.map(sns.distplot, "MEAN", hist=False, rug= False)
g_org.axes[0,0].set_xlabel('WTA estimates ($/acre)')
g_org.axes[0,1].set_xlabel('WTA estimates ($/acre)')
g_org.axes[0,0].set_ylabel('Probability')
g_org.add_legend()
g_org.savefig(data_folder/'wta_compare.png', dpi=200)


g_ba = sns.FacetGrid(wta_ba, hue="Practice")
g_ba = g_ba.map(sns.distplot, "CI_L", hist=False, rug=False)
g_ba.add_legend()

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
