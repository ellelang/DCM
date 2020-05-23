# -*- coding: utf-8 -*-
from scipy import stats
import pandas as pd
import numpy as np
from numpy import random
import matplotlib.pyplot as plt
import seaborn as sns

b_onlyatt = np.array([-1.8535,-0.482366,	-0.767589, 0.00380919])
v_onlyatt = np.array([0.048336,0.0161633, 0.0167991, 6.56E-08])
v_b = v_onlyatt/b_onlyatt**2
cov_mp = np.array([-2.53E-05, 1.73E-06, 1.02E-05])
var_w = (b_onlyatt[1]/b_onlyatt[3])**2*(v_b[1] + v_b[3] - 2*(cov_mp[1]/(b_onlyatt[1]*b_onlyatt[3])))
std_error = np.sqrt(var_w)
ratio = b_onlyatt[0]/b_onlyatt[3]
wald_stat = ratio/std_error
pvalueWald = 2*stats.norm.cdf(-abs(wald_stat))


b_orig = np.array([-1.8871,-0.493743,-0.785386, 0.00387647])
v_orig = np.array([0.0501028, 0.0156336,0.0170152, 6.69E-08])
cov_orig = np.array([-2.54E-05,1.33E-06,-1.04E-05])
v_b_orig = v_orig/b_orig**2
var_orig = (b_orig[0]/b_orig[3])**2*(v_b_orig[0] + v_b_orig[3] - 2*(cov_orig[0]/(b_orig[0]*b_orig[3])))
std_orig = np.sqrt(var_orig)



b_ba = np.array([-1.8145,-0.449733,-0.705543, 0.00380019])
v_ba = np.array([0.0489621, 0.0150844,0.0162928, 6.86E-08])
cov_ba = np.array([-2.62E-05,1.39E-06,-1.11E-05])
v_b_ba = v_ba/b_ba**2

b_onlyatt[0:3]/b_onlyatt[3]
b_orig[0:3]/b_orig[3]
b_ba[0:3]/b_ba[3]




def ratiovar(b,vb,cov):
    var = (b[2]/b[3])**2*(vb[2]+vb[3] -2*(cov[2]/(b[2]*b[3])) )
    std = np.sqrt(var)
    return std

ratiovar(b_ba, v_b_ba, cov_ba)
