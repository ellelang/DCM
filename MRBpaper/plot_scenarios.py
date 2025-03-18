#!/usr/bin/env python
# coding: utf-8
from scipy import stats
import pandas as pd
import numpy as np
from numpy import random
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from pathlib import Path
# In[1]:

data_folder = Path('Users/ellelang/Desktop/github/DCM/MRBpaper')


df_results  = pd.read_csv(data_folder/'MRB_20240311.csv')


# In[3]:


df_results['Cost_mm'] = df_results['Cost']/1e6


# In[4]:


df_plot = df_results[['N_reduction_pct','S_reduction_pct', 'Cost_mm',
           '# PND Lake small', '# PND Marsh small',
           '# PND Marsh med', '# PND Marsh large', '# RES Marsh 50 ha',
           '# RES Marsh 250 ha', '# RES Marsh 500 ha'
           ]]


# In[5]:


df_results.query('ID == 20012297')[['# PND Lake small', '# PND Marsh small',
       '# PND Marsh med', '# PND Marsh large', '# RES Marsh 50 ha',
       '# RES Marsh 250 ha', '# RES Marsh 500 ha', '# RAMO area m^2']]


# In[6]:


from matplotlib.colors import LinearSegmentedColormap

# Create a truncated colormap that excludes the lightest blues (white)
blues = plt.get_cmap('Blues')
truncated_blues = LinearSegmentedColormap.from_list('truncated_blues', blues(np.linspace(0.3, 1, 100)))


# In[155]:


import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Enable interactive plotting
plt.ion()

# Create the 3D axes
fig = plt.figure(figsize = (80,10))
ax = fig.add_subplot(111, projection='3d')

# Example: Assuming 'Size_column' for size and 'Color_column' for color in df_plot
# Normalize the size and color if needed to make the plot clearer
marker_size = df_plot['# RES Marsh 500 ha']*30  # Adjust multiplier for visibility
marker_color = df_plot['# RES Marsh 50 ha']

# 3D scatter plot with variable size and color
scatter = ax.scatter3D(xs = df_plot.N_reduction_pct, ys = df_plot.S_reduction_pct, zs = df_plot.Cost_mm,
                       alpha=0.8, s = marker_size,
                       c = marker_color, cmap=truncated_blues
                      )
#c =marker_color, cmap='Blues', ,alpha=0.8
# Set view angle
ax.view_init(elev=10, azim=105)

# Labels
ax.set_xlabel('NO3 Reduction %', labelpad=20)
ax.set_ylabel('Sediment Reduction %', labelpad=20)
ax.set_zlabel('Cost ($Million/Year)', labelpad=20)


# Set axis limits to start from 0
ax.set_xlim(0, df_plot['N_reduction_pct'].max())  # X-axis starting from 0
ax.set_ylim(0, df_plot['S_reduction_pct'].max())  # Y-axis starting from 0
ax.set_zlim(0, 32)  # Z-axis starting from 0

#ax.set_title('3D Pareto Optimal Frontier')
# Add a color bar for reference
colorbar = fig.colorbar(scatter, ax=ax, shrink=0.5, aspect=30,pad=0.001, location= 'left')
colorbar.set_label('Number of the RES Marsh 50 ha')

# Create dummy scatter points to represent different marker sizes in the legend
for size in [1, 3, 2, 4, 5]:  # Define some sample sizes
    ax.scatter([], [], edgecolor='black', facecolor='none', alpha=0.6, s=size*30, label=f'{size}')

# Add the size legend
ax.legend(scatterpoints=1, frameon=True, labelspacing=1, title='Number of the RES Marsh 500 ha',
         bbox_to_anchor=(1.35, 0.76), loc='upper right')

fig.tight_layout()
fig.savefig('3dfrontier.png',dpi=300,bbox_inches='tight', pad_inches=0)
# Show the plot
plt.show()


# In[85]:


df_only50ha = df_plot.loc[(df_plot['# RES Marsh 500 ha']==0) & (df_plot['# RES Marsh 250 ha']==0) ,:]


# In[86]:


df_only50ha


# In[87]:


##Plot

# Example: Assuming 'Size_column' for size and 'Color_column' for color in df_plot
# Normalize the size and color if needed to make the plot clearer
marker_size = df_plot['# RES Marsh 500 ha']*30  # Adjust multiplier for visibility
marker_color = df_plot['# RES Marsh 50 ha']

from matplotlib.gridspec import GridSpec
fig = plt.figure(figsize=(15, 6))
gs = GridSpec(2, 2, width_ratios=[1.5, 1])
plt.subplots_adjust(hspace=0.4, wspace=0.1)
# Create the subplots
ax0 = fig.add_subplot(gs[:, 0])  # First column, spans both rows
ax1 = fig.add_subplot(gs[0, 1])  # Second column, first row
ax2 = fig.add_subplot(gs[1, 1])  # Second column, second row

