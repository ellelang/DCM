
 
class bioMatrix(object):
     
     def __init__(self, dim, names, values):
         
         self.dim = dim
         self.names = names
         j = 0 
         self.keys = {}
         for i in names:
             self.keys[i] = j
             j += 1 
         # initialize matrix and fill with zeroes
         self.matrix = []
         for i in names:
             ea_row = []
             for j in range(dim):
                 ea_row.append(values[self.keys[i]][j])
             self.matrix.append(ea_row)
  
     
     def setvalue(self, rowname, colname, v):
         self.matrix[self.keys[colname]][self.keys[rowname]] = v
         self.matrix[self.keys[rowname]][self.keys[colname]] = v
  
     
     def getvalue(self, rowname, colname):
         return self.matrix[self.keys[colname]][self.keys[rowname]] 
 
     
     def __str__(self):
         outStr = ""
         for k in self.names:
             outStr += '%s: %s\n' % (k,self.matrix[self.keys[k]])
         return outStr