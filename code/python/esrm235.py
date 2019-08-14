from __future__ import print_function
from pathlib import Path
data_folder = Path("C:/Users/langzx/Desktop/github/DCM/data")
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import numpy as np
import pandas as pd

## HW 1
### 3. 1

x = list(range(0,15,1))
B = list(map(lambda i: 60*i - 3*i**2, x))
C = list(map(lambda i: 10*i + 2*i**2, x))
C

plt.plot( x, B, marker='', color='blue', linewidth=4, linestyle = 'solid', label="Benefit")
plt.plot( x, C, marker='', color='red', linewidth=4, linestyle='solid', label="Cost")
plt.xlim(0, 15)
plt.ylim(0, 400)
plt.xlabel('Pollution abatement (thousand tons)')
plt.ylabel('Values (in millions of dollars per year)')
plt.legend()
plt.savefig('3Curve.png',dpi = 300)

#m_x = list(range(0,11,1))
#m_b = list(map(lambda i: 60 - 6*i, m_x))
#m_c = list(map(lambda i: 10 + 4*i, m_x))


m_x = np.arange(0,11,0.01)

def f1(x):
    return 60 - 6*x

def f2(x):
    return 10 + 4*x

y1 = f1(m_x)
y2 = f2(m_x)
y = np.minimum(y1,y2)
plt.plot(x,y1, color = 'blue',linewidth=4, label = "Marginal benefit")
plt.plot(x,y2, color = 'red', linewidth=4, label = "Marginal cost")

plt.fill_between(m_x, y1, y2, where=y1>=y2, color='#539ecd')
plt.fill_between(m_x, y, where=x<=5, color='gold')                     
plt.xlim(0,10)
plt.ylim(0,60) 
plt.xlabel('Pollution abatement (thousand tons)')
plt.ylabel('Values (in millions of dollars per year)')  
plt.legend()    
plt.savefig('35Curve.png',dpi = 300)

# Question 4
##4.1
q = np.arange(0,11,0.01)
p = 5 - 0.5 * q
plt.plot(q,p,color = 'blue',linewidth=4)
plt.xlim(0,10)
plt.ylim(0,5)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)') 
plt.savefig('4Curve.png',dpi = 300)

##4.1.2
def f3(x):
    return 5 - 0.5 *x

def f4(x):
    return 3


y3 = f3(q)
y4 = f4(q)

plt.plot(q,y3,color = 'blue',linewidth=4)
plt.fill_between(q, y3, y4, where=q<=4, color='#539ecd')
plt.fill_between(q, y4, where=q<=4, color='gold')
plt.xlim(0,10)
plt.ylim(0,5)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.savefig('412Curve.png',dpi = 300) 


##4.2

q2 = np.arange(0,21,1)
p2 = 10 - 0.5 * q2 

def f5(x):
    return 10 - 0.5 *x


y5 = f5(q2)

plt.plot(q2,y5,color = 'blue',linewidth=4)
plt.fill_between(q2, y5, y4, where=q2<=14, color='#539ecd')
plt.fill_between(q2, y4, where=q2<=14, color='gold')
plt.xlim(0,25)
plt.ylim(0,10)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.savefig('42Curve.png',dpi = 300) 

## 4.3
q_a = np.arange(0,11,1)
q_ab = np.arange(10,31,1)
p_a = 10 - 0.5 * q_ab
p_b = 5 - 0.5 * q_ab
p_ab = 7.5 - 0.25*q_ab

def fa(x):
    return 10 - 0.5 * x
def fab(x):
    return  7.5 - 0.25*x

ya = fa(q_a)
yab = fab(q_ab)
ya
plt.plot(q_a,ya, color = 'blue',linestyle = '-', linewidth=4, label = "Only A")
plt.plot(q_ab,yab, color = 'blue', linestyle = '--', linewidth=4, label = "Both A and B")
plt.xlim(0,30)
plt.ylim(0,12)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.savefig('43Curve.png',dpi = 300)

