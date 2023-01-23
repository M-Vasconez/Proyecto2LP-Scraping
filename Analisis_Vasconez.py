import numpy as np
import matplotlib.pyplot as plt


arr = np.loadtxt("camaras.csv",delimiter=',',dtype=str)
marcas = {}
promedio_marcas = {}
#print("Numpy length: ",arr)
for x in arr:
    if x[0] in marcas.keys():
        numero = float(x[1])
        marcas[x[0]].append(numero)
    else:
        numero = float(x[1])
        marcas[x[0]]=[numero]

for key in marcas:
    promedio = sum(marcas[key])/len(marcas[key])
    promedio_marcas[key] = promedio

#print(promedio_marcas)
sorted_promedio = dict(sorted(promedio_marcas.items(), key = lambda x:x[1]))
print(sorted_promedio)


names = sorted_promedio.keys()
values = sorted_promedio.values()

# fig = plt.figure()
# ax = fig.add_axes([0,0,1,1])
# ax.bar(range(len(sorted_promedio)), values,tick_label=names)
# plt.show()

plt.bar(range(len(sorted_promedio)), values,tick_label=names)
plt.show()