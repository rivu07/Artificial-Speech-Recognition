import pandas as pd 
import numpy as np


df1 = pd.read_csv("renametest.csv")
df2 = pd.read_csv("speechdata.csv")

def f(tx):
	t = tx.lower()
	x = df2[df2['index']==t]['promptsForPython'].values[0]
	return x


df = df1

df['prompttexts'] = df['prompt'].apply(f)

df.to_csv("speechprompts.csv")


prompts = df[['samplenumber','prompttexts']].values.tolist()


f1 = open('sentences.txt','w')

for prompt in prompts:
	txt = '*/'+prompt[0]+' '+prompt[1]
	print(txt,file=f1)

f1.close()



