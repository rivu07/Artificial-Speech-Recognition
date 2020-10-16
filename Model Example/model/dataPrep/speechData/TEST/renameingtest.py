import os
import pandas as pd
import numpy as np
import glob

files = glob.glob("*/*/*.WAV",recursive=True)

data = []
index = 1
for file in files:
	name = file.rsplit("/",1)
	modName = 'sample'+str(index)
	command = 'cp '+str(file)+' ../renamedtest/'+modName+'.WAV'
	os.system(command)
	prompt = name[1].split(".")[0]
	x = modName+'.WAV'
	data.append([file,x,modName,prompt])
	index+=1

arr = np.array(data)
column=['originalfile','renamedfile','samplenumber','prompt']

df = pd.DataFrame(arr,columns=column)

df.to_csv("renametest.csv")