##4.4 
q_supply = np.arange(0,31,1)
p_supply =  (4 + q_supply)/4

plt.plot(q_a,ya, color = 'blue',linestyle = '-', linewidth=4, label = "Demand")
plt.plot(q_ab,yab, color = 'blue', linestyle = '--', linewidth=4)
plt.plot(q_supply,p_supply , color = 'red', linestyle = '-', linewidth=4, label = "Supply")
plt.xlim(0,30)
plt.ylim(0,12)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()
plt.savefig('44Curve.png',dpi = 300)

## 4.5

q_supply = np.arange(0,31,1)
p_supply =  (4 + q_supply)/4

plt.plot(q_a,ya, color = 'blue',linestyle = '-', linewidth=4, label = "Demand")
plt.plot(q_ab,yab, color = 'blue', linestyle = '--', linewidth=4)
plt.plot(q_supply,p_supply , color = 'red', linestyle = '-', linewidth=4, label = "Supply")
plt.axvline(x=13,ymin=0, ymax=0.35,linewidth=4, color = 'gold')
plt.hlines(y=4.25,xmin=0, xmax=13,linewidth=4)
plt.xlim(0,30)
plt.ylim(0,12)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()
plt.savefig('45Curve.png',dpi = 300)

## HW2 
### 1.1 

q_21 = np.arange(0,68,1)
p_21demand = 200 - 3*q_21
p_21supply = 20 + 3*q_21
p_21supply_social = 20 + 3*q_21 + 30



plt.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
plt.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
#plt.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
plt.axvline(x=30, ymin=0, ymax=0.55,linewidth=4, linestyle = '--', color = 'black')
plt.hlines(y=110,xmin=0, xmax=30,linewidth=4,linestyle = '--',color = 'black')
plt.xlim(0,70)
plt.ylim(0,200)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()
plt.savefig('1aCurve.png',dpi = 300)
plt.show()

plt.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
plt.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
plt.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
#plt.axvline(x=30, ymin=0, ymax=0.55,linewidth=4, linestyle = '--', color = 'black')
#plt.hlines(y=110,xmin=0, xmax=30,linewidth=4,linestyle = '--',color = 'black')
plt.axvline(x=25, ymin=0, ymax=0.63,linewidth=4, linestyle = '--',color='#539ecd')
plt.hlines(y=125,xmin=0, xmax=25,linewidth=4,linestyle = '--',color='#539ecd')
plt.xlim(0,70)
plt.ylim(0,200)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()

plt.savefig('1cCurve.png',dpi = 300)
plt.show()

## 1.b

def f21b(x):
    return 110
def f23b(x):
    return 125

y_21 = f21b(q_21)
y_23 = f23b(q_21)
plt.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
plt.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
#plt.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
plt.fill_between(q_21,p_21demand, where=q_21<=30, color='powderblue')

plt.xlim(0,70)
plt.ylim(0,200)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()
plt.show()
plt.savefig('1baCurve.png',dpi = 300)

## Consumer surplus
plt.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
plt.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
#plt.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
plt.fill_between(q_21,p_21demand, y_21, where=y_21<=p_21demand, color='plum')
#plt.axvline(x=30, ymin=0, ymax=0.55,linewidth=4, linestyle = '--', color = 'black')
#plt.hlines(y=110,xmin=0, xmax=30,linewidth=4,linestyle = '--',color = 'black')
plt.xlim(0,70)
plt.ylim(0,200)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()
plt.show()
plt.savefig('1bbCurve.png',dpi = 300)


## producer surplus
plt.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
plt.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
#plt.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
plt.fill_between(q_21,p_21supply, y_21, where=y_21<=p_21demand, color='lightsalmon')
#plt.axvline(x=30, ymin=0, ymax=0.55,linewidth=4, linestyle = '--', color = 'black')
#plt.hlines(y=110,xmin=0, xmax=30,linewidth=4,linestyle = '--',color = 'black')
plt.xlim(0,70)
plt.ylim(0,200)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()
plt.show()
plt.savefig('1bcCurve.png',dpi = 300)

