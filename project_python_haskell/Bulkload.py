from SliceEnv import *
from SliceField import *
from SliceDB import *
from SliceRecord import *

def Bulkload():
    env = SliceEnv()
    db_name = input("Input the database's name(For example:CustDB): ")
    sliceDB = env.open(db_name)
    bulkfile = input("Input the bulk file's name(For example:CustDB): ")
    sliceDB.load(bulkfile)