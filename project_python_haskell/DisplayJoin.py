from SliceEnv import *
from SliceField import *
from SliceDB import *
from SliceRecord import *

def DisplayJoin():
    env = SliceEnv()
    left_name = input("Input the first database's name(For example:CustDB): ")
    right_name = input("Input the second database's name(For example:SalesDB): ")
    leftDB = env.open(left_name)
    rightDB = env.open(right_name)
    rightDB.join(leftDB)
    env.close(left_name)
    env.close(right_name)
    print('Join OK!')