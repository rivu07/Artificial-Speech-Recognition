import pandas as pd
import numpy as np

original = pd.read_csv("Original_ergodic_CM.csv")
original = original[["phoneme","accuracy"]]
babble0 = pd.read_csv("SNR_0_babble_ergodic_CM.csv")
babble0 = babble0[["phoneme","accuracy"]]
babble10 = pd.read_csv("SNR_10_babble_ergodic_CM.csv")
babble10 = babble10[["phoneme","accuracy"]]
babble20 = pd.read_csv("SNR_20_babble_ergodic_CM.csv")
babble20 = babble20[["phoneme","accuracy"]]
pink10 = pd.read_csv("SNR_10_pink_ergodic_CM.csv")
pink10 = pink10[["phoneme","accuracy"]]
pink20 = pd.read_csv("SNR_20_pink_ergodic_CM.csv")
pink20 = pink20[["phoneme","accuracy"]]

car0 = pd.read_csv("SNR_0_car_ergodic_CM.csv")
car0 = car0[["phoneme","accuracy"]]
car10 = pd.read_csv("SNR_10_car_ergodic_CM.csv")
car10 = car10[["phoneme","accuracy"]]
car20 = pd.read_csv("SNR_20_car_ergodic_CM.csv")
car20 = car20[["phoneme","accuracy"]]



df = original
print(df)

df = df.merge(babble0,on="phoneme",suffixes=(None,"_babble_0_ergodic"))
df = df.merge(babble10,on="phoneme",suffixes=(None,"_babble_10_ergodic"))
df = df.merge(babble20,on="phoneme",suffixes=(None,"_babble_20_ergodic"))
df = df.merge(pink10,on="phoneme",suffixes=(None,"_pink_10_ergodic"))
df = df.merge(pink20,on="phoneme",suffixes=(None,"_pink_20_ergodic"))
df = df.merge(car0,on="phoneme",suffixes=(None,"_car_0_ergodic"))
df = df.merge(car10,on="phoneme",suffixes=(None,"_car_10_ergodic"))
df = df.merge(car20,on="phoneme",suffixes=(None,"_car_20_ergodic"))

print(df)

df.to_csv("data.csv")
