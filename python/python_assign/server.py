#! -*- coding:utf-8 -*-
import SocketServer
class MyTCPHandler(SocketServer.BaseRequestHandler):
    """
    The RequestHandler class for our server.

    It is instantiated once per connection to the server, and must
    override the handle() method to implement communication to the
    client.
    """        
    def handle(self):
        # self.request is the TCP socket connected to the client
        self.data = {}
        with open('data.txt','r') as f:
            for line in f.readlines():
                r=map((lambda x: x.strip('\n ')), line.split('|'))
                self.data[r[0]]=r[1:]
        while True:
            self.showmenu()
            self.com = self.request.recv(1024).strip()
            if self.com=='8':
                break
            self.menu(self.com)()
      
    def find_customer(self):
        """
        This used for find customer. if the customer is in the dictionary,
        show the customer information. if not, show error message
        """
        self.request.sendall("Please input a name:")
        self.com = self.request.recv(1024).strip()
        if self.com in self.data == True:
            self.request.sendall(self.data['self.com'])
        else:
            self.request.sendall("customer not found")
        #self.showmenu()
        
    def add_customer(self):
        
        self.request.sendall("Please input a name:")
        self.com = self.request.recv(1024).strip()
        if self.com in self.data == True:
            self.request.sendall("Customer already exists")
        else:
            self.data['self.com'] = self.com
            #use temp variable to store key and then read value from input
            self.temp = self.com
            self.request.sendall("Please input the customer information,devided by |")
            self.com = self.request.recv(1024).strip()
            self.data['self.temp'] = self.com
            del self.temp
            """
            write into the file. 
            """
            f = open('data.txt','w')
            for key,value in self.data:
                f.write("%s|%s\n" %(key,value))
            f.close()
            self.request.sendall("customer has been added")
        
        
    def delete_customer(self):
        self.request.sendall("Please input a name")
        self.com = self.request.recv(1024).strip()
        if self.com in self.data == False:
            self.request.sendall("Customer does not exist")
        else:
            del self.data['self.com']
            self.request.sendall("Delete success!")
            f = open('data.txt','w')
            for key,value in self.data:
                f.write("%s|%s\n" %(key,value))
            f.close()
        
    
    def update_age(self):
        """
        split the item in the dictionary into pieces and modify 
        the specific piece. After this, put them back to the dictionary again
        """
        self.request.sendall("Please input a name")
        self.com = self.request.recv(1024).strip()
        if self.com in self.data == False:
            self.request.sendall("Customer not found")
        else:
            self.request.sendall("Please input the age")
            self.list = self.data['self.com'].split('|')
            self.list[0] = self.request.recv(1024).strip()
            self.data['self.com'] = '|'.join(self.list)
            self.request.sendall("Update success!")
            f = open('data.txt','w')
            for key,value in self.data:
                f.write("%s|%s\n" %(key,value))
            f.close()
        #self.showmenu()

    def update_address(self):
        self.request.sendall("Please input a name")
        self.com = self.request.recv(1024).strip()
        if self.com in self.data == False:
            self.request.sendall("Customer not found")
        else:
            self.request.sendall("Please input the age")
            self.list = self.data['self.com'].split('|')
            self.list[1] = self.request.recv(1024).strip()
            self.data['self.com'] = '|'.join(self.list)
            self.request.sendall("Update success!")
            f = open('data.txt','w')
            for key,value in self.data:
                f.write("%s|%s\n" %(key,value))
            f.close()
        
        
    def update_phone(self):
        self.request.sendall("Please input a name")
        self.com = self.request.recv(1024).strip()
        if self.com in self.data == False:
            self.request.sendall("Customer not found")
        else:
            self.request.sendall("Please input the age")
            self.list = self.data['self.com'].split('|')
            self.list[2] = self.request.recv(1024).strip()
            self.data['self.com'] = '|'.join(self.list)
            self.request.sendall("Update success!")
            f = open('data.txt','w')
            for key,value in self.data:
                f.write("%s|%s\n" %(key,value))
            f.close()
        self.showmenu()
    
    def print_report(self):
        
        self.form = ''
        self.keys = self.data.keys()
        self.keys.sort()
        for key in self.keys:
            self.string = '|'.join(self.data[key])
            self.report = "%s|%s\n" %(key,self.string)
            self.form = self.form + self.report
        self.request.sendall(self.form)
            
    def exit(self):
        self.request.sendall("_exit_")  
    def showmenu(self):
        menu=("Python DB Menu\n"
        "1.  Find customer\n"
        "2.  Add customer\n" 
        "3.  Delete customer\n" 
        "4.  Update customer age\n" 
        "5.  Update customer address\n" 
        "6.  Update customer phone\n"
        "7.  Print report\n"
        "8.  Exit\n"
        "Select:")
        self.request.sendall(menu)
    def menu(self,x):
        menu_dict={
                    '1' : self.find_customer,
                    '2' : self.add_customer,
                    '3' : self.delete_customer,
                    '4' : self.update_age,
                    '5' : self.update_address,
                    '6' : self.update_phone,
                    '7' : self.print_report,
                    '8' : self.exit,
                    }
        return menu_dict[x]
      

if __name__ == "__main__":
    HOST, PORT = "localhost", 9999

    # Create the server, binding to localhost on port 9999
    server = SocketServer.TCPServer((HOST, PORT), MyTCPHandler)

    # Activate the server; this will keep running until you
    # interrupt the program with Ctrl-C
    server.serve_forever()# -*- coding:utf-8 -*-
