#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv('data.txt', sep='\s+')
U, D1, D2 = data['Voltage'], data['D1'], data['D2']

# Scale data to SI units
U *= 1000
D1 /= 100
D2 /= 100

# Plot datapoints
plt.scatter(1 / np.sqrt(U), D1, c='b', marker='1', label='D1')
plt.scatter(1 / np.sqrt(U), D2, c='r', marker='2', label='D2')

# Fit data to straight line through origin and plot
x = np.linspace(1 / np.sqrt(8000), 1 / np.sqrt(2500), 10)
k1, _, _, _ = np.linalg.lstsq((1 / np.sqrt(U))[:, np.newaxis], D1, rcond=None)
k2, _, _, _ = np.linalg.lstsq((1 / np.sqrt(U))[:, np.newaxis], D2, rcond=None)
plt.plot(x, k1 * x, '--b', label='Linear fit: $k_1 \\approx ' + str(k1[0])[:4] + '$')
plt.plot(x, k2 * x, '--r', label='Linear fit: $k_2 \\approx ' + str(k2[0])[:4] + '$')
plt.xlabel('$1 / \sqrt{U}$')
plt.ylabel('Diameter $D$')
plt.legend()
plt.show()

# Display fit parameters
print 'k1 = %f, k2 = %f' % (k1, k2)

# Set constants and formulae
L = 135e-3
m = 9.1091e-31
e = 1.6021e-19
h = 6.6256e-34
d = lambda k: 2 * L * h / (k * np.sqrt(2 * m * e))
l = lambda d, D: d * D / (2 * L)

# Calculate theoretical wavelengths
l_theory = h / np.sqrt(2 * m * e * U)
# Calculate and display lattice constants
d1, d2 = d(k1), d(k2)
print 'd1 = %f, d2 = %f (Angstrom)' % (d1 * 1e10, d2 * 1e10)

# Calculate and insert wavelengths for each datapoint
data.insert(3, 'Lambda_1', l(d1, D1))
data.insert(4, 'Lambda_2', l(d2, D2))
data.insert(5, 'Lambda (theory)', l_theory)

# Display all data and calculations
print data
