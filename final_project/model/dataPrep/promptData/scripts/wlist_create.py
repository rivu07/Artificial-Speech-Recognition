import numpy as np 
import pandas as pd

f1 = open("sentencesForPython.txt","r")
f2 = open("wlistFromPython.txt","w")

text = f1.read()

lines = text.split("\n")

data = []

for line in lines:
	y = line.split(" ")
	for x in y:
		if x != '\n' and x!='':
			data.append(x)

x = np.array(data)

words = np.sort(x)
words = np.unique(words)
print(words)

for word in words:
	print(word,file=f2)

f1.close()
f2.close()


