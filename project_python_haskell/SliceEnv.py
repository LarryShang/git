from SliceField import *
from SliceDB import *
SLICEDBS={}
class SliceEnv():
    def createDB(self,db_name,db_schema,db_index_col):
        slicedb = SliceDB(db_name,db_schema,db_index_col)
        global SLICEDBS
        SLICEDBS[db_name] = slicedb
        
    def open(self,db_name):
        global SLICEDBS
        #print(SLICEDBS)
        return SLICEDBS[db_name]
    
    def close(self,db_name):
        pass
    
        