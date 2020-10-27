from pathlib import Path
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import altair as alt

cost_mn = pd.read_csv(data_folder/'wtas_countyMN.csv')
cost_others = pd.read_csv(data_folder/'wtas_countyothers.csv')
cost_mn.head(3)
cost_others.head(3)
cost = pd.concat([cost_mn, cost_others], axis = 0)

cost.to_csv(data_folder/'cost_region1027.csv', index = False)
####################

cost = pd.read_csv(data_folder/'cost_region1027.csv')
cost.columns
regionname = cost.Region.unique().tolist()
regionname_sort = ['Northeast',
 'Northwest',
 'Westcentral',
 'Southeast',
 'Southcentral',
 'Southwest',
 'Iowa',
 'South Dakota'
 ]

df1 = cost.melt(id_vars=['County', 'Region' ], 
              value_vars=['WLD', 'CC', 'NM', 'ASC_obs'],
              var_name='Types', value_name='WTAs')

df1.head(4)
df1[df1.Region == 'Southeast']

sns.barplot(df1['County'], df1['WTAs'], hue = df1['Types'])


c = ["blue", "purple", "red", "green"]
for i, g in enumerate(df1.groupby("Types")):
    ax = sns.barplot(data=g[1],
                     x="County",
                     y="WTAs",
                     hue="Regions",
                     color=c[i],
                     zorder=-i, # so first bars stay on top
                     edgecolor="k")
ax.legend_.remove() # remove the redundant legends 












#sns.distplot(df1[['WTAs']], hue = df1[['Types']], hist=False, rug=False)

sns.barplot(df1['County'], df1['WTAs'], hue = df1['Types'], multiple="stack")

alt.renderers.enable('altair_viewer')
# sort = alt.SortField("sort_val", order="descending") )


chart = alt.Chart(df1).transform_calculate(
    key="datum.Types == 'ASC_obs'"
).transform_joinaggregate(
    sort_key="argmax(key)", groupby=['Region']
).transform_calculate(
    sort_val='datum.sort_key.value'  
).mark_bar().encode(
    x= alt.X('County', title = None),
    y= alt.Y('WTAs', title = 'Willingness-to-Accept ($/acre)', axis=alt.Axis(grid=False)),
    color=alt.Color('Types', title = 'Payment Category'),
).facet(
  column=alt.Column(
      'Region:N',
       header=alt.Header(title=None,labelFontSize=13, labelOrient='top'),
       sort = alt.SortField("sort_val", order="descending") )
).resolve_scale(
  x='independent'
).configure_axis(
    grid=False
).configure_view(
    strokeWidth=0,
    strokeOpacity=0,   
    stroke='transparent'
).configure_axis(
    labelFontSize=16,
    titleFontSize=16
 ).configure_legend(
     labelFontSize=14,
    titleFontSize=14
     )       
chart.show()


fg = sns.catplot(x='County',
                 y='WTAs', hue='Types', 
                 col='Region', data=df1, 
                 kind='bar',
                 stacked=True)


import altair
print(altair.__version__)


from altair_saver import save
alt.renderers.enable('altair_saver', fmts=['vega-lite', 'png'])
save(chart, "countyWTAchart.png", scale_factor=3.0) 

chart.save('countyWTAchart.html',  scale_factor=5)


df1.pivot(index = "County", columns = "Types", values = "WTAs").plot.bar(edgecolor = "grey", stacked=True)

df1.pivot(index = "County", columns = "Types", values = "WTAs").plot.bar(edgecolor = "grey", stacked=True)




df1.head(3)

df1.pivot_table(index = ['Region',"County"], columns = "Types", values = "WTAs").plot.bar(edgecolor = "grey", stacked=True)


df_plot = cost.groupby(['Region']).size().reset_index().pivot(columns='Types')


fig, ax = plt.subplots()

g = sns.catplot(
    data=df1, kind="bar",
    x="County", y="WTAs", hue="Types",
    palette="dark", alpha=.6, height=6
)




f, axs = plt.subplots(1,3,figsize=(35,15))

axs[0].bar(cost['County'], cost['WLD'], color = 'b', width = 0.5)
axs[0].tick_params(labelrotation=90)
axs[0].set_title("Wetland")


axs[1].bar(cost['County'], cost['CC'], color = 'b', width = 0.5)
axs[1].tick_params(labelrotation=90)
axs[1].set_title("CoverCrop")


axs[2].bar(cost['County'], cost['NM'], color = 'b', width = 0.5)
axs[2].tick_params(labelrotation=90)
axs[2].set_title("Nutrient Management")



plt.figure(figsize=(30,10))
g_org = sns.FacetGrid(df1, col="WTAs", hue="Types",sharey=False, sharex=False)
g_org = g_org.map(sns.distplot, "WTAs", hist=False, rug= False)

