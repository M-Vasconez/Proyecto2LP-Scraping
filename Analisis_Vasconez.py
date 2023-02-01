import numpy as np
import matplotlib.pyplot as plt

arr = np.loadtxt("camaras.csv", delimiter=',', dtype=str, skiprows=1)
marcas = {}
promedio_marcas = {}

# Ejercicio 1
# Unificacion del nombre de las marcas con sus posibles ratings
for x in arr:
    if x[0] in marcas.keys():
        numero = float(x[1])
        marcas[x[0]].append(numero)
    else:
        numero = float(x[1])
        marcas[x[0]] = [numero]

# Calculo de promedio por marca
for key in marcas:
    promedio = sum(marcas[key]) / len(marcas[key])
    promedio_marcas[key] = promedio

# Ordenamiento de las marcas por su promedio
sorted_promedio = dict(sorted(promedio_marcas.items(),
                              key=lambda x: x[1], reverse=True))
# print(sorted_promedio)

# Grafico de las marcas por su promedio ordenado
names = sorted_promedio.keys()
values = sorted_promedio.values()
plt.bar(names, values, color=["#264653",
                              "#2a9d8f", '#e9c46a', "#f4a261", "#e76f51"])
plt.xticks(rotation='vertical')
plt.ylabel("Ratings")
plt.xlabel("Marcas")
plt.title("Marcas segun su rating")
plt.show()

# Ejercicio 2
# Se limpia el grafico anterior
plt.clf()
filtrado50_100 = []
# Se filtran los datos
for x in arr:
    if (float(x[2]) >= 50 and float(x[2]) <= 100):
        if (len(filtrado50_100) == 0):
            filtrado50_100.insert(0, [x[0]])
            filtrado50_100.insert(1, [float(x[1])])
        else:
            filtrado50_100[0].append(x[0])
            filtrado50_100[1].append(float(x[1]))

# print(filtrado50_100)
# Se grafica un scatter plot con los datos filtrados
colors = np.random.randint(100, size=len(filtrado50_100[0]))
plt.scatter(filtrado50_100[0], filtrado50_100[1], c=colors, cmap='jet')
plt.xticks(rotation='vertical')
plt.title("Marcas en el rango de 50 a 100 dolares")
plt.ylabel("Ratings")
plt.xlabel("Marcas")
plt.show()

# Ejercicio 3
# Se limpia el grafico anterior
plt.clf()
#Full HD
Eje3FullHD = []
siWYZE = 0
noWYZE = 0
siREOLINK = 0
noREOLINK = 0
for x in arr:
    if x[0] == 'WYZE':
        if x[3] == 'true':
            siWYZE += 1
        else:
            noWYZE += 1

    elif x[0] == 'REOLINK':
        if x[3] == 'true':
            siREOLINK += 1
        else:
            noREOLINK += 1
Eje3FullHD.append(siWYZE)
Eje3FullHD.append(siREOLINK)
Eje3FullHD.append(noREOLINK)
Eje3FullHD.append(noWYZE)

labels = 'Full HD WYZE','Full HD REOLINK', 'Sin Full HD REOLINK', 'Sin Full HD WYZE'
def absolute_value(val):
    a  = int(np.round(val/100.*sum(Eje3FullHD), 0))
    return a
plt.pie(Eje3FullHD, autopct=absolute_value, startangle=-40)
plt.axis('equal')
plt.title('Full HD de las marcas WYZE Y REOLINK')
plt.legend(labels,
           loc="center left",
           bbox_to_anchor=(1, 0, 0.5, 1))
plt.show()

# Se limpia el grafico anterior
plt.clf()
#Night Vision
Eje3NightVision = []
siWYZE = 0
noWYZE = 0
siREOLINK = 0
noREOLINK = 0
for x in arr:
    if x[0] == 'WYZE':
        if x[4] == 'true':
            siWYZE += 1
        else:
            noWYZE += 1

    elif x[0] == 'REOLINK':
        if x[4] == 'true':
            siREOLINK += 1
        else:
            noREOLINK += 1
Eje3NightVision.append(siWYZE)
Eje3NightVision.append(siREOLINK)
Eje3NightVision.append(noREOLINK)
Eje3NightVision.append(noWYZE)

labels = 'Night Vision WYZE','Night Vision REOLINK', 'Sin Night Vision REOLINK', 'Sin Night Vision WYZE'
def absolute_value(val):
    a  = int(np.round(val/100.*sum(Eje3NightVision), 0))
    return a
plt.pie(Eje3NightVision, autopct=absolute_value, startangle=-40)
plt.axis('equal')
plt.title('Night Vision de las marcas WYZE Y REOLINK')
plt.legend(labels,
           loc="center left",
           bbox_to_anchor=(1, 0, 0.5, 1))
plt.show()
