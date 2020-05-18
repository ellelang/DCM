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
merg = pd.read_csv(data_folder/'data_demo.csv', encoding = "ISO-8859-1")
merg.columns
merg.shape
merg['gender']
merg.groupby(['gender']).size()
merg = merg.loc[(merg['gender'] =='Male') | (merg['gender'] =='Female')]
merg.shape
dat = merg[['gender', 'age', 'education',
       'income',  'landarea']]




dat.groupby(['gender','age','landarea']).size().unstack().plot.bar()

dat.groupby(['gender']).size()

gr = dat.groupby(['gender','age','income']).size()
gr
gr.sum()

gr / gr.sum()


gr = dat.groupby(['gender','age','landarea']).size()
gr_pct = gr.groupby(level = 0).apply(lambda x:100 * x / float(x.sum()))

state_pcts.to_csv(data_folder/'censussummary.csv')

pd.crosstab(dat ['gender'],dat['landarea']).apply(lambda r: round(r/r.sum(),3), axis=1)
