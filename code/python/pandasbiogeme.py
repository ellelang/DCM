import pandas as pd
import biogeme.database as db
import biogeme.biogeme as bio
from headers import *
pandas = pd. read_table ( " swissmetro . dat " )
database = db. Database ( " swissmetro " , pandas )
