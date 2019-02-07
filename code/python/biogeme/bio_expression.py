 #import hashlib #remove if not needed
 #import random #remove if not needed
import string
 
class Operator:
   
    num = 'numeric'
    var = 'variable'
    userexpr = 'UserExpression'
    userdraws = 'UserDraws'
    rv = 'randomVariable'
    param = 'beta'
    mcdraws = 'MCDraw'
    mcunifdraws = 'MCUnifDraw'
    normal = 'N(0,1)'
    uniform = 'U[0,1]'
    uniformSym = 'U[-1,1]'
    absOp, negOp = 'abs','minus'
    exp, log = 'exp','log'
    bioNormalCdf = 'bioNormalCdf'
    add, sub, mul, div, power = '+', '-', '*', '/', '**'
    andOp, orOp, equal, notEqual = 'and','or','==','<>'
    greater, greaterEq, less, lessEq = '>','>=','<','<='
    minOp, maxOp, mod = 'min','max','mod'
    sumOp, prodOp, integralOp, derivativeOp = 'sum', 'prod','integral','derivative'
    monteCarloOp = 'MonteCarlo'
    monteCarloCVOp = 'MonteCarloControlVariate'
    elemOp, enumOp, logitOp, loglogitOp, multSumOp, multProdOp, bioNormalPdf = 'elem', 'enumerate','logit','loglogit','multSum','multProd','bioNormalPdf'
    mhOp = 'MH'
    bayesMeanOp = 'bioBayesNormalDraw'
    defineOp = 'define'
 
    # Bounds
    MIN_ZEROOP_INDEX     =  0
    MAX_ZEROOP_INDEX     = 19
    MIN_UNOP_INDEX       = 20
    MAX_UNOP_INDEX       = 39
    MIN_BINOP_INDEX      = 40    
    MAX_BINOP_INDEX      = 69
    MIN_ITERATOROP_INDEX = 70
    MAX_ITERATOROP_INDEX = 89
 
    UNDEF_OP = -1
 
    # Each operator is associated with an index depending on
    # the above bounds
    operatorIndexDic = {num:0, \
                     var:1, \
                     param:2, \
                     normal:3, \
                     uniform:4, \
                     rv:5, \
                     uniformSym:6, \
                     userexpr:7, \
                     mcdraws:8, \
                     mcunifdraws:9, \
                     userdraws:10, \
                     absOp:20, negOp:21, \
                     exp:30, log:31, bioNormalCdf: 33, monteCarloOp: 34,\
                     add:40, sub:41, mul:42, div:43, power:44, \
                     andOp:45, orOp:46, equal:47, notEqual:48, \
                     greater:49, greaterEq:50, less:51, lessEq:52, \
                     minOp:53, maxOp:54, mod:55, \
                     sumOp:70, prodOp:71,  \
                     elemOp:90, enumOp:91,  integralOp:92, derivativeOp:93, \
                     defineOp:94, logitOp:95, bioNormalPdf:96, multSumOp:97, multProdOp:98, mhOp:99, bayesMeanOp:100,monteCarloCVOp: 101,loglogitOp:102     }
     
    # Return the index associated to an operator
    def getOpIndex(self,op):
       return Operator.operatorIndexDic[op];
 
 
Operator = Operator()
 
 
 
def buildExpressionObj(exp):
    
    def isNumeric(obj):
       # Consider only ints and floats numeric
       return isinstance(obj,int) or isinstance(obj,float)
 
    if isNumeric(exp) :
       return Numeric(exp)
    else :
       return exp
 
 
