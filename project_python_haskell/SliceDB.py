from SliceRecord import *
class SliceDB():
    INT,STRING,FLOAT = 0,1,2
    
    def __init__(self,name='',schema=(),index_col=None):
        self.db_name = name
        self.db_schema = schema
        self.db_index_col = index_col
        self.index_dic = {}
    def createRecord(self):
        record = SliceRecord()
#         print(record)
        for item in self.db_schema:
            record[item.get_field_name()]=''
        #print(record)
        return record
    
    def set(self,record):
        if self.db_index_col:
            if record[self.db_index_col] in self.index_dic:
#                 print('2')
                file = open(self.db_name+'.slc')
                item = file.readlines()
                values_list=[]
                for field in self.db_schema:
                    values_list.append(str(record[field.get_field_name()]))
                    item[self.index_dic[record[self.db_index_col]]]='|'.join(values_list)+'\n'
                    file.close()
                    file = open(self.db_name+'.slc','w')
                    file.writelines(item)
                    file.close()
            else:
#                 print('3')
                values_list=[]
                for field in self.db_schema:
                    values_list.append(str(record[field.get_field_name()]))
                item = '|'.join(values_list)+'\n'
                file = open(self.db_name+'.slc','a+')
                file.write(item)    
                file.close()
                self.index_dic[record[self.db_index_col]]=len(self.index_dic)
        else:
            values_list=[]
            for field in self.db_schema:
                values_list.append(str(record[field.get_field_name()]))
            item = '|'.join(values_list)+'\n'
            file = open(self.db_name+'.slc','a+')
            file.write(item)    
            file.close()
        
    def load(self,filename):
        self.index_dic={}
        reader = open(filename+'.apd')
        writer = open(self.db_name+'.slc','w+')
        items = reader.readlines()
        if self.db_index_col:
            for i in range(len(items)):
                item_list = items[i].split('|')
                self.index_dic[item_list[0]] = i
        reader.close()
        writer.writelines(items)
        writer.close()
        
    def get(self,index_col_value):
        if self.db_index_col:
            file = open(self.db_name+'.slc')
            items = file.readlines()
            value_list = items[self.index_dic[str(index_col_value)]].split('|')
            field_list = []
            file.close()
            for field in self.db_schema:
                field_list.append(field.get_field_name())
            for i in range(len(value_list)):
                print('"'+field_list[i]+'":',value_list[i])
    
    def delete(self,index_col_value):
        if self.db_index_col:
            reader = open(self.db_name+'.slc')
            items = reader.readlines()
            reader.close()
            value_list = items[self.index_dic[str(index_col_value)]].split('|')
            field_list = []
            for field in self.db_schema:
                field_list.append(field.get_field_name())
            this_index = self.index_dic[str(index_col_value)]
            tmp_index_dic = {}
            for key in self.index_dic:
                if int(key) > this_index:
                    tmp_index_dic[key] = self.index_dic[key]-1
                elif int(key)<this_index:
                    tmp_index_dic[key] = self.index_dic[key]
            writer = open(self.db_name+'.slc','w')
            for i in range(len(items)):
                if i!=this_index:
                    writer.write(items[i])
            writer.close()
            return value_list
            
    
    def join(self,sliceDB):
        self.field_list = []
        for field in self.db_schema:
            self.field_list.append(field.get_field_name())
        other_field_list = []
        for field in sliceDB.db_schema:
            other_field_list.append(field.get_field_name())
        flag = False
        for left in range(len(self.field_list)):
            for right in range(len(other_field_list)):
                if self.field_list[left]==other_field_list[right]:
                    flag = True
                    break
            if flag:
                break
        this_file = open(self.db_name+'.slc')
        that_file = open(sliceDB.db_name+'.slc')
        new_file = open(self.db_name+'_join_'+sliceDB.db_name+'.slc','w')
        try:
            this_items = this_file.readlines()
            that_items = that_file.readlines()
            for this_item in this_items:
                this_list = this_item.strip().split('|')
                for that_item in that_items:
                    that_list = that_item.strip().split('|')
                    #print('second:',that_list)
                    if this_list[left] == that_list[right]:
#                         print('first:',this_list)
                        record = [item for item in this_list]
                        
                        record.extend(that_list)
                        record.pop(len(other_field_list)+right+1)
                         
                        record_item = '|'.join(record)+'\n'
                        new_file.write(record_item)
        finally:
            this_file.close()
            that_file.close()
            new_file.close()
            
    def run_query(self,col_list,col_name,operator,literal):
        file = open(self.db_name+'.slc')
        result = []
        index_list = []
        items = file.readlines()
        field_list = []
        for field in self.db_schema:
            field_list.append(field.get_field_name())
        for i in range(len(col_list)):
            index_i = field_list.index(col_list[i])
            if index_i==-1:
                return 'Wrong Col_name'
            index_list.append(index_i)
        for item in items:
            this_list = item.strip().split('|')
            tmp_list = []
            for index_i in index_list:
                tmp_list.append(this_list[index_i])
            if operator=='GT':
                
                if float(tmp_list[-1])>float(literal):
                    result.append(tmp_list[:-1])
#                 else:
#                     if tmp_list[-1]>literal:
#                         result.append(tmp_list[:-1])
            elif operator=='EQ':
                if tmp_list[-1].isdigit():
                    if float(tmp_list[-1])==float(literal):
                        result.append(tmp_list[:-1])
                else:
                    if tmp_list[-1]==literal:
                        result.append(tmp_list[:-1])
            else:
#                 if tmp_list[-1].isdigit():
                if float(tmp_list[-1])<float(literal):
                    result.append(tmp_list[:-1])
                else:
                    if tmp_list[-1]<literal:
                        result.append(tmp_list[:-1])
        return result
