listOfIterator = []
 
 
class iterator:
     # @param iteratorName Name of the iterator.
     # @param name Name of the set of data that is being iterated. It is either the name of a metaiterator, or the string __dataFile__, when the iterator spans the entire database.
     # @param child Name of the child
     # @param variable Variable that contains the ID of the elements being iterated.
     def __init__(self,iteratorName,name,child,variable):
         self.iteratorName = iteratorName
         self.name = name
         self.child = child
         self.variable = variable
         listOfIterator.append(self) ;
 
     def __str__(self):
         return "Iterator " + str(self.name) + " iterates on " + str(self.variable)
 

class drawIterator(iterator):
     
     def __init__(self,iteratorName,name="__dataFile__",child="",variable="__rowId__"):
         msg = 'Deprecated syntax. No need to define a draw iterator anymore. Just remove the statement, and use the operator MonteCarlo instead of Sum.'
         raise SyntaxError(msg) 
 
 
class metaIterator(iterator):
     
     def __init__(self,iteratorName,name,child,variable):
         iterator.__init__(self,iteratorName,name,child,variable)
         self.type = 'META'
 
class rowIterator(iterator):
     
     def __init__(self,iteratorName,name="__dataFile__",child="",variable="__rowId__"):
         iterator.__init__(self,iteratorName,name,child,variable)
         self.type = 'ROW'