class Expression:
    
    def __init__(self):
       self.operatorIndex = UNDEF_OP
 
    
    
    def getExpression(self):
       raise NotImplementedError("getExpression must be implemented! ")
 
    
    def getID(self):
       return str(self.operatorIndex) + "-no ID"
 
    
    def __str__(self):
       return self.getExpression()
 
    
    
    def __neg__(self):
       return UnOp(Operator.negOp, self)
 
    
    def __add__(self, expression):
       return BinOp(Operator.add, self, buildExpressionObj(expression))
 
    
    def __radd__(self, expression):
       return BinOp(Operator.add, buildExpressionObj(expression), self)
 
    
    def __sub__(self, expression):
       return BinOp(Operator.sub, self, buildExpressionObj(expression))
 
    
    def __rsub__(self, expression):
       return BinOp(Operator.sub, buildExpressionObj(expression), self)
 
    
    def __mul__(self, expression):
       return BinOp(Operator.mul, self, buildExpressionObj(expression))
       
    
    def __rmul__(self, expression):
       return BinOp(Operator.mul, buildExpressionObj(expression), self)
 
    
    def __div__(self, expression):
       return BinOp(Operator.div, self, buildExpressionObj(expression))
 
    
    def __rdiv__(self, expression):
       return BinOp(Operator.div, buildExpressionObj(expression), self)
 
    
    def __truediv__(self, expression):
       return BinOp(Operator.div, self, buildExpressionObj(expression))
 
    
    def __rtruediv__(self, expression):
       return BinOp(Operator.div, buildExpressionObj(expression), self)
 
    
    def __mod__(self, expression):
       return BinOp(Operator.modOp, self, buildExpressionObj(expression))
 
    
    def __pow__(self, expression):
       return BinOp(Operator.power, self, buildExpressionObj(expression))
 
    
    def __rpow__(self, expression):
       return BinOp(Operator.power, buildExpressionObj(expression), self)
 
    
    def __and__(self, expression):
       return BinOp(Operator.andOp, self, buildExpressionObj(expression))
 
    
    def __or__(self, expression):
       return BinOp(Operator.orOp, self, buildExpressionObj(expression))
 
    
    def __eq__(self, expression):
       return BinOp(Operator.equal, self, buildExpressionObj(expression))
       
    
    def __ne__(self, expression):
       return BinOp(Operator.notEqual, self, buildExpressionObj(expression))
 
    
    def __le__(self, expression):
       return BinOp(Operator.lessEq, self, buildExpressionObj(expression))
 
    
    def __ge__(self, expression):
       return BinOp(Operator.greaterEq, self, buildExpressionObj(expression))
 
    
    def __lt__(self, expression):
       return BinOp(Operator.less, self, buildExpressionObj(expression))
 
    
    def __gt__(self, expression):
       return BinOp(Operator.greater, self, buildExpressionObj(expression))
 
 
 
class Numeric(Expression):
    
    def __init__(self,number):
       self.number = number
       self.operatorIndex = Operator.operatorIndexDic[Operator.num]
 
    def getExpression(self):
       return "(" + str(self.number) + ")"
 
    def getID(self):
       return str(self.operatorIndex)+"-"+str(self.number)
 
 
class Variable(Expression):
    
    def __init__(self,name):
       self.name = name
       self.operatorIndex = Operator.operatorIndexDic[Operator.var]
 
    def getExpression(self):
       return str(self.name)
 
    def getID(self):
       return str(self.operatorIndex)+"-"+str(self.name)
 
 
class RandomVariable(Expression):
    
    def __init__(self,name):
       self.name = name
       self.operatorIndex = Operator.operatorIndexDic[Operator.rv]
 
    def getExpression(self):
       return str(self.name)
 
 
class DefineVariable(Expression):
    
    def __init__(self,name,expression):
       self.name = name
       self.expression = buildExpressionObj(expression)
       self.operatorIndex = Operator.operatorIndexDic[Operator.userexpr]
 
    def getExpression(self):
       return self.name + self.expression.getExpression()
 
 
