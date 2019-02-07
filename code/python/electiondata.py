from pathlib import Path
data_folder = Path("C:/Users/langzx/Desktop/github/DCM/data")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
df08 = pd.read_excel(open(data_folder/'eleall.xlsx','rb'), sheetname='08')
df10 = pd.read_excel(open(data_folder/'eleall.xlsx','rb'), sheetname='10')
df12 = pd.read_excel(open(data_folder/'eleall.xlsx','rb'), sheetname='12')
df14 = pd.read_excel(open(data_folder/'eleall.xlsx','rb'), sheetname='14')
df16 = pd.read_excel(open(data_folder/'eleall.xlsx','rb'), sheetname='16')
df18 = pd.read_excel(open(data_folder/'eleall.xlsx','rb'), sheetname='18')

dfall = pd.concat([df08, df10,df12, df14,df16, df18], axis=1)
dfall
dfall.drop(["County"], axis = 1, inplace = True) 

#colnames = df08.columns.tolist()
#
#coln = len(colnames)
#for i in range(coln):
#    print (colnames[i])
#colnames[0][-3:]
#colnames[1:]
#df08[[colnames[1],colnames[2]]].iloc[0].sum()
#df08[colnames[1:]].iloc[0].sum()
#
#demo = [colnames[1]]
#demo.append(colnames[2])
#demo


def dflvote (data):
    demo = []
    colname = data.columns.tolist()
    coln = len(colname)
    for i in range (coln):
        if colname[i][-3:] == "dfl":
            demo.append(colname[i])
    demovote = data[demo].sum(axis=1)
    sumvote = data[colname[1:]].sum(axis=1)
    demoshare = demovote / sumvote
    return demoshare
county = df08['County']
county
dfall['County'] = county
dfl08 = dflvote(df08)
dfl10 = dflvote(df10)
dfl12 = dflvote(df12)
dfl14 = dflvote(df14)
dfl16 = dflvote(df16)
dfl18 = dflvote(df18)
dflall = dflvote(dfall)


dfldata = {
     'County': county,
     'dfl08': dfl08, 
     'dfl10': dfl10,
     'dfl12': dfl12, 
     'dfl14': dfl14,
     'dfl16': dfl16, 
     'dfl18': dfl18,
     'dfl08to18': dflall
     }

dfdfl =pd.DataFrame(data=dfldata)
dfdfl

dfdfl['dflmean'] = dfdfl.iloc[:, :-1].mean(axis=1)

dfdfl['dflmean']
dfdfl.to_csv("C:/Users/langzx/Desktop/github/DCM/output/electionshare.csv",index=False)
#############

DFL = pd.read_csv("C:/Users/langzx/Desktop/github/DCM/output/electionshare.csv")

obsdata = pd.read_csv(data_folder/"wta_observablest1119wta0206.csv")
        
OB = pd.merge(obsdata, DFL, how = 'left', left_on = 'County', right_on = 'County' )   

OB.to_csv("C:/Users/langzx/Desktop/github/DCM/output/wta_observablest1119wta0206elec.csv",index=False)