ax0.scatter(x = df_plot.N_reduction_pct, y = df_plot.S_reduction_pct,
                     s = marker_size, alpha = 0.8,
                     c=marker_color, cmap=truncated_blues)
ax0.set_ylabel('Sediment Reduction %', labelpad=20)
ax0.set_xlabel('NO3 Reduction %', labelpad=20)

ax1.scatter(x = df_only50ha['# RES Marsh 50 ha'], y = df_only50ha.N_reduction_pct,
                     alpha = 0.8)
ax1.set_ylabel('NO3 Reduction %', labelpad=20)
ax1.set_xlabel('Number of RES Marsh 50 ha', labelpad=20)


ax2.scatter(x = df_only50ha['# RES Marsh 50 ha'], y = df_only50ha.S_reduction_pct,
                    alpha = 0.8)
ax2.set_ylabel('Sediment Reduction %', labelpad=20)
ax2.set_xlabel('Number of RES Marsh 50 ha', labelpad=20)


#sns.lineplot(ax = ax0, data = df_plot, x='N_reduction_pct', y='S_reduction_pct',s = marker_size)

# sns.lineplot(ax = ax1, data = df_plot, x='# RES Marsh 50 ha', y='N_reduction_pct',s = marker_size,
#                        c = marker_color, cmap=truncated_blues)

# sns.lineplot(ax = ax1, data = df_plot, x='# RES Marsh 50 ha', y='S_reduction_pct',s = marker_size,
#                        c = marker_color, cmap=truncated_blues)

# Show legend only in ax0 and not in ax1 and ax2
#ax0.legend(title="identifier")
#ax1.legend().set_visible(False)
#ax2.legend().set_visible(False)

# Add titles to each subplot
ax0.set_title("NO3 and Sediment Reduction Synergy", fontsize=16)
ax1.set_title("Bid Request Historical data", fontsize=16)
ax2.set_title("Impression Rate Historical data", fontsize=16)




# 2D scatter plot with variable size and color
# scatter = ax.scatter(x = df_plot.N_reduction_pct, y = df_plot.S_reduction_pct,
#                      s = marker_size,
#                      c=marker_color,  cmap='Blues', alpha=0.8)

# ax.set_xlabel('NO3 Reduction %', labelpad=15)
# ax.set_ylabel('Sediment Reduction %', labelpad=15)
# Show the plot
plt.tight_layout()
plt.show()


# In[ ]:





# In[132]:


fig, axs = plt.subplots(1,3, figsize=(30,4))

axs[0].scatter(x = df_plot.N_reduction_pct, y = df_plot.S_reduction_pct,
                    alpha = 0.8)
axs[0].set_ylabel('Sediment Reduction %', fontsize = 20)
axs[0].set_xlabel('NO3 Reduction %', fontsize = 20)

axs[1].scatter(x = df_only50ha['# RES Marsh 50 ha'], y = df_only50ha.N_reduction_pct,
                     alpha = 0.8, s = 100)
axs[1].set_ylabel('NO3 Reduction %',fontsize = 20)
axs[1].set_xlabel('Number of RES Marsh 50 ha', fontsize = 20)


axs[2].scatter(x = df_only50ha['# RES Marsh 50 ha'], y = df_only50ha.S_reduction_pct,
                    alpha = 0.8, s = 100)
axs[2].set_ylabel('Sediment Reduction %', fontsize = 20)
axs[2].set_xlabel('Number of RES Marsh 50 ha', fontsize = 20)


for ax in axs.flat:
    ax.tick_params(axis='both', which='major', labelsize=20)
    


#sns.lineplot(ax = ax0, data = df_plot, x='N_reduction_pct', y='S_reduction_pct',s = marker_size)

# sns.lineplot(ax = ax1, data = df_plot, x='# RES Marsh 50 ha', y='N_reduction_pct',s = marker_size,
#                        c = marker_color, cmap=truncated_blues)

# sns.lineplot(ax = ax1, data = df_plot, x='# RES Marsh 50 ha', y='S_reduction_pct',s = marker_size,
#                        c = marker_color, cmap=truncated_blues)

# Show legend only in ax0 and not in ax1 and ax2
#ax0.legend(title="identifier")
#ax1.legend().set_visible(False)
#ax2.legend().set_visible(False)

# Add titles to each subplot
axs[0].set_title("NO3 and Sediment Reduction Synergy", fontsize=20)
axs[1].set_title("Number of 50 ha RES for NO3 reductions", fontsize=20)
axs[2].set_title("Number of 50 ha RES for Sediment reductions", fontsize=20)
plt.tight_layout()
fig.savefig('mash50.png',dpi=300)
plt.show()


# In[ ]:




