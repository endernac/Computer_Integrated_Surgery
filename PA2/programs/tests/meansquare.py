import pandas as pd
import numpy as np

alphabet = ['a','b','c','d','e','f']

MSE = []
for i in alphabet:
    debug_path = "../data/pa2-debug-" + i + "-output2.txt"
    generated_path = "../output/pa2-debug-" + i + "-output2.txt"

    debug_data = np.array(pd.read_csv(debug_path, header=None, skiprows=[0]))
    generated_data = np.array(pd.read_csv(generated_path, header=None, skiprows=[0]))
    print(debug_data)
    print(generated_data)
    mse = np.mean((debug_data - generated_data)**2) / debug_data.size
    MSE.append(mse)
print(np.array(MSE))