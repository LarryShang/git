from SliceEnv import *
from SliceField import *
from SliceDB import *
from SliceRecord import *

def UpdateRecord():
    env = SliceEnv()
    db_name = input("Input the table's name(For example:CustDB): ")
    sliceDB = env.open(db_name)
    sliceRecord = sliceDB.createRecord()
    fields = []
    for item in sliceDB.db_schema:
        fields.append(item.get_field_name())
    for field in fields:
        value = input('Input "'+field+'" value:')
#         print(value)
        if value:
            sliceRecord.setString(field, value)
    sliceDB.set(sliceRecord)
    env.close(db_name)
    print('Update OK')
    
            
    