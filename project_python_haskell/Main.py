from CreateDB import *
from AddRecord import *
from UpdateRecord import *
from Bulkload import *
from DisplayJoin import *
from Report import *
from RunQuery import *
from DeleteRecord import *

def main():
    print('Welcome to this DBMS!')
    while 1:
        print()
        print('What do you want to do?')
        print('1.Create database.     2.Add Record.         3.Update Record.')
        print('4.Delete Record        5.Bulk Load.          6.Display Join.')
        print('7.Run Query.           8.Report1.            9.Report2.     ')
        print('10.Quit.')
        a=input('Please input a number:')
        if a=='1':
            CreateDB()
        elif a=='2':
            AddRecord()
        elif a=='3':
            UpdateRecord()
        elif a=='4':
            DeleteRecord()
        elif a=='5':
            Bulkload()
        elif a=='6':
            DisplayJoin()
        elif a=='7':
            RunQuery()
        elif a=='8':
            Report1()
        elif a=='9':
            Report2()
        elif a=='10':
            print('Thank you! Bye.')
            break
        else:
            print("Input Wrong!")

if __name__=='__main__':
    main()