##damage
plt.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
plt.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
plt.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
plt.fill_between(q_21,p_21supply,p_21supply_social, where=q_21<=30, color='sienna')
#plt.axvline(x=30, ymin=0, ymax=0.55,linewidth=4, linestyle = '--', color = 'black')
#plt.hlines(y=110,xmin=0, xmax=30,linewidth=4,linestyle = '--',color = 'black')
plt.xlim(0,70)
plt.ylim(0,200)
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.legend()
plt.show()
plt.savefig('1bdCurve.png',dpi = 300)


import matplotlib.patches as mpatches
labels = ['Total Benefit', 'Consumer Surplus', 'Producer Surplus', 'Externality Demage']

pb_patch = mpatches.Patch(color='powderblue', edgecolor='') #'#000000' this will create a red bar with black borders, you can leave out edgecolor if you do not want the borders
plum_patch = mpatches.Patch(color='plum', edgecolor='')
salmon_patch = mpatches.Patch(color='lightsalmon', edgecolor='')
sienna_patch = mpatches.Patch(color='sienna', edgecolor='')


y_ticks = np.arange(0, 210, 20)
x_ticks = np.arange(0, 75, 5)


fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, sharex=False, sharey=False, figsize=(15, 10))

ax1.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax1.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
#ax1.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax1.fill_between(q_21,p_21demand, where=q_21<=30, color='powderblue')
ax1.axvline(x=30, ymin=0, ymax=0.55,linewidth=2, linestyle = '--', color = 'black')
ax1.hlines(y=110,xmin=0, xmax=30,linewidth=2,linestyle = '--',color = 'black')

ax1.set_xticks(x_ticks)
ax1.set_yticks(y_ticks)
ax1.set_xlim(0,70)
ax1.set_ylim(0,200)
ax1.set_ylabel('P (price)')
ax1.legend()
ax2.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax2.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
ax2.hlines(y=110,xmin=0, xmax=30,linewidth=2,linestyle = '--',color = 'black')

#ax2.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax2.axvline(x=30, ymin=0, ymax=0.55,linewidth=2, linestyle = '--', color = 'black')
ax2.fill_between(q_21,p_21demand, y_21, where=y_21<=p_21demand, color='plum')
ax2.set_xticks(x_ticks)
ax2.set_yticks(y_ticks)
ax2.set_xlim(0,70)
ax2.set_ylim(0,200)

ax3.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax3.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
ax3.axvline(x=30, ymin=0, ymax=0.55,linewidth=2, linestyle = '--', color = 'black')
ax3.hlines(y=110,xmin=0, xmax=30,linewidth=2,linestyle = '--',color = 'black')

#ax3.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax3.fill_between(q_21,p_21supply, y_21, where=y_21<=p_21demand, color='lightsalmon')
ax3.set_xlabel('Q (quanty)')
ax3.set_ylabel('P (price)')
ax3.set_xticks(x_ticks)
ax3.set_yticks(y_ticks)
ax3.set_xlim(0,70)
ax3.set_ylim(0,200)


ax4.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax4.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
ax4.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax4.fill_between(q_21,p_21supply,p_21supply_social, where=q_21<=30, color='sienna')
#ax4.hlines(y=110,xmin=0, xmax=30,linewidth=2,linestyle = '--',color = 'black')
ax4.axvline(x=30, ymin=0, ymax=0.55,linewidth=2, linestyle = '--', color = 'black')
#plt.hlines(y=110,xmin=0, xmax=30,linewidth=4,linestyle = '--',color = 'black')
ax4.set_xticks(x_ticks)
ax4.set_yticks(y_ticks)
ax4.set_xlim(0,70)
ax4.set_ylim(0,200)

