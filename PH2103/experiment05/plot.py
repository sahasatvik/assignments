#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy import optimize

data = pd.read_excel('data.xlsx')
voltage, current = list(data.columns)
voltages = data[voltage]
currents = data[current]

currents *= 1e-7

plt.plot(voltages, currents, label='IV characteristic')
plt.xlabel("Voltage across $G_2K$ (V)")
plt.ylabel("Plate current (A)")

# Fit minima currents
x = np.array([36.5, 48.0, 59.0, 71.0, 83.0])
y = np.array([0.42, 0.43, 0.56, 0.80, 1.20]) * 1e-7
coeff, cov = optimize.curve_fit(lambda x, n, a: a * x**n, x, y)
n, a = coeff
x = np.linspace(0, 90, 100)
plt.plot(x, a * x**n, '--r', label='Fit of minima currents to $aV^n$')
plt.legend()
plt.show()

s_n, s_a = cov[0, 0]**0.5, cov[1, 1]**0.5
print n, s_n
print a, s_a
