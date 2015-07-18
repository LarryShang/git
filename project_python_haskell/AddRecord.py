from SliceEnv import *
from SliceField import *
from SliceDB import *
from SliceRecord import *

def AddRecord():
    env = SliceEnv()
    db_name = input("Input the database's name(For example:CustDB):")
    sliceDB = env.open(db_name)
    sliceRecord = sliceDB.createRecord()
    while 1:
        field = input('Input the field name(For example:cust),Press Enter to quit input: ')
        if field:
            value = input("Input the value: ")
            sliceRecord.setString(field,value)
        else:
            break
    sliceDB.set(sliceRecord)
    env.close(db_name)
    print('Add OK')
    