ax1.title.set_text('Total Benefit')
ax2.title.set_text('Consumer Surplus')
ax3.title.set_text('Producer Surplus')
ax4.title.set_text('Externality Demage')
ax4.set_xlabel('Q (quanty)')
ax4.legend()
fig.legend(handles=[pb_patch, plum_patch, salmon_patch,sienna_patch ],     # The line objects
           labels=labels,   # The labels for each line
           loc="center right",   # Position of legend
           borderaxespad=0.1,    # Small spacing around legend box
           title=""  # Title for the legend
           )
plt.subplots_adjust(right=0.85)
plt.savefig('1bCurve_whole.png',dpi = 300)
plt.show()

###############################3d

labels2 = ['Total Benefit', 'Consumer Surplus', 'Producer Surplus', 'Externality Demage',  'Tax Revenue']


y_ticks = np.arange(0, 210, 25)
x_ticks = np.arange(0, 75, 5)


fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, sharex=False, sharey=False, figsize=(15, 10))

ax1.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax1.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
ax1.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax1.fill_between(q_21,p_21demand, where=q_21<=25, color='powderblue')
ax1.axvline(x=25, ymin=0, ymax=0.64,linewidth=2, linestyle = '--', color='#539ecd')
ax1.axhline(y=125, xmin=0, xmax=0.35,linewidth=2, linestyle = '--', color='#539ecd')
ax1.set_xticks(x_ticks)
ax1.set_yticks(y_ticks)
ax1.set_xlim(0,70)
ax1.set_ylim(0,200)
ax1.set_ylabel('P (price)')
ax1.legend()
ax2.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax2.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
ax2.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax2.axvline(x=25, ymin=0, ymax=0.64,linewidth=2, linestyle = '--', color='#539ecd')
ax2.axhline(y=125, xmin=0, xmax=0.35,linewidth=2, linestyle = '--', color='#539ecd')
ax2.fill_between(q_21,p_21demand, y_23, where=y_23<=p_21demand, color='plum')
ax2.set_xlim(0,70)
ax2.set_ylim(0,200)
ax2.set_xticks(x_ticks)
ax2.set_yticks(y_ticks)

ax3.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax3.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
ax3.axvline(x=25, ymin=0, ymax=0.64,linewidth=2, linestyle = '--', color='#539ecd')
ax3.axhline(y=125, xmin=0, xmax=0.35,linewidth=2, linestyle = '--', color='#539ecd')
ax3.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax3.fill_between(q_21,p_21supply_social, y_23, where=y_23<=p_21demand, color='lightsalmon')
ax3.set_xlabel('Q (quanty)')
ax3.set_ylabel('P (price)')
ax3.set_xlim(0,70)
ax3.set_ylim(0,200)
ax3.set_xticks(x_ticks)
ax3.set_yticks(y_ticks)

