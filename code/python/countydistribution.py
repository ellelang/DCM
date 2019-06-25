from pathlib import Path
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

region_area = pd.read_csv(data_folder/'region_area_distribution.csv').fillna(0)
region_income = pd.read_csv(data_folder/'region_income_distribution.csv').fillna(0)

region_area.head()
region_area['area1'] = region_area['Less than 100 acres']/region_area['All farms'] 
region_area['area2'] = (region_area['101 to 250 acres'] + region_area['251 to 500 acres'])/region_area['All farms']
region_area['area3'] = region_area['501 to 1000 acres']/region_area['All farms'] 
region_area['area4'] = (region_area['1001 to 1500 acres'] + region_area['1501 to 2000 acres'] + region_area ['2001 to 5000 acres'] + region_area['Above 5000 acres'])/region_area['All farms'] 
region_area['area4']
#region_area['area5'] = region_area['All farms'] - region_area['area1'] - region_area['area2'] - region_area['area3'] - region_area['area4']
#region_area['area5']
region_area[['Region','area1','area2','area3','area4']].to_csv(data_folder/'region_area_est.csv', index=False)

region_income.columns


region_income['income7'] = (region_income['$1,000,001 - $2,000,000'] + region_income['Over $2,000,000'])/region_income['All farms']
region_income['income6'] = region_income['  $500,001 - $1,000,000'] / region_income['All farms']
region_income['income5'] = region_income['  $250,001 - $500,000']/region_income['All farms']
region_income['income4'] = region_income['   $100,001-$250,000'] / region_income['All farms']
region_income['income23'] = region_income['   Less than $100,000']/ region_income['All farms']
region_income['income1'] = 1 - (region_income['income23'] + region_income['income4'] + region_income['income5'] + region_income['income6'] + region_income['income7'] )
region_income['income1']
region_income[['Region','income1','income23','income4','income5','income6','income7']].to_csv(data_folder/'region_income_est.csv', index=False)

##################
county_area = pd.read_csv(data_folder/'county_area_distribution.csv').fillna(0)
county_income = pd.read_csv(data_folder/'county_income_distribution.csv').fillna(0)
county_area.columns
county_area['area1'] = county_area['Less than 100 acres']/county_area['All farms'] 
county_area['area2'] = (county_area['101 to 250 acres'] + county_area['251 to 500 acres'])/county_area['All farms']
county_area['area3'] = county_area['501 to 1000 acres']/county_area['All farms'] 
county_area['area4'] = (county_area['1001 to 1500 acres'] + county_area['1501 to 2000 acres'] + county_area ['2001 to 5000 acres'] + county_area['Above 5000 acres'])/county_area['All farms'] 
county_area['area4']
county_area[['County_resident','Region','area1','area2','area3','area4']].to_csv(data_folder/'county_area_est.csv', index=False)
############
county_income.columns
county_income['income7'] = (county_income['$1,000,001 - $2,000,000'] + county_income['Over $2,000,000'])/county_income['All farms']
county_income['income6'] = county_income['  $500,001 - $1,000,000'] / county_income['All farms']
county_income['income5'] = county_income['  $250,001 - $500,000']/county_income['All farms']
county_income['income4'] = county_income['   $100,001-$250,000'] / county_income['All farms']
county_income['income23'] = county_income['   Less than $100,000']/ county_income['All farms']
county_income['income1'] = 1 - (county_income['income23'] + county_income['income4'] + county_income['income5'] + county_income['income6'] + county_income['income7'] )
county_income['income1']
county_income[['County_resident','Region','income1','income23','income4','income5','income6','income7']].to_csv(data_folder/'county_income_est.csv', index=False)
