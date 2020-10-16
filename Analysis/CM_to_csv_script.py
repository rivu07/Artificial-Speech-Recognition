import numpy as np
import pandas as pd


names = ["Original","SNR_0_babble","SNR_10_babble","SNR_20_babble","SNR_10_pink","SNR_20_pink","SNR_0_car","SNR_10_car","SNR_20_car"]

for name in names:
    oldname = name+"_CM.txt"

    file = open(oldname,"r")
    lines = file.readlines()
    lines = lines[11:-3]

    accuracies=[]

    for line in lines:
        txt = line.split()
        phoneme = txt[0]
        acc = txt[-1]
        acc=acc.replace("[","")
        acc=acc.replace("]","")
        accp = acc.split("/")[0]
        accuracies.append([phoneme,accp])

    data = np.array(accuracies)

    columns=["phoneme","accuracy"]

    df = pd.DataFrame(data=data,columns=columns)

    newname = name+"_CM.csv"
    df.to_csv(newname)
    file.close()

