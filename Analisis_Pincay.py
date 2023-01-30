import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

def remove_small_data(df):
    freq = df['MARCA'].value_counts() 
    to_remove = []
    for items in freq.items():
        if items[1]<=5:
            to_remove.append(items[0])
    for m in to_remove:
        df.drop(df[df['MARCA']==m].index, inplace=True)

def ranking_feature(df, feature, gama):
    f = df[(df['GAMA']==gama)]
    f = f.sort_values(by=[feature,'PRECIO'], ascending=[False, True])
    new_index = pd.Index(range(len(f)))
    f = f.set_index(new_index)
    return f

def ranking_gamas(ram, disco, pulgadas, procesador):
    ranks = ram
    ranks['PUNTUACION'] = range(len(ranks))
    new_puntajes = []
    for l1 in ranks.index:
        link1 = ranks['LINK'][l1]
        new_punt = 0
        for l2 in disco.index:
            link2= disco['LINK'][l2]
            if link1 == link2:
                new_punt += ranks['PUNTUACION'][l1] + l2
                break
        for l3 in pulgadas.index:
            link3 = pulgadas['LINK'][l3]
            if link1 == link3:
                new_punt += ranks['PUNTUACION'][l1] + l3
                break
        for l4 in procesador.index:
            link4 = procesador['LINK'][l4]
            if link1 == link4:
                new_punt += ranks['PUNTUACION'][l1] + l4
                break
        new_puntajes.append(new_punt)
    ranks['PUNTUACION'] = new_puntajes
    return ranks

#obteniendo los datos
laptops = pd.read_csv('laptops.csv')
#quitando marcas no representativas
remove_small_data(laptops)
laptops = laptops.astype({'PULGADAS':'float'})
#agregando categorias
gama = pd.cut(laptops['PRECIO'], 5, labels=['baja','media baja','media','media alta','alta'])
laptops['GAMA'] = gama
#grafico de barras precio promedio por marca (PRIMERA PREGUNTA)
df2 = laptops.groupby('MARCA')['PRECIO'].apply(np.mean).reset_index(name="PROMEDIO PRECIO")
df2.plot.bar(x='MARCA', y='PROMEDIO PRECIO', rot=0)
plt.savefig('resultados_pincay/precio promedio')

#SEGUNDA PREGUNTA
#RAM
df3 = laptops.groupby(['MARCA','RAM'], as_index=False)['PRECIO'].apply(np.mean)
g=sns.lmplot(x='RAM', y='PRECIO', data=df3, hue='MARCA')
g.fig.subplots_adjust(top=.95)
g.ax.set_title('Ram vs Precio')
plt.savefig('resultados_pincay/ram vs precio')
#DISCO
df3 = laptops.groupby(['MARCA','DISCO'], as_index=False)['PRECIO'].apply(np.mean)
g=sns.lmplot(x='DISCO', y='PRECIO', data=df3, hue='MARCA')
g.fig.subplots_adjust(top=.95)
g.ax.set_title('Disco vs Precio')
plt.savefig('resultados_pincay/disco vs precio')
#PULGADAS
df3 = laptops.groupby(['MARCA','PULGADAS'], as_index=False)['PRECIO'].apply(np.mean)
g=sns.lmplot(x='PULGADAS', y='PRECIO', data=df3, hue='MARCA')
g.fig.subplots_adjust(top=.95)
g.ax.set_title('Pulgadas vs Precio')
plt.savefig('resultados_pincay/pulgada vs precio')
#PROCESADORES
df3 = laptops.groupby(['MARCA','PROCESADOR'], as_index=False)['PRECIO'].apply(np.mean)
df3 = df3[df3.PROCESADOR.str.match('intel core i\d$')]
df3 = df3.sort_values(by=['PROCESADOR'])
g=sns.catplot(data=df3, x="PROCESADOR", y="PRECIO", hue="MARCA", kind="point")
g.fig.subplots_adjust(top=.95)
g.ax.set_title('Procesador vs Precio')
plt.savefig('resultados_pincay/procesador vs precio')

