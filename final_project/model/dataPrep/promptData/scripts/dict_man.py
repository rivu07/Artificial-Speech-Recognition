import re

neg = re.compile("~[\w]*")

set1 = re.compile("\\bao[\d]?\\b")
set2 = re.compile("\\bax[\d]?\\b|\\bax\-h[\d]?\\b")
set3 = re.compile("\\baxr[\d]?\\b")
set4 = re.compile("\\bhv[\d]?\\b")
set5 = re.compile("\\bix[\d]?\\b")
set6 = re.compile("\\bel[\d]?\\b")
set7 = re.compile("\\bem[\d]?\\b")
set8 = re.compile("\\ben[\d]?\\b|\\bnx[\d]?\\b")
set9 = re.compile("\\beng[\d]?\\b")
set10 = re.compile("\\bzh[\d]?\\b")
set11 = re.compile("\\bux[\d]?\\b")
#set12 = re.compile("\bpcl\b|\bao\b")
set13 = re.compile("\\bq[\d]? \\b")




f1 = open("timitdict",'r')
f2 = open("timitdictupd",'w')



lines = f1.readlines()

for line in lines:
	line = re.sub(neg,"",line)
	parts = line.split("/")
	x = parts[0].upper()
	x = x.replace(".","")
	y = parts[1].replace("\n","")
	y = y.replace("/","")
	y = re.sub(set1,"aa",y)
	y = re.sub(set2,"ah",y)
	y = re.sub(set3,"er",y)
	y = re.sub(set4,"hh",y)
	y = re.sub(set5,"ih",y)
	y = re.sub(set6,"l",y)
	y = re.sub(set7,"m",y)
	y = re.sub(set8,"n",y)
	y = re.sub(set9,"ng",y)
	y = re.sub(set10,"sh",y)
	y = re.sub(set11,"uw",y)
	y = re.sub(set13,"",y)
	print(x+y,file=f2)

f1.close()
f2.close()

