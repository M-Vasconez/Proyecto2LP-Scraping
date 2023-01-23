import numpy as np
import matplotlib.pyplot as plt

arr = np.loadtxt("camaras.csv",delimiter=',',dtype=str)
marcas = {}
promedio_marcas = {}


#Unificacion del nombre de las marcas con sus posibles ratings
for x in arr:
    if x[0] in marcas.keys():
        numero = float(x[1])
        marcas[x[0]].append(numero)
    else:
        numero = float(x[1])
        marcas[x[0]]=[numero]

#Calculo de; promedio por marca
for key in marcas:
    promedio = sum(marcas[key])/len(marcas[key])
    promedio_marcas[key] = promedio

#Ordenamiento de las marcas por su promedio
sorted_promedio = dict(sorted(promedio_marcas.items(), key = lambda x:x[1],reverse=True))
print(sorted_promedio)

#Grafico de las marcas por su promedio ordenado
names = sorted_promedio.keys()
values = sorted_promedio.values()
plt.bar(names, values,color=["#264653","#2a9d8f",'#e9c46a',"#f4a261","#e76f51"])
plt.xticks(rotation='vertical')
plt.ylabel("Ratings")
plt.xlabel("Marcas")
plt.title("Marcas segun su rating")
plt.show()



