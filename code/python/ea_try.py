import numpy as np
import pandas as pd
import time

# knapsack with 10 objects A, B, ..., J with weight w_i and value v_i
Ob_name = [chr(x) for x in range(65, 75)]
Ob_w = random.sample(range(1, 20), 10)
Ob_value1 = random.sample(range(1, 50), 10)
Ob_value2 = random.sample(range(1, 50), 10)

a = np.random.randint(2, size=10)


dict_new = {
    'object': Ob_name,
    'weight': Ob_w,
    'value1':Ob_value1,
    'value2':Ob_value2
}

ks = pd.DataFrame(dict_new)
ks
ks["value1"]
ks_limit = 35000
ref_point = [sum(ks["value1"]), sum(ks["value1"])]

ref_point
# under the restriction of the total weight being lower than the capacity.

def Fitness(x): 
    val1 = np.sum(x*ks["value1"])
    val2 = np.sum(x*ks["value2"])
    weight = -1 * np.sum(x * ks['weight'])
    if weight > ks_limit:
        return 0
    
    elif x[1] * x[3] * x[9] == 1:
        
        return [-10,-10, weight]
    else:
        return [val1,val2,weight]
    
def get_fitness(pred): return pred.flatten()

DNA_SIZE = 20             # DNA (real number)
DNA_BOUND = [0,1]       # solution upper and lower bounds
N_GENERATIONS = 200
MUT_STRENGTH = 1
np.random.randn(DNA_SIZE)

pool = np.empty([50, 10])
pool[1]
for i in range (50):
    pool [i] = np.random.randint(2, size=10)
    
pool    
    

def make_kid(parent):
    # no crossover, only mutation
    k = parent + MUT_STRENGTH * np.random.randn(DNA_SIZE)
    k = np.clip(k, *DNA_BOUND)
    return k

def kill_bad(parent, kid):
    global MUT_STRENGTH
    fp = get_fitness(np.sum(Fitness(parent)))[0]
    fk = get_fitness(np.sum(Fitness(kid)))[0]
    #p_target = 1/5
    if fp < fk:     # kid better than parent
        parent = kid
        ps = 1.     # kid win -> ps = 1 (successful offspring)
    else:
        ps = 0.
    # adjust global mutation strength
    #MUT_STRENGTH *= np.exp(1/np.sqrt(DNA_SIZE+1) * (ps - p_target)/(1 - p_target))
    return parent

parent =  np.random.randint(2, size=10) 
parent
Fitness(parent)
np.sum(Fitness(parent))
k = parent * MUT_STRENGTH * np.random.randint(2, size=10)
k

get_fitness(np.sum(Fitness(parent)))[0]

np.sum(Fitness (parent))

kid = make_kid(parent)
py, ky = Fitness(parent), Fitness(kid)       # for later plot
parent = kill_bad(parent, kid)

for i in range(N_GENERATIONS):
    # ES part
    kid = make_kid(parent)
    py, ky = Fitness(parent), Fitness(kid)       # for later plot
    parent = kill_bad(parent, kid)

sum(Fitness(parent))