class DefineDraws(Expression):
    
    def __init__(self,name,expression, iteratorName):
       self.name = name
       self.expression = buildExpressionObj(expression)
       self.iteratorName = iteratorName 
       self.operatorIndex = Operator.operatorIndexDic[Operator.userdraws]
 
    def getExpression(self):
       return self.name + self.expression.getExpression()
 
    def getID(self):
       return str(self.operatorIndex) + "-" + self.getExpression()
 
    
 
class Beta(Expression):
    
    def __init__(self,name,value,lowerbound,upperbound,status,desc=''):
       self.name = name
       self.val = value
       self.lb = lowerbound
       self.ub = upperbound
       self.st = status
       self.desc = desc
       self.operatorIndex = Operator.operatorIndexDic[Operator.param]
 
    def getExpression(self):
       #return str(self.name)
       return self.name + " " + str(self.val) + " " + str(self.lb) + \
              " " + str(self.ub) + " " + str(self.st) + " " + self.desc
 
    def getID(self):
       return str(self.operatorIndex) + "-" + self.getExpression()
 
 
    
 
 
class bioDraws(Expression):
 
    
    def __init__(self,name):
       print("**** DRAWS", name," ",Operator.mcdraws)
       self.name = name
       self.operatorIndex = Operator.operatorIndexDic[Operator.mcdraws]
 
    def getExpression(self):
       return str(self.name)
 
    def getID(self):
       return str(self.operatorIndex)+"-Draw"+self.getExpression()
 
 
 
 
 
class bioRecycleDraws(Expression):
 
    
    def __init__(self,name):
       print("**** RECYCLED DRAWS", name," ",Operator.mcunifdraws)
       self.name = name
       self.operatorIndex = Operator.operatorIndexDic[Operator.mcunifdraws]
       print("Id: ", self.getID())
 
    def getExpression(self):
       return "Unif("+str(self.name)+")"
 
    def getID(self):
       return str(self.operatorIndex)+"-Unif"+self.getExpression()
 
 
 
class bioNormalDraws(Expression):
 
    
    def __init__(self,name,index='__rowId__'):
       msg = 'Deprecated syntax: bioNormalDraws(\''+name+'\'). Use bioDraws(\''+name+'\') and BIOGEME_OBJECT.DRAWS = { \''+name+'\': \'NORMAL\' }'
 
       raise SyntaxError(msg) 
 
 
 
class bioUniformSymmetricDraws(Expression):
 
    
    def __init__(self,name,index='__rowId__'):
       msg = 'Deprecated syntax: bioUniformSymmetricDraws(\''+name+'\'). Use bioDraws(\''+name+'\') and BIOGEME_OBJECT.DRAWS = { \''+name+'\': \'UNIFORMSYM\' }'
 
       raise SyntaxError(msg) 
 
 
 
class bioUniformDraws(Expression):
 
    
    def __init__(self,name,index='__rowId__'):
       msg = 'Deprecated syntax: bioUniformDraws(\''+name+'\'). Use bioDraws(\''+name+'\') and BIOGEME_OBJECT.DRAWS = { \''+name+'\': \'UNIFORM\' }'
 
       raise SyntaxError(msg) 
 
class UnOp(Expression):
    
    def __init__(self,op,expression):
       self.op = op
       self.expression = buildExpressionObj(expression)
       self.operatorIndex = Operator.operatorIndexDic[op]
 
    def getExpression(self):
       return self.op + "(" + self.expression.getExpression() + ")"
 
 
 
 
class abs(Expression):
    
    def __init__(self,expression):
       self.expression = buildExpressionObj(expression)
       self.operatorIndex = Operator.operatorIndexDic[Operator.absOp]
 
    def getExpression(self):
       return Operator.absOp + "(" + self.expression.getExpression() + ")"
 
 
 
class exp(Expression):
    
    def __init__(self,expression):
       self.expression = buildExpressionObj(expression)
       self.operatorIndex = Operator.operatorIndexDic[Operator.exp]
 
    def getExpression(self):
       return Operator.exp + "(" + self.expression.getExpression() + ")"
 
    def getID(self):
       return str(self.operatorIndex) + "-" + self.getExpression()
 
 
 