ax4.plot(q_21,p_21demand, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
ax4.plot(q_21,p_21supply, color = 'red',linestyle = '-', linewidth=4, label = "MPC")
ax4.plot(q_21,p_21supply_social, color = 'gold',linestyle = '-', linewidth=4, label = "MSC")
ax4.fill_between(q_21,p_21supply,p_21supply_social, where=q_21<=25, color='sienna')
ax4.axvline(x=25, ymin=0, ymax=0.64,linewidth=2, linestyle = '--', color='#539ecd')
#ax4.axhline(y=125, xmin=0, xmax=0.35,linewidth=2, linestyle = '--', color='#539ecd')
ax4.set_xlim(0,70)
ax4.set_ylim(0,200)
ax4.set_xticks(x_ticks)
ax4.set_yticks(y_ticks)
#plt.hlines(y=110,xmin=0, xmax=30,linewidth=4,linestyle = '--',color = 'black')
ax1.title.set_text('Total Benefit')
ax2.title.set_text('Consumer Surplus')
ax3.title.set_text('Producer Surplus')
ax4.title.set_text('Externality Demage, Tax Revenue')
ax4.set_xlabel('Q (quanty)')


fig.legend(handles=[pb_patch, plum_patch, salmon_patch,sienna_patch,sienna_patch ],     # The line objects
           labels=labels2,   # The labels for each line
           loc="center right",   # Position of legend
           borderaxespad=0.1,    # Small spacing around legend box
           title=""  # Title for the legend
           )
plt.subplots_adjust(right=0.85)
plt.savefig('1dCurve_whole.png',dpi = 300)


## Q2
q_22a = np.arange(0,900,1)
p_22a_b = -0.4 * q_22a + 360
p_22a_c = 0.2 * q_22a + 90

plt.plot(q_22a,p_22a_b, color = 'blue',linestyle = '-', linewidth=4, label = "MB")
plt.plot(q_22a,p_22a_c, color = 'red',linestyle = '-', linewidth=4, label = "MC")
plt.xlim(0,900)
plt.ylim(0,400)
plt.axvline(x=450, ymin=0, ymax=0.44,linewidth=4, linestyle = '--', color='#539ecd')
plt.axhline(y=180, xmin=0, xmax=0.5,linewidth=4, linestyle = '--', color='#539ecd')
plt.legend()
plt.xlabel('Q (quanty)')
plt.ylabel('P (price)')
plt.savefig('22bCurve.png',dpi = 300)



##HW3

q_31a  = np.arange(0,21,1)

pi_allow = 10 * q_31a - 0.5 *q_31a**2
pi_solow = 20 * q_31a - q_31a**2

plt.plot(q_31a, pi_allow, color = 'blue',linestyle = '-', linewidth=4, label = "Arrow")
plt.plot(q_31a ,pi_solow, color = 'red',linestyle = '-', linewidth=4, label = "Solow")

plt.xlim(0,20)
plt.ylim(0,110)
plt.legend()
plt.xlabel('Pollution')
plt.ylabel('Profits')
plt.savefig('32aCurve.png',dpi = 300)

plt.plot(q_22a,p_22a_b, color = 'c',linestyle = '-', linewidth=4, label = "MB")
plt.axhline(y=180, color = 'm',linewidth=4, linestyle = '-',label = "MD (constant)")
plt.xticks([])
plt.yticks([])
plt.xlim(0,900)
plt.ylim(0,400)
plt.legend()
plt.xlabel('Pollution')
plt.ylabel('Profits')
plt.savefig('32iCurve.png',dpi = 300)



################Midterm 

q_mid8  = np.arange(0,11,1)
B_mid8 = 20 * q_mid8 - q_mid8 **2
C_mid8 = q_mid8 **2
x_ticks = np.arange(0, 11, 1)
plt.xlim(0,11)
plt.ylim(0,110)
plt.plot(q_mid8, B_mid8, color = 'blue',linestyle = '-', linewidth=4, label = "B(X)")
plt.plot(q_mid8, C_mid8, color = 'red',linestyle = '-', linewidth=4, label = "C(X)")
plt.legend()
plt.savefig('mid8a.png',dpi = 300)



q_mid12  = np.arange(0,11,1)
d_mid12 = 20 - 2*q_mid12
s_mid12 = 0.5*q_mid12
social_mid12 =  0.5*q_mid12 + 5
plt.xlim(0,11)
plt.ylim(0,21)
plt.plot(q_mid12, d_mid12, color = 'blue',linestyle = '-', linewidth=4, label = "Demand")
plt.plot(q_mid12, s_mid12, color = 'red',linestyle = '-', linewidth=4, label = "Supply")
#TWTP:
#plt.fill_between(q_mid12,d_mid12, where=q_mid12<=8, color='#539ecd')
#TCOST:
plt.fill_between(q_mid12,s_mid12, where=q_mid12<=8, color='lightsalmon')              
plt.legend()
plt.savefig('mid12d.png',dpi = 300)


##12.e
plt.xlim(0,11)
plt.ylim(0,21)
plt.plot(q_mid12, d_mid12, color = 'blue',linestyle = '-', linewidth=4, label = "MD")
plt.plot(q_mid12, social_mid12, color = 'orchid',linestyle = '-', linewidth=4, label = "MSC")
plt.plot(q_mid12, s_mid12, color = 'red',linestyle = '-', linewidth= 4, label = "MC")
plt.fill_between(q_mid12,social_mid12,s_mid12, where = q_mid12<=8, color='violet') 
plt.legend()
plt.savefig('mid12e.png',dpi = 300)

##############################Final
##1a


q_final1  = np.arange(0,11,1)
B_final1 = 20 * q_final1 - q_final1 **2
C_final1 = q_final1 **2
d_final1 = 20 - 2*q_final1
s_final1 = 1.2*q_final1

fig, (ax1, ax2) = plt.subplots(1, 2, sharex=False, sharey=False, figsize=(10, 5))

ax1.set_xticks([])
ax1.set_yticks([])
ax1.plot(q_final1, B_final1, color = 'blue',linestyle = '-', linewidth=4, label = "B(X)")
ax1.plot(q_final1, C_final1, color = 'red',linestyle = '-', linewidth=4, label = "C(X)")
ax1.legend()
ax1.grid(False)

ax2.set_xticks([])
ax2.set_yticks([])
ax2.plot(q_final1, d_final1, color = 'blue',linestyle = '-', linewidth=4, label = "MB(X)")
ax2.plot(q_final1, s_final1, color = 'red',linestyle = '-', linewidth=4, label = "MC(X)")
ax2.legend()
ax2.grid(False)


fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(10, 5))
plt.setp(ax, xticks=[],
        yticks=[])
