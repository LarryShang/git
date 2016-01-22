class Solution:
	# 1.1
	def uniqueChar(self,str):
		data = {}
		for c in str:
			if c not in data:
				data[c] = True
			else:
				return False
		return True
	
	#1.2
	def reverseStr(self,str):
		return str[::-1]
	
	#1.3
	def isAnagram(self,str1,str2):
		dict1 = {}
		dict2 = {}
		for c in str1:
			dict1[c] = dict1.get(c,0) + 1 #get usage
		for c in str2:
			dict2[c] = dict2.get(c,0) + 1
		if dict1 == dict2:
			return True
		else:
			return False
	
	#1.4
	def  replaceSpace(self,str):
		l = list(str)
		for c in range(len(l)):
			if l[c] == ' ':
				l[c] = '%20'
		return "".join(l)
		
	#1.5
	def compress(self,str):
		dic = {}
		n = []
		for c in str:
			dic[c] = dic.get(c,0) + 1
		for k	in sorted(dic.keys()):
		  n.append(k)
		  n.append(repr(dic[k]))
		ns = ''.join(n)
		if len(str) < len(ns):
			return str
		else:
			return ns
		
	#1.6
	def rotateMatrix(self,mat):
		a= []
		for n in map(list,zip(*mat)):
			a.append(n)
		return a[::-1]
	
	#1.7
	def setZero(self,mat):
		row = [ True for i in range(len(mat))]
		col = [ True for j in range(len(mat[0]))]
		for i in range(len(mat)):
		  for j in range(len(mat[0])):
		    if mat[i][j] == 0:
		    	row[i] = False
		    	col[j] = False
		for i in range(len(mat)):
		  for j in range(len(mat[0])):
		    if row[i] == False or col[j] == False:
		      mat[i][j] = 0
		return mat
	
	#1.8
	def isSubstring(self,s1,s2):
		if s1 is None or s2 is None:
			return False
		if len(s1) != len(s2):
			return False
		s3 = s2+s2
		return s1 in s3
	  
if __name__=='__main__':
  s = Solution()
  print ("#1.1")
  print (s.uniqueChar("qwert"))
  print ("#1.2")
  print (s.reverseStr("abcde"))
  print ("#1.3")
  print (s.isAnagram("abced","abcde"))
  print ("#1.4")
  print (s.replaceSpace("i o u"))
  print ("#1.5")
  print (s.compress("aaaabbbbccccc"))
  print ("#1.6")
  print (s.rotateMatrix([[1,2,3],[4,5,6],[7,8,9]]))
  print (s.rotateMatrix([[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]))
  print ("#1.7")
  print (s.setZero([[1,2,3,4],[5,0,7,8],[9,10,11,12],[13,14,15,0]]))
  print ("#1.8")
  print (s.isSubstring("apple","leapp"))
  