class log(Expression):
    
    def __init__(self,expression):
       self.expression = buildExpressionObj(expression)
       self.operatorIndex = Operator.operatorIndexDic[Operator.log]
 
    def getExpression(self):
       return Operator.log + "(" + self.expression.getExpression() + ")"
 
    def getID(self):
       return str(self.operatorIndex) + "-" + self.getExpression()
 
 
class bioNormalCdf(Expression):
    
    def __init__(self,expression):
       self.expression = buildExpressionObj(expression)
       self.operatorIndex = Operator.operatorIndexDic[Operator.bioNormalCdf]
 
    def getExpression(self):
       return Operator.normalCdf + "(" + self.expression.getExpression() + ")"
 
 
class max(Expression):
    
    def __init__(self,left,right):
       self.left = buildExpressionObj(left)
       self.right = buildExpressionObj(right)
       self.operatorIndex = Operator.operatorIndexDic[Operator.maxOp]
 
    def getExpression(self):
       return "max(" + self.left.getExpression() + "," + self.right.getExpression() + ")"
 
 
class min(Expression):
    def __init__(self,left,right):
       self.left = buildExpressionObj(left)
       self.right = buildExpressionObj(right)
       self.operatorIndex = Operator.operatorIndexDic[Operator.minOp]
 
    def getExpression(self):
       return "min(" + self.left.getExpression() + "," + self.right.getExpression() + ")"
 
 
class BinOp(Expression):
    
    def __init__(self,op,left,right):
       self.op = op
       self.left = buildExpressionObj(left)
       self.right = buildExpressionObj(right)
       self.operatorIndex = Operator.operatorIndexDic[op]
 
    def getExpression(self):
       return "(" + self.left.getExpression() + self.op + self.right.getExpression() + ")"
 
    def getID(self):
       return str(self.operatorIndex) + "-" + self.getExpression()
 
 
class MonteCarlo(Expression) :
    
    def __init__(self, expression) :
       self.expression = buildExpressionObj(expression)
       self.operatorIndex = Operator.operatorIndexDic[Operator.monteCarloOp]
 
    def getExpression(self) :
       strexpr = "MonteCarlo"
       strexpr += "(" + self.expression.getExpression() + ")"
       return strexpr
 
 
class MonteCarloControlVariate(Expression) :
    
    def __init__(self, expression, integrand,integral) :
       self.expression = buildExpressionObj(expression)
       self.integrand = buildExpressionObj(integrand)
       self.integral = buildExpressionObj(integral)
       self.operatorIndex = Operator.operatorIndexDic[Operator.monteCarloCVOp]
 
    def getExpression(self) :
       strexpr = "MonteCarloControlVariate"
       strexpr += "(" + self.function.getExpression() + ")"
       return strexpr
 
 
class Sum(Expression) :
    
    def __init__(self, term, iteratorName) :
       self.function = buildExpressionObj(term)
       self.iteratorName = iteratorName 
       self.operatorIndex = Operator.operatorIndexDic[Operator.sumOp]
 
    def getExpression(self) :
       strexpr = "sum"
       strexpr += "[" + str(self.iteratorName) + "]"
       strexpr += "(" + self.function.getExpression() + ")"
       return strexpr
 
 
 
 
 
 
class Prod(Expression) :
    
    def __init__(self, term, iteratorName,positive=False) :
       self.function = buildExpressionObj(term)
       self.iteratorName = iteratorName
       self.positive = positive 
       self.operatorIndex = Operator.operatorIndexDic[Operator.prodOp]
 
    def getExpression(self) :
       strexpr = "prod"
       strexpr += "[" + str(self.iteratorName) + "]"
       strexpr += "(" + self.function.getExpression() + ")"
       return strexpr
 
 
