from pathlib import Path
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

countydata_survey = pd.read_csv(data_folder/'county_fromsurvey.csv')
crp = pd.read_csv(data_folder/'CountyCRP2018.csv')
county_melt = pd.merge(left = countydata_survey, right = crp, \
                       left_on = 'County_resident', right_on = 'County',
                       how = 'left')
county_melt.to_csv(data_folder/'county_crpsurvey.csv', index = False)
county_unique = county_melt.drop_duplicates()
county_unique.columns
county_unique.shape
county_area = pd.read_csv(data_folder/'county_area_est.csv')
county_income = pd.read_csv(data_folder/'county_income_est.csv')
county_areaincome = pd.merge(left = county_area, right = county_income, \
                       on = 'County_resident')
county_areaincome.head()
county_areaincome.to_csv(data_folder/'county_areaincome_est.csv', index = False)

county_all = pd.merge(left = county_unique, right = county_areaincome, \
                      on = 'County_resident')

county_unique.to_csv(data_folder/'county_unique.csv', index = False)
county_unique['County_resident']

county_all.to_csv(data_folder/'county_all0426.csv', index = False)
county_all.shape
