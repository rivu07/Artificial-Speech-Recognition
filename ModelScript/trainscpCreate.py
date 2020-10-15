import glob
import re
import os
import sys

loc = sys.argv[1]

di = loc+'mfcc/*'
files = glob.glob(di)

f = open('train.scp','w')

for file in range (1,len(files)+1):
	x= './mfcc/sample'+str(file)+'.mfc'
	print(x,file=f)

f.close()