class Integrate(Expression):
    
    def __init__(self, term,v):
       self.function = buildExpressionObj(term)
       self.variable = v
       self.operatorIndex = Operator.operatorIndexDic[Operator.integralOp]
 
    def getExpression(self) :
       strexpr = "Integral"
       strexpr += "(" + self.function.getExpression() + "," + variable + ")"
       return strexpr
 
 
class Derive(Expression):
    
    def __init__(self, term,v):
       self.function = buildExpressionObj(term)
       self.variable = v
       self.operatorIndex = Operator.operatorIndexDic[Operator.derivativeOp]
 
    def getExpression(self) :
       strexpr = "Derive"
       strexpr += "(" + self.function.getExpression() + "," + variable + ")"
       return strexpr
                 
 
class bioNormalPdf(Expression):
    
    def __init__(self, term):
       self.function = buildExpressionObj(term)
       self.operatorIndex = Operator.operatorIndexDic[Operator.bioNormalPdf]
 
    def getExpression(self) :
       strexpr = "normalPdf"
       strexpr += "(" + self.function.getExpression() + ")"
       return strexpr
                 
 
class Elem(Expression) :
    
    def __init__(self, dictionary, key, default = Numeric(0)) :
       self.prob = {} # dictionary
       for k,v in dictionary.items() :
          self.prob[k] = buildExpressionObj(v)
          
       self.choice = buildExpressionObj(key)
       self.default = buildExpressionObj(default)
       self.operatorIndex = Operator.operatorIndexDic[Operator.elemOp]
 
    def getExpression(self) :
       res = "Elem"
       res += "[" + str(self.choice) + "]"
       res += "{"
       for i,v in self.prob.items():
          res += "(" + str(i) + ": " + str(v) + ")"
       res += "}"
       return res
 
    def getID(self):
       return str(self.operatorIndex) + "-" + self.getExpression()
 
 
 
class bioLogit(Expression) :
    
    def __init__(self, util, av, choice) :
       self.prob = {} # dictionary
       for k,v in util.items() :
          self.prob[k] = buildExpressionObj(v)
       self.av = {}   
       for k,v in av.items() :
          self.av[k] = buildExpressionObj(v)
       self.choice = buildExpressionObj(choice)
       self.operatorIndex = Operator.operatorIndexDic[Operator.logitOp]
 
    def getExpression(self) :
       res = "Logit"
       res += "[" + str(self.choice) + "]"
       res += "{"
       for i,v in self.prob.items():
          res += "(" + str(i) + ": " + str(v) + ")"
       res += "}"
       res += "{"
       for i,v in self.av.items():
          res += "(" + str(i) + ": " + str(v) + ")"
       res += "}"
       return res
 
 
class bioLogLogit(Expression) :
    
    def __init__(self, util, av, choice) :
       self.prob = {} # dictionary
       for k,v in util.items() :
          self.prob[k] = buildExpressionObj(v)
       self.av = {}   
       for k,v in av.items() :
          self.av[k] = buildExpressionObj(v)
 
       self.choice = buildExpressionObj(choice)
       self.operatorIndex = Operator.operatorIndexDic[Operator.loglogitOp]
       
    def getExpression(self) :
       res = "LogLogit"
       res += "[" + str(self.choice) + "]"
       res += "{"
       for i,v in self.prob.items():
          res += "(" + str(i) + ": " + str(v) + ")"
       res += "}"
       res += "{"
       for i,v in self.av.items():
          res += "(" + str(i) + ": " + str(v) + ")"
       res += "}"
       return res
 
 
 
 
