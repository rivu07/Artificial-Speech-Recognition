
file1 = open('../monophones0','r')
file2 = open('protomodified','r')
file = open('hmmdefs','w')

hmms = file1.readlines()

txt = file2.read()

for hmm in hmms:
	x = hmm.replace("\n","")
	print("~h "+'\"'+x+'\"',file=file)
	print(txt,end="",file=file)
file.close()
file1.close()
file2.close()


