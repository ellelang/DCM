from pathlib import Path
data_folder = Path('C:/Users/langzx/Desktop/github/DCM/data')
from urllib.request import urlopen , Request
import requests
from bs4 import BeautifulSoup
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


url = 'https://finbin.umn.edu/CpSummOpts/CpSummIndex'
request = Request(url)
response = urlopen(request)
html = response.read()
soup = BeautifulSoup(html)
soup.prettify()

for link in soup.find_all('a'):
    print(link.get('href'))
    

regioncounty = pd.read_csv (data_folder/'regioncounty.csv')
regioncounty.columns

data = pd.read_csv (data_folder/'wta_observables11192018.csv')
data_region = data[['County_resident']]
data_region = data.County_resident.unique()
len(data_region)
data_region
data_region = pd.DataFrame(data_region)
data_region.to_csv('onlycounty.csv')
data_region.columns = ['County_resident']

data_regionmerge = pd.merge(left = data_region, right = regioncounty, how = 'inner', left_on = 'County_resident', right_on = 'County')
data_regionmerge.columns
data_regionmerge = data_regionmerge.sort_values(by=['Region','County'])
data_regionmerge.to_csv ('survey_region_county.csv', index=False)
