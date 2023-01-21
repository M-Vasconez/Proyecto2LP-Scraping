import numpy as np
import matplotlib.pyplot as plt
import csv


arr = np.loadtxt("relojes.csv",delimiter=',',dtype=str)
print("Numpy length: ",arr)