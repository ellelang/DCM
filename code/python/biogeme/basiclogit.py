
from pathlib import Path
import numpy as np
import pandas as pd
pd.set_option('display.max_columns', None)

mdata_folder = Path("C:/Users/langzx/Desktop/github/DCM/data")
import biogeme.database as db
import biogeme.biogeme as bio

pandas = pd.read_table(mdata_folder/"widedata.dat")
pandas = pandas.fillna(-2)
database = db.Database("widedata",pandas)
database 
database.data.describe()
pandas.columns.values


from headers import *


# Removing some observations can be done directly using pandas.
remove = (database.data.Choice == -2)
database.data.drop(database.data[remove].index,inplace=True)

### Coefficients
ASC_V = Beta('ASC_V',0.0,-1000,1000,0)
ASC_C = Beta('ASC_C',0.0,-1000,1000,0)
coef_wetland = Beta('coef_wetland',0.0,-1000,1000,0)
coef_cc = Beta('coef_cc',0.0,-1000,1000,0)
coef_nm = Beta('coef_nm ',0.0,-1000,1000,0)
coef_pay = Beta('coef_pay',0.0,-1000,1000,0)



### Variables
# wetland_vol = DefineVariable('wetland_vol', Wetland_V)
# wetland_current = DefineVariable('wetland_current', Wetland_C)
# covercrop_vol = DefineVariable('covercrop_vol', Covercrop_V)
# covercrop_current = DefineVariable('covercrop_current', Covercrop_C)
# nm_vol = DefineVariable('nm_vol', NuMgt_V)
# nm_current = DefineVariable('nm_current', NuMgt_C)
# pay_vol = DefineVariable('pay_vol', Payment_V)
# pay_current = DefineVariable('pay_current', Payment_C)

##utility models

V1 = ASC_V + \
coef_wetland * Wetland_1 + \
coef_cc * Covercrop_1 + \
coef_nm * NuMgt_1 + \
coef_pay * Payment_1

V2 = ASC_C + \
coef_wetland * Wetland_2 + \
coef_cc * Covercrop_2 + \
coef_nm * NuMgt_2 + \
coef_pay * Payment_2


V = {1: V1,
     2: V2}

av = {1: 1,
      2: 1}

logprob = bioLogLogit(V,av,Choice)
biogeme  = bio.BIOGEME(database,logprob)

biogeme.modelName = "basiclogit"
results = biogeme.estimate()
# Print the estimated values
betas = results.getBetaValues()
betas

for k,v in betas.items():
    print(f"{k}=\t{v:.3g}")

# Get the results in a pandas table
pandasResults = results.getEstimatedParameters()
print(pandasResults)
pandasResults.columns.values

0.43/0.00129
