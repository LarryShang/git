from SliceEnv import *
from SliceField import *
from SliceDB import *
from SliceRecord import *

def DeleteRecord():
    env = SliceEnv()
    db_name = input("Input the table's name(For example:CustDB): ")
    sliceDB = env.open(db_name)
    index_col = sliceDB.db_index_col
    key_value = input("The key of the table "+db_name+" is "+index_col+", input the key value: ")
    value_list = sliceDB.delete(key_value)
    print(value_list)
    env.close(db_name)