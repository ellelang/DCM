#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 08:28:42 2025

@author: ellelang
"""

from numpy import random
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from pathlib import Path
from scipy.stats import ttest_ind
from scipy.stats import ttest_rel
from statsmodels.stats.outliers_influence import variance_inflation_factor
data_folder = Path('/Users/ellelang/Desktop/github/DCM/survey/data')
#dat0 =  pd.read_csv(data_folder/'factors7_0415.csv')
data = pd.read_csv(data_folder/'merged_cluster_region.csv')

data.columns

selected_col = [ 'aware',
       'past', 'appreciate', 'social',
       'taxcost','implakes',
       'incomefromfarming','landarea','dflmean']

# 'mean_wld','mean_cc','mean_nm',
X = data[selected_col]
print(X.isna().sum())

# Check for Inf values
print(np.isinf(X).sum())

#df_clean = X.fillna(X.mean()) 
df_clean = X.dropna()

vif = pd.DataFrame()
vif["Variable"] = selected_col

vif["VIF"] = [variance_inflation_factor(df_clean.values, i) for i in range(df_clean.shape[1])]

print(vif.sort_values(by = 'VIF'))


df_clean.columns

renamed_cols = ['F_aware', 'F_pastexperience','F_appreciation', 'F_responsibility',
                'Tax', 'Impaired_lakes','Income_fromfarming', 'Landsize', 'Political_vote']
df_clean.columns  = renamed_cols 
corr_matrix = df_clean.corr()
plt.figure(figsize=(10,8))
sns.heatmap(corr_matrix, annot=True, cmap="coolwarm", fmt=".2f")
plt.show()


# Compute correlation of dfl08to18 with all other variables
correlations = df_clean.corr()#[['Tax','Political_vote']]
#.sort_values(ascending=False)

correlations
