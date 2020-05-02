from scipy import stats
import pandas as pd
import numpy as np
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



# Add the plot title
plt.title('Snake plot of normalized variables')

# Add the x axis label
plt.xlabel('Metric')

# Add the y axis label
plt.ylabel('Value')

# Plot a line for each value of the cluster variable
g= sns.lineplot(data=datanormalized_melt,
             x='Metric', y='Value', hue='Cluster')

plt.show()

data_k3.columns
cluster_avg = data_k3.groupby(['Cluster'])[['appreciate','past','social','concern' ]].mean() 
cluster_avg.columns
# Calculate average RFM values for the total customer population
population_avg = dat[['appreciate','past','social','concern' ]].mean()

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
data_k3.to_csv(data_folder/"fscore_0418_4_cluster.csv", index = False)
fig, axes = plt.subplots(4,1)

plt.subplot(4, 1, 1); sns.distplot(dat['aware'])
plt.subplot(4, 1, 1); sns.distplot(dat['past'])
plt.subplot(4, 1, 1); sns.distplot(dat['appreciate'])
plt.subplot(4, 1, 1); sns.distplot(dat['resp'])

appre_data,fitted_lambda = stats.boxcox(dat['appreciate'])
