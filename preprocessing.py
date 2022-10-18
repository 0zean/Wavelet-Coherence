import numpy as np
import pandas as pd


# Data + preprocessing
es = pd.read_csv('CHRIS-CME_ES1.csv')
cl = pd.read_csv('CHRIS-CME_CL1.csv')

df = pd.merge(left=es, left_on='Date',
         right=cl, right_on='Date')


df = df[['Date', 'Last_x', 'Last_y']]
df.columns = ['Date', 'es', 'cl']


df = df.iloc[::-1]
df = df.reset_index(drop=True)
df.to_csv('best.csv', sep=',')


esw = df['es']
clw = df['cl']


# log first-order difference
esw = np.log(esw) - np.log(esw).shift(1)
esw = esw.dropna()
clw = np.log(clw) - np.log(clw).shift(1)
clw = clw.dropna()


esw = np.array(esw)
clw = np.array(clw)
