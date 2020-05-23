# -*- coding: utf-8 -*-
from scipy import stats
import pandas as pd
import numpy as np
from numpy import random
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path
from scipy.stats import ttest_ind
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')
#dat0 =  pd.read_csv(data_folder/'factors7_0415.csv')

plt.rcParams['axes.labelsize'] = 14
plt.rcParams['axes.titlesize'] = 14
plt.rcParams['xtick.labelsize'] = 14
plt.rcParams['ytick.labelsize'] = 14
plt.rcParams['legend.fontsize'] = 12
plt.rcParams['legend.title_fontsize'] = 12
 
merg = pd.read_csv(data_folder/'data_demo.csv', encoding = "ISO-8859-1")
merg.columns
merg.shape
merg['gender']
merg.groupby(['gender']).size()
datt = merg.loc[(merg['gender'] =='Male') | (merg['gender'] =='Female')]
datt.shape
dat = datt[['gender', 'age', 'education',
       'income',  'landarea','countyresident']]

dat.groupby(['gender']).size()
dat.groupby(['countyresident']).size()
dat['age'].unique()
dat['income'] = dat['income'].astype('category')
dat['education'] = dat['education'].astype('category')
dat['age'] = dat['age'].astype('category')
dat['gender'] = dat['gender'].astype('category')

dat['age'].cat.reorder_categories(['Under 30','30-50',
   '50-70','Over 70'],inplace=True)

dat['gender'].cat.reorder_categories(['Male',
   'Female'],inplace=True)


dat['income'].cat.reorder_categories(['$1 -$24,999','$25,000 - $99,999',
 '$100,000 - $249,999', '$250,000 - $499,999','$500,000 - $999,999','More than $1,000,000', 'None'], inplace=True)

dat['education'].cat.reorder_categories(['High school diploma','Some college degree',
   'B.A., B.S., or equivalent','Graduate degree' ],inplace=True)


fig, axes = plt.subplots(nrows = 1, ncols = 3, figsize = (20,8))
dat.groupby(['gender','age','education']).size().unstack().plot(ax=axes[0],kind='bar',  stacked=True)
dat.groupby(['gender','age','landarea']).size().unstack().plot(ax=axes[1],kind='bar',stacked=True)

dat.groupby(['gender','age','income']).size().unstack().plot(ax=axes[2],kind='bar',stacked=True)

axes[0].legend(title="Education",loc='upper right')
axes[1].legend(title="Farm size",loc='upper right')
axes[2].legend(title="Income",loc='upper right');
fig.savefig(data_folder/'census.png', dpi=200, bbox_inches='tight')
plt.show()

dat.groupby(['gender','age','landarea']).size().unstack().plot.bar()

dat.groupby(['age']).size()/441 * 100
dat.groupby(['landarea']).size()/441 * 100
dat.groupby(['income']).size()/441 * 100

16.3+ 12.5+  13.8+ 3.4
gr = dat.groupby(['gender','age','income']).size()
gr
gr.sum()

gr / gr.sum()


gr = dat.groupby(['gender','age','landarea']).size()
gr_pct = gr.groupby(level = 0).apply(lambda x:100 * x / float(x.sum()))

gr_pct.to_csv(data_folder/'censussummary.csv')

pd.crosstab(dat ['gender'],dat['landarea']).apply(lambda r: round(r/r.sum(),3), axis=1)


censusg = np.array([71479, 25535])
sum(censusg)
censusg/97014

fdat = pd.read_csv(data_folder/'merged_cluster_0504.csv')
fdat.columns
ff = fdat[['concern','past', 'appreciate', 'social']]
ff.std()
sns.violinplot(data=ff)
