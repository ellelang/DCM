from pathlib import Path
data_folder = Path("C:/Users/langzx/Desktop/github/DCM/data")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import itertools 	
wld = pd.read_csv(data_folder/"WLD_wta_0418_origin.csv")
cc = pd.read_csv(data_folder/"CC_wta_0418_origin.csv")
nm = pd.read_csv(data_folder/"NM_wta_0418_origin.csv")
fa = pd.read_csv(data_folder/"../data/fscore_04112020_cluster.csv")
fa = pd.read_csv(data_folder/"../data/fscore_04162020_cluster.csv")
fa.columns
wld = pd.read_csv(data_folder/"WLD_wta_0418.csv")
cc = pd.read_csv(data_folder/"CC_wta_0418.csv")
nm = pd.read_csv(data_folder/"NM_wta_0418.csv")
proby = pd.read_csv(data_folder/"../data/predprob.csv")
fa = pd.read_csv(data_folder/"../data/fscore_0418_4_cluster.csv")
fa.columns
proby.columns


cc.mean()
wld.mean()
nm.mean()


wta_all = pd.DataFrame(columns = ['id','Wetland', 'Cover Crops','Nutrient Management'])
wta_all['id'] = fa['id']
wta_all['Wetland'] = wld['MEAN']
wta_all['Cover Crops'] = cc['MEAN']
wta_all['Nutrient Management'] = nm['MEAN']

wta_all['Cluster'] = ['cluster' + str(i) for i in fa['Cluster']]
#wta_all.to_csv("C:/Users/langzx/Desktop/github/DCM/output/wta_means_04122020.csv",index=False)



wta_ori = pd.read_csv(data_folder/"wta_all_mean.csv")

wta_ori = wta_ori.assign(Cluster=wta_all['Cluster'], id = fa['id'] )

sns.boxplot(x="Cluster", y="Wetland",
                 data=wta_all, palette="Set3")
plt.show()


wta_melt = pd.melt(
  					wta_all.reset_index(), 
                        
                    id_vars=['id','Cluster'],

                    value_vars=['Wetland', 'Cover Crops','Nutrient Management'], 
                        
                    var_name='Practices', value_name ='WTA'
					)


g = sns.catplot(x='Practices',
y="WTA",
hue='Cluster',
data = wta_melt ,
kind = "box")
plt.show()

wta_ori_melt = pd.melt(
  					wta_ori.reset_index(), 
                        
                    id_vars=['id', 'Cluster'],

                    value_vars=['Wetland', 'Cover Crops','Nutrient Management'], 
                        
                    var_name='Practices', value_name ='WTA'
					)

sns.catplot(x='Practices',
y="WTA",
hue='Cluster',
data = wta_ori_melt ,
kind = "box")
plt.show()

test_list = ['wta_fa','wta_orig']
res = list(itertools.chain.from_iterable(itertools.repeat(i, 441) 
                                           for i in test_list)) 
wta_all.shape

df_fa = wta_all[['Wetland', 'Cover Crops', 'Nutrient Management']] 
df_ori = wta_ori[['Wetland', 'Cover Crops', 'Nutrient Management']] 


df_compare = pd.concat([df_fa,df_ori])

df_compare['EST'] = res 

compare_melt = pd.melt(
  					df_compare.reset_index(), 
                        
                    id_vars=['EST'],

                    value_vars=['Wetland', 'Cover Crops','Nutrient Management'], 
                        
                    var_name='Practices', value_name ='WTA'
					)


sns.catplot(x='Practices',
y="WTA",
hue='EST',
data = compare_melt,
kind = "box",palette="Blues")
plt.show()

cluster_avg = wta_all.groupby(['Cluster']).mean() 


wta_all['Wetland'].mean()
wta_all['Cover Crops'].mean()
wta_all['Nutrient Management'].mean()

wta_melt = pd.melt(wta_all, id_vars= 'id', value_vars=['Wetland', 'Cover Crops','Nutrient Management'])
wta_melt.columns
#wta_melt.to_csv("C:/Users/langzx/Desktop/github/DCM/output/wta_pivot04122020.csv",index=False)	

conservation = ['Wetland', 'Cover Crops','Nutrient Management']
# Iterate through the five airlines


sns.distplot(data=wta_melt , y="value",
x="id",
hue="variable")

sns.distplot(wld['MEAN'], hist = False, kde = True,
                 kde_kws = {'linewidth': 3},
                 label = "wetland")




plt.xlabel('WTA')

for i in conservation:
    # Subset to the airline
    subset = wta_melt[wta_melt['variable'] == i]
    sns.distplot(subset['value'], hist = False, kde = True,
                 kde_kws = {'linewidth': 3},
                 label = i)

plt.legend(loc= 1, fontsize = 5, title = 'Conservation actions')
plt.title('Distributions of willingess-to-accept')
plt.xlabel('Payment($/acre)')
plt.ylabel('Probability density')
plt.savefig("wta.png", dpi = 800)
plt.show()