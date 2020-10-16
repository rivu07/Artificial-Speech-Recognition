import glob
import re
import os

big = re.compile('sowav')
small = re.compile('wav')

def modify(s):
	s = re.sub(big,'mfcc',s)
	s = re.sub(small,'mfc',s)
	return s



files = glob.glob('train/sowav/*')


f = open('codetrain.scp','w')

for file in files:
	#command = 'mv '+file+' '+file+'.wav'
	#os.system(command)
	x= './'+file
	y = './'+modify(file)
	print(x,y,file=f)

f.close()

