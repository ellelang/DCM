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
