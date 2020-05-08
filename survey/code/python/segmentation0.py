from scipy import stats
import pandas as pd
import numpy as np
from numpy import random
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from pathlib import Path
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/survey/data')
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
                        
                        'aware': aware_log,
                        'past': past_log,
                        'app': app_log,
                        'social': social_log,
                        'concern': concern_log,
                        'norm_ctl': norm_log,
                        'wld_unf': wldunfav_log,
                        'nm_unf': nmunfav_log,
                        'fav': comp_log
                        })

dat_log.columns
data_log_sel = dat_log[['concern','past','app','social']]
data_log_sel.shape

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
cluster_labels = cluster_labels
cluster_labels[0]
# Create a DataFrame by adding a new cluster label column
data_k3 = dat.assign(Cluster=cluster_labels)

data_k3.head(5)	
data_k3.columns
# Group the data by cluster
grouped = data_k3.groupby(['Cluster'])
data_k3['Cluster']
# Calculate average RFM values and segment sizes per cluster value
grouped.agg('mean').round(3)

''''''
'aware', 'past',
'app', 'social',
'concern','norm_ctl',
'wld_unf', 'nm_unf', 'fav'

 'concern','social',
 'app', 'past'

''''''
data_normalized['Cluster'] = data_k3['Cluster']
data_normalized['id'] = dat0['id']
datanormalized_melt = pd.melt(
  					data_normalized, 
                        
# Assign CustomerID and Cluster as ID variables
                    id_vars=['id', 'Cluster'],

# Assign RFM values as value variables
                    value_vars=[ 
                                'aware', 'past',
'app', 'social',
'concern','norm_ctl',
'wld_unf', 'nm_unf', 'fav'
                               
                                
                         ], 
                        
# Name the variable and value
                    var_name='Metric', value_name ='Value'
					)

datanormalized_melt.columns

# Add the plot title
plt.title('Snake plot of normalized variables')

# Add the x axis label
plt.xlabel('Metric')

# Add the y axis label
plt.ylabel('Value')

# Plot a line for each value of the cluster variable
g= sns.lineplot(data=datanormalized_melt,
             x='Metric', y='Value', hue='Cluster' )



plt.savefig(data_folder/'snakeplot.png',dpi=300)
plt.show()


data_k3.columns

data_k3.groupby(['Cluster']).count()/data_k3.shape[0]
# [['appreciate','past','social','concern' ]]
cluster_avg = data_k3.groupby(['Cluster']).mean() 
cluster_avg.columns

# Calculate average RFM values for the total customer population
population_avg = dat.mean()
population_avg



# Calculate relative importance of cluster's attribute value compared to population
relative_imp = cluster_avg/population_avg - 1
relative_imp.columns


# Print relative importance scores rounded to 2 decimals
print(relative_imp.round(2))

# Initialize a plot with a figure size of 8 by 2 inches 
plt.figure(figsize=(8, 2))

# Add the plot title
plt.title('Relative importance of attributes')

# Plot the heatmap
sns.heatmap(data=relative_imp, annot=False, fmt ='.2f',cmap='RdYlGn')
plt.show()

data_k3['id'] = dat0['id']
#data_k3.to_csv(data_folder/"fscore_04112020_cluster.csv", index = False)
data_k3.columns
data_k3.to_csv(data_folder/"fscore_0504_9_cluster.csv", index = False)

fig, axes = plt.subplots(4,1)

plt.subplot(4, 1, 1); sns.distplot(dat['aware'])
plt.subplot(4, 1, 1); sns.distplot(dat['past'])
plt.subplot(4, 1, 1); sns.distplot(dat['appreciate'])
plt.subplot(4, 1, 1); sns.distplot(dat['resp'])

appre_data,fitted_lambda = stats.boxcox(dat['appreciate'])
data_k3.shape
###############
demo = pd.read_csv(data_folder/'demodata.csv')
demo.shape
demo.head(5)

county_all = pd.read_csv(data_folder/'county_region.csv')
county_all.columns
county_all.columns
watershed = pd.read_csv(data_folder/'countywatershed.csv')
water_county = pd.merge (county_all,watershed, how = 'left', on = 'County')
water_county.info()
water_county[water_county['Watershed'].isnull()]

data_k3 = pd.read_csv(data_folder/"fscore_0504_9_cluster.csv")
merged = pd.merge(demo,data_k3, how='left', on='id')
merged.columns
merged.shape
merge1 = pd.merge(merged,water_county, how='left',left_on='countyresident', right_on='County')
merge1.columns
merge1.shape

merged.to_csv(data_folder/"merged_cluster_0504.csv", index = False)
merged.shape

merged.columns
num_merged = merged.select_dtypes(exclude=['object'])
num_merged.columns
mean_dat = num_merged.groupby(['Cluster']).mean()
std_dat = num_merged.groupby(['Cluster']).std()

mean_dat.to_csv(data_folder/"mean_cluster_0504.csv", index = False)
std_dat.to_csv(data_folder/"std_cluster_0504.csv", index = False)

num_merged.columns
data_demo = num_merged[['gender','age',
                        'education','income',
                        'incomefromfarming','landarea',
                        'majorityland','primaryrotation','Cluster'
                     ]].astype('category')



data_demo.pivot_table(index="Cluster", columns='gender', aggfunc='size', fill_value=0)

pd.crosstab(data_demo['Cluster'],data_demo['gender']).apply(lambda r: round(r/r.sum(),3), axis=1)
pd.crosstab(data_demo['Cluster'],data_demo['age']).apply(lambda r: round(r/r.sum(),3), axis=1)

pd.crosstab(data_demo['Cluster'],data_demo['income']).apply(lambda r: round(r/r.sum(),3), axis=1)
pd.crosstab(data_demo['Cluster'],data_demo['education']).apply(lambda r: round(r/r.sum(),3), axis=1)
pd.crosstab(data_demo['Cluster'],data_demo['incomefromfarming']).apply(lambda r: round(r/r.sum(),3), axis=1)

pd.crosstab(data_demo['Cluster'],data_demo['landarea']).apply(lambda r: round(r/r.sum(),3), axis=1)
pd.crosstab(data_demo['Cluster'],data_demo['majorityland']).apply(lambda r: round(r/r.sum(),3), axis=1)
pd.crosstab(data_demo['Cluster'],data_demo['primaryrotation']).apply(lambda r: round(r/r.sum(),3), axis=1)
rotation = pd.crosstab(data_demo['Cluster'],data_demo['primaryrotation']).apply(lambda r: round(r/r.sum(),3), axis=1)
rotation.to_csv(data_folder/"primaryrotation_compare.csv", index = True)


region_water = pd.read_csv (data_folder/"merged_cluster_0504.csv")
pd.crosstab(merge1 ['Cluster'],merge1['Region_y']).apply(lambda r: round(r/r.sum(),3), axis=1)
pd.crosstab(merge1 ['Cluster'],merge1['Watershed']).apply(lambda r: round(r/r.sum(),3), axis=1)

pd.crosstab(merge1 ['Watershed'],merge1 ['Cluster']).apply(lambda r: round(r/r.sum(),3), axis=1)
pd.crosstab(merge1['Region_y'],merge1 ['Cluster']).apply(lambda r: round(r/r.sum(),3), axis=1)

pp=merge1.groupby(['Region_y']).mean()

p = pd.crosstab(region_water ['Region_y'],region_water ['Watershed']).apply(lambda r: round(r/r.sum(),3), axis=1)
p.to_csv(data_folder/"region_watershedcrosstab.csv", index = True)
pp.to_csv(data_folder/"region_compare.csv", index = True)




data_demo['% of Total'] = (data_demo.C / table.C.sum() * 100).astype(str) + '%'
table['% of B'] = (table.C / table.groupby(level=0).C.transform(sum) * 100).astype(str) + '%'
print table


print df.groupby(['Type','Name'])['Type'].agg({'Frequency':'count'})

pd.crosstab(df['Approved'],df['Gender']).apply(lambda r: r/r.sum(), axis=1)



import math
from scipy.stats import t	
def independent_ttest(data1, data2, alpha):
	# calculate means
	mean1, mean2 = data1.mean(), data2.mean()
	# calculate standard errors
	se1, se2 = data1.std(), data2.std()
	# standard error on the difference between the samples
	sed = math.sqrt(se1**2.0 + se2**2.0)
	# calculate the t statistic
	t_stat = (mean1 - mean2) / sed
	# degrees of freedom
	df = len(data1) + len(data2) - 2
	# calculate the critical value
	cv = t.ppf(1.0 - alpha, df)
	# calculate the p-value
	p = (1.0 - t.cdf(abs(t_stat), df)) * 2.0
	# return everything
	return t_stat, df, cv, p

independent_ttest(Sample_1['primaryrotation'],Sample_2['primaryrotation'], 0.05)
independent_ttest(Sample_0['past'],Sample_2['past'], 0.05)
independent_ttest(Sample_0['social'],Sample_2['social'], 0.05)


impaired = pd.read_csv(data_folder/'impairedwater.csv')
imp_region = pd.merge(impaired, county_all, how = 'left', on = 'County')
imp_region.groupby(['Region_y']).count()

#######region compare


