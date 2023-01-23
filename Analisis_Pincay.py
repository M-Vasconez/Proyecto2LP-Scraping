import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

laptops = pd.read_csv('laptops.csv')
df2 = laptops.sort_values('PRECIO')
print(df2.head(10))

df = laptops.groupby('MARCA')['PRECIO'].apply(np.mean).reset_index(name="PROMEDIO PRECIO")
df.plot.bar(x='MARCA', y='PROMEDIO PRECIO', rot=0)
plt.show()