from SliceEnv import *
from SliceField import *
from SliceDB import *

type_dic = {'INT':SliceDB.INT,'STRING':SliceDB.STRING,'FLOAT':SliceDB.FLOAT}
def CreateDB():
    db_name = input("Input the table name: ")
    count = int(input("a count of the number of fields:"))
    db_schema = []
    for i in range(count):
        field,field_type = input("the name and type for each column(column_name|COLUMN_TYPE):").split('|')
        db_schema.append((SliceField(field,type_dic[field_type])))
    db_index_col = input("Input an index column name, if an index is required: ")
    env = SliceEnv()
    env.createDB(db_name, db_schema, db_index_col)
    file = open(db_name+'.slc','w')
    file.close()
    print('Create OK!')
    return SLICEDBS

