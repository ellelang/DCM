from pathlib import Path
data_folder = Path("C:/Users/langzx/Desktop/github/DCM/output")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
wld = pd.read_csv(data_folder/"WLD_wta_0214.csv")
cc = pd.read_csv(data_folder/"CC_wta_0214.csv")
nm = pd.read_csv(data_folder/"NM_wta_0214.csv")
wld.columns
wld.index
np.arange(1, 442, 1)
wta_all = pd.DataFrame(columns = ['ID','Wetland', 'Cover Crops','Nutrient Management'])
wta_all['ID'] = np.arange(1, 442, 1)
wta_all['Wetland'] = wld['MEAN']
wta_all['Cover Crops'] = cc['MEAN']
wta_all['Nutrient Management'] = nm['MEAN']

wta_all.to_csv("C:/Users/langzx/Desktop/github/DCM/output/wta_all_mean.csv",index=False)
wta_melt = pd.melt(wta_all, id_vars= 'ID', value_vars=['Wetland', 'Cover Crops','Nutrient Management'])
wta_melt
wta_melt.to_csv("C:/Users/langzx/Desktop/github/DCM/output/wta_pivot.csv",index=False)

conservation = ['Wetland', 'Cover Crops','Nutrient Management']
# Iterate through the five airlines


for i in conservation:
    # Subset to the airline
    subset = wta_melt[wta_melt['variable'] == i]
    sns.distplot(subset['value'], hist = False, kde = True,
                 kde_kws = {'linewidth': 3},
                 label = i)
    
plt.legend(loc= 1, fontsize = 5, title = 'Conservation actions')
plt.title('Willingess to Accept of key conservation actions')
plt.xlabel('WTA')
plt.ylabel('Density')
plt.savefig("wta.png", dpi = 800)
plt.show()

def CIdata (data):
    CI_df = pd.DataFrame(columns = ['WTA', 'Low_CI', 'Upper_CI'])
    CI_df['WTA'] = data['MEAN']
    CI_df['Low_CI'] = data['CI_L']
    CI_df['Upper_CI'] = data['CI_U']
    CI_df.sort_values('WTA', inplace = True)
    return CI_df


wld_ci = CIdata(wld)





sns.distplot(wld['MEAN'], hist = False, kde = True,
                 kde_kws = {'linewidth': 3},
                 label = "wetland")




plt.xlabel('WTA')
plt.fill_between(wld_ci['WTA'], wld_ci['Low_CI'], wld_ci['Upper_CI'], color = '#539caf', alpha = 0.4, label = '95% CI')