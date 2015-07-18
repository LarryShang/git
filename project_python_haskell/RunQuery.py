from SliceEnv import *
from SliceField import *
from SliceDB import *
from SliceRecord import *

def RunQuery():
    query = input("Input a Query: ")
    select_index = query.find('SELECT')
    from_index = query.find('FROM')
    where_index = query.find('WHERE')
    if select_index==-1 or from_index==-1 or where_index==-1:
        return 'Input Wrong!'
    display_list = query[select_index+6:from_index-1].strip().split(',')
    target_database = query[from_index+5:where_index-1].strip()
    condition = query[where_index+5:]
    less_index = condition.find('(')
    greater_index = condition.find(')')
    if less_index==-1 and greater_index==-1:
        condition_list = [item.strip() for item in condition.strip().split(',')]
    else:
        new_condition = condition[:less_index]+condition[less_index+1:greater_index]+condition[greater_index+1:]
        condition_list = [item.strip() for item in new_condition.strip().split(',')]
    col_name,operator,literal = condition_list[0],condition_list[1],condition_list[2]
    col_list = [item for item in display_list]
    col_list.append(col_name)
    env = SliceEnv()
    sliceDB = env.open(target_database)
    result = sliceDB.run_query(col_list,col_name,operator,literal)
    for item in result:
        item_str = ''
        for each in item:
            item_str += str(each)+'    '
        print(item_str)
    
    
    