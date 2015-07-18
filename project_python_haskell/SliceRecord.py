class SliceRecord(dict):
    def __init__(self):
        self = dict()
    def setString(self,field,value):
        self[field] = value
    def setInt(self,field,value):
        self[field] = value
    def setFloat(self,field,value):
        self[field] = value