class bioMultSum(Expression) :
    
    def __init__(self, terms) :
       if type(terms).__name__ == 'list':
          self.type = 1
          self.terms = [] ;
          for k in terms :
             self.terms.append(buildExpressionObj(k))
       elif type(terms).__name__ == 'dict':
          self.type = 2
          self.terms = {} ;
          for k,v in terms.items() :
             self.terms[k] = buildExpressionObj(v)
       else:
          self.type = -1
       self.operatorIndex = Operator.operatorIndexDic[Operator.multSumOp]
 
    def getExpression(self) :
       res = "bioMultSum"
       res += "("
       if self.type == 2:
          for i,v in self.terms.items():
             res += v.getExpression() + ","
       
       if self.type ==1:
          for k in self.terms:
             res += k.getExpression() + ","
 
       #remove last coma
       res = res[:-1] + ")"
       return res
 
    def getID(self):
       return str(self.operatorIndex)+"-"+self.getExpression()
 
 
 
 
class Enumerate(Expression) :
   
    def __init__(self, term, iteratorName) :
       self.theDict = {}
       for k,v in term.items():
          self.theDict[k] = buildExpressionObj(v)
       self.iteratorName = iteratorName 
       self.operatorIndex = Operator.operatorIndexDic[Operator.enumOp]
 
    def getExpression(self) :
       strexpr = "Enumerate"
       strexpr += "[" + str(self.iteratorName) + "]"
       strexpr += "{"
       for i,v in self.term.items():
          strexpr += "(" + str(i) + ": " + str(v) + ")"
       strexpr += "}"
       return strexpr
 
 
class bioBayesNormalDraw(Expression):
    def __init__(self, mean, realizations, varcovar):
       self.error = None
       if type(mean).__name__ == 'list':
          self.mean = [] ;
          for k in mean :
             self.mean.append(buildExpressionObj(k))
       else:
          self.error = "Syntax error: the first argument of bioBayesNormalDraw must be a list of expressions. Syntax: [B_TIME, B_COST]. " ;
 
       if type(realizations).__name__ == 'list':
          self.realizations = [] ;
          for k in realizations :
             self.realizations.append(buildExpressionObj(k))
       else:
          self.error = "Syntax error: the second argument of bioBayesNormalDraw must be a list of expressions. Syntax: [B_TIME_RND, B_COST_RND]"
       if type(varcovar).__name__ == 'list':
          self.varcovar = [] ;
          for k in varcovar :
             row = [] 
             if type(k).__name__ == 'list':
                for j in k:
                   row.append(buildExpressionObj(k))
                self.varcovar.append(row)
             else:
                self.error = "Syntax error: the third argument of bioBayesNormalDraw must be a list of list of expressions. Syntax: [[ B_TIME_S , B_COVAR ] , [B_COVAR , B_COST_S]]." ;
                
       
       else:
          self.error = "Syntax error: the third argument of bioBayesNormalDraw must be a list of list of expressions. Syntax: [[ B_TIME_S , B_COVAR ] , [B_COVAR , B_COST_S]]."
       self.varcovar = varcovar
       self.operatorIndex = Operator.operatorIndexDic[Operator.bayesMeanOp]
 
 
class MH(Expression) :
   
 
   
    def __init__(self, beta, density, warmup, steps) :
       if type(beta).__name__ == 'list':
          self.type = 1
          self.beta = [] ;
          for k in beta :
             self.beta.append(buildExpressionObj(k))
       elif type(beta).__name__ == 'dict':
          self.type = 2
          self.beta = {} ;
          for k,v in beta.items() :
             self.beta[k] = buildExpressionObj(v)
       else:
          self.type = -1
       self.density = density
       self.warmup = warmup
       self.steps = steps
       self.operatorIndex = Operator.operatorIndexDic[Operator.mhOp]
 
 
 #class Define(Expression) :
 #   def __init__(self, name, expr, classname=None):
 #      self.name = name
 #      self.expr = expr
 #      self.operatorIndex = Operator.operatorIndexDic[Operator.defineOp]
 #
 #   def getExpression(self):
 #      return str(self.name)
 #      
 #   def assign(self, expr) :
 #      self.expr = expr
 
 