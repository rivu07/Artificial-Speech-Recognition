import glob

files = glob.glob('mfcc/*')

print(files)

f1 = open('test.scp','w')

for file in files:
	print(file,file=f1)

f1.close()