#TERCERA PREGUNTA
# MEJORES LAPTOPS POR GAMAS QUE TIENEN PROCESADORES INTEL CORE
laptops_intel= laptops[laptops.PROCESADOR.str.match('intel core i\d$')]
#GAMA BAJA
ramgb = ranking_feature(laptops_intel, 'RAM', 'baja')
discogb = ranking_feature(laptops_intel, 'DISCO', 'baja')
pulgadasgb = ranking_feature(laptops_intel, 'PULGADAS', 'baja')
procesadorgb = ranking_feature(laptops_intel, 'PROCESADOR', 'baja')
ranksgb = ranking_gamas(ramgb, discogb, pulgadasgb, procesadorgb)
ranksgb = ranksgb.sort_values(by=['PUNTUACION'])
new_index = pd.Index(range(len(ranksgb)))
ranksgb = ranksgb.set_index(new_index)
headgb = ranksgb.head(10)
headgb.to_csv('resultados_pincay/ranking gama baja.csv')
#GAMA MEDIA BAJA
ramgmb = ranking_feature(laptops_intel, 'RAM', 'media baja')
discogmb = ranking_feature(laptops_intel, 'DISCO', 'media baja')
pulgadasgmb = ranking_feature(laptops_intel, 'PULGADAS', 'media baja')
procesadorgmb = ranking_feature(laptops_intel, 'PROCESADOR', 'media baja')
ranksgmb = ranking_gamas(ramgmb, discogmb, pulgadasgmb, procesadorgmb)
ranksgmb = ranksgmb.sort_values(by=['PUNTUACION'])
new_index = pd.Index(range(len(ranksgmb)))
ranksgmb = ranksgmb.set_index(new_index)
headgmb = ranksgmb.head(10)
headgmb.to_csv('resultados_pincay/ranking gama media baja.csv')
#GAMA MEDIA
ramm = ranking_feature(laptops_intel, 'RAM', 'media')
discom = ranking_feature(laptops_intel, 'DISCO', 'media')
pulgadasm = ranking_feature(laptops_intel, 'PULGADAS', 'media')
procesadorm = ranking_feature(laptops_intel, 'PROCESADOR', 'media')
ranksm = ranking_gamas(ramm, discom, pulgadasm, procesadorm)
ranksm = ranksm.sort_values(by=['PUNTUACION'])
new_index = pd.Index(range(len(ranksm)))
ranksm = ranksm.set_index(new_index)
headm = ranksm.head(10)
headm.to_csv('resultados_pincay/ranking gama media.csv')
#GAMA MEDIA ALTA
ramma = ranking_feature(laptops_intel, 'RAM', 'media alta')
discoma = ranking_feature(laptops_intel, 'DISCO', 'media alta')
pulgadasma = ranking_feature(laptops_intel, 'PULGADAS', 'media alta')
procesadorma = ranking_feature(laptops_intel, 'PROCESADOR', 'media alta')
ranksma = ranking_gamas(ramma, discoma, pulgadasma, procesadorma)
ranksma = ranksma.sort_values(by=['PUNTUACION'])
new_index = pd.Index(range(len(ranksma)))
ranksma = ranksma.set_index(new_index)
headma = ranksma.head(10)
headma.to_csv('resultados_pincay/ranking gama media alta.csv')
#GAMA ALTA
ramga = ranking_feature(laptops_intel, 'RAM', 'alta')
discoga = ranking_feature(laptops_intel, 'DISCO', 'alta')
pulgadasga = ranking_feature(laptops_intel, 'PULGADAS', 'alta')
procesadorga = ranking_feature(laptops_intel, 'PROCESADOR', 'alta')
ranksga = ranking_gamas(ramga, discoga, pulgadasga, procesadorga)
ranksga = ranksga.sort_values(by=['PUNTUACION'])
new_index = pd.Index(range(len(ranksga)))
ranksga = ranksga.set_index(new_index)
headga = ranksga.head(10)
headga.to_csv('resultados_pincay/ranking gama alta.csv')