ax[0].set_xlim (0,11)
ax[0].set_ylim (0,111)
ax[0].plot(q_final1, B_final1, color = 'blue',linestyle = '-', linewidth=4, label = "B(X)")
ax[0].plot(q_final1, C_final1, color = 'red',linestyle = '-', linewidth=4, label = "C(X)") #row=0, col=1
ax[0].legend()
ax[1].plot(q_final1, d_final1, color = 'peru',linestyle = '-', linewidth=4, label = "MD(X)") #row=0, col=0
ax[1].plot(q_final1, s_final1, color = 'teal',linestyle = '-', linewidth=4, label = "MC(X)") #row=0, col=1
ax[1].set_xlim (0,11)
ax[1].set_ylim (0,21)
ax[1].legend()

plt.savefig('final1a.png',dpi = 300)


##################Question 5
q_final5  = np.arange(0,26,1)
d_final5 = 25 - q_final5
s_final5 = 1 + 3*q_final5
social_s_final5 = 5 + 3*q_final5

def f_final5a(x):
    return 19
y_19 = f_final5a (q_final5)
plt.xlim(0,26)
plt.ylim(0,30)
plt.xticks(np.arange(0, 26, 1)) 
plt.plot (q_final5, d_final5, color = 'blue',linestyle = '-', linewidth=4, label = "MD(X)")
plt.plot (q_final5, s_final5, color = 'red',linestyle = '-', linewidth=4, label = "MC(X)")
plt.plot (q_final5, social_s_final5, color = 'peru',linestyle = '-', linewidth=4, label = "MSC(X)")
plt.axvline(x=5, ymin=0, ymax=0.68, linewidth=3, linestyle = '--', color='grey')
plt.axvline(x=6, ymin=0, ymax=0.75, linewidth=3, linestyle = '--', color='black')
plt.fill_between(q_final5,d_final5, y_19, where=y_19<=d_final5, color='#539ecd',label = "CS")
plt.fill_between(q_final5,s_final5, y_19, where=q_final5 <= 6, color='plum', label="PS")
plt.legend()
plt.savefig('final5.png',dpi = 300)          


############8 
q_final8  = np.arange(0,21,1)
x_efinal8 = 6 * q_final8
x_rfinal8 = 4 * q_final8
  