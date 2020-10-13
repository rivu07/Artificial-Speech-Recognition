import numpy as np
import pandas as pd
import re

stop = re.compile("\.")
comma = re.compile("\,")
ques = re.compile("\?")
quote = re.compile('"')
excla = re.compile('!')
dash2 = re.compile('--')
colon = re.compile(':')
semicolon = re.compile(';')

def restrip(s):
	s = re.sub(comma,"",s)
	s = re.sub(ques,"",s)
	s = re.sub(excla,"",s)
	s = re.sub(quote,"",s)
	s = re.sub(dash2,"",s)
	s = re.sub(colon,"",s)
	s = re.sub(stop,"",s)
	s = re.sub(semicolon,"",s)
	return s


f = open("PROMPTS.TXT","r")
lines = f.readlines()

f2 = open("sentencesForJulius.txt",'w')
f3 = open("sentencesForPython.txt",'w')
data =[]

for i in range(6,len(lines)):
	x=lines[i].rsplit(" ",1)
	x[1]=x[1].replace(")\n","")
	x[1]=x[1].replace("(","")
	y = restrip(x[0].upper())
	s = "*/sample"+str(i-5)+" "+str(y)
	print(s,file=f2)
	print(y,file=f3)
	data.append([i-5,x[1],x[0],y,s])


datanp = np.array(data)

columns = ['sl','index','sentence','promptsForPython','promptsForJulius']

df = pd.DataFrame(data=datanp,columns=columns)

df.to_csv("speechdata.csv")



f.close()
f2.close()
f3.close()