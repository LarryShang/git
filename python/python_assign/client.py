'''
Created on Jul 13, 2014

@author: ShangQihao
'''
'''
Created on Jul 8, 2014


'''
import socket
#import sys

class MyTCPHandler():
    
    def __init__(self):
        self.run()
    
    def run(self):
  
        # Connect to server and send data
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect(("localhost", 9999))
        #self.showmenu()   
        while True:         
            self.received = self.sock.recv(1024)
            if len(self.received)==0:break
            print self.received
            s=raw_input()
            if len(s)==0:continue
            self.sock.send(s)
                
        
        self.sock.close()   
    
    
c = MyTCPHandler()    
