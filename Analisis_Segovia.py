import matplotlib.pyplot as plt
import csv
import numpy as np
from collections import Counter
from collections import defaultdict


# Leer el archivo CSV y acceder a la columna específica
with open('autos.csv', 'r') as f:
    reader = csv.reader(f)
    column = [row[3] for row in reader]
    
    
#La cantidad de autos que se venden por marca

# Dividir cada valor de la columna en una lista de substrings y acceder a la primera palabra
column = [val.split(" ")[0] for val in column]

# Contar la frecuencia de cada palabra en la columna
counter = Counter(column)

# Obtener las palabras y las frecuencias
words = list(counter.keys())
counts = list(counter.values())

# Crear el gráfico de barras
plt.bar(words, counts)
plt.xticks(rotation='vertical')
plt.xlabel('Modelo Auto')
plt.ylabel('Frecuencia')
plt.show()



#Obtener las 3 marcas que más se venden
top_brands = counter.most_common(3)
top_brands_words = [brand[0] for brand in top_brands]
top_brands_counts = [brand[1] for brand in top_brands]

# Calcular el porcentaje que abarcan entre ellas 3
total_counts = sum(top_brands_counts)
top_brands_percentage = [count / total_counts for count in top_brands_counts]

# Crear el gráfico circular
plt.pie(top_brands_percentage, labels=top_brands_words, autopct='%1.1f%%')
plt.axis('equal')
plt.legend(title="Marcas", loc="center left", bbox_to_anchor=(1, 0, 0.5, 1))
plt.show()


#Kilometraje Promedio entre los años 2010 y 2014 versus el de los años 2015 a 2020 
# Leer el archivo CSV y acceder a las columnas de año y kilometraje
kilometros_anteriores = []
kilometros_posteriores = []
with open('autos.csv', 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        if int(row[1]) >= 2010 and int(row[1]) < 2015:
            kilometros_anteriores.append(int(row[2]))
        if int(row[1]) >= 2015 and int(row[1]) <= 2020:
            kilometros_posteriores.append(int(row[2]))

# Calcular el promedio de kilómetros
promedio_anteriores = sum(kilometros_anteriores) / len(kilometros_anteriores)
promedio_posteriores = sum(kilometros_posteriores) / len(kilometros_posteriores)

# Crear el gráfico de barras
bar_width = 0.35
bar_locations = [1, 2]
plt.bar(bar_locations, [promedio_anteriores, promedio_posteriores], bar_width)
plt.xticks([1.5, 2.5], ['2010-2014', '2015-2020'])
plt.xlabel('Rango de Años')
plt.ylabel('Kilómetros Promedio')
plt.title(f'Kilometraje promedio entre 2015 y 2020: {promedio_posteriores:.2f} km\nKilometraje promedio entre 2010 y 2014: {promedio_anteriores:.2f} km')
plt.show()

#cual es el valor promedio de los autos de cada marca
#cual es el valor promedio de los autos de cada marca
#cual es el valor promedio de los autos de cada marca


# Leer el archivo CSV y acceder a las columnas de precio y modelo
with open('autos.csv', 'r') as f:
    reader = csv.reader(f)
    prices_models = [(float(row[0]), row[3].split(" ")[0]) for row in reader]

# Calcular el precio promedio de cada marca
average_prices = defaultdict(list)
for price, model in prices_models:
    average_prices[model].append(price)
average_prices = {model: sum(prices)/len(prices) for model, prices in average_prices.items()}

# Obtener las marcas y los precios promedios
brands = list(average_prices.keys())
avg_prices = list(average_prices.values())

# Ordenar las marcas por el precio promedio de mayor a menor
average_prices = {k: v for k, v in sorted(average_prices.items(), key=lambda item: item[1], reverse=True)}

# Obtener las marcas y los precios promedios
brands = list(average_prices.keys())
avg_prices = list(average_prices.values())

# Crear el gráfico de barras
plt.bar(brands, avg_prices)
plt.xticks(rotation='vertical')
plt.xlabel('Marca')
plt.ylabel('Precio Promedio')
plt.show()

