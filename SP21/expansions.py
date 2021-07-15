#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

from bernstein import bernstein

fig, ax = plt.subplots()
plt.subplots_adjust(bottom=0.15)
fig.set_size_inches(10, 8)

def f(x):
    return np.cos(2 * np.pi * x) * np.exp(x)

MAX_DEGREE = 250
colors = plt.get_cmap('Greys')(np.linspace(0, 0.9, MAX_DEGREE) ** 0.3)

x = np.linspace(0, 1, 100)
for n, c in zip(range(1, MAX_DEGREE), colors):
    plt.plot(x, bernstein(f, n)(x), color=c)

plt.plot(x, f(x), '-r', linewidth=3)

plt.title("Bernstein expansions of $e^x\cos(2\pi x)$")
plt.xlim(0, 1)
plt.show()
