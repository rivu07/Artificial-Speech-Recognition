import glob

files = glob.glob('mfcc/*')


f1 = open('train.scp','w')

for file in files:
	print(file,file=f1)

f1.close()

