#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

from bernstein import bernstein, bernstein_poly

fig, ax = plt.subplots()
fig.set_size_inches(16, 14)

def f(x):
    return np.cos(2 * np.pi * x) * np.exp(x)

MAX_DEGREE = 250
colors = plt.get_cmap('YlOrRd')(np.linspace(0, 0.9, MAX_DEGREE) ** 0.3)

x = np.linspace(0, 1, 100)
for n, c in zip(range(1, MAX_DEGREE), colors):
    plt.plot(x, bernstein(f, n)(x), color=c)

plt.plot(x, f(x), '-r', linewidth=3)

plt.axis("off")
plt.savefig("img/expansions.png", transparent=True, bbox_inches="tight")

plt.clf()

# Component-wise expansion

for degree in range(1, 21):
    colors = plt.get_cmap('Blues')(np.linspace(0.5, 1.0, degree + 1))
    for k, c in zip(range(degree + 1), colors):
        plt.plot(x, bernstein_poly(degree, k)(x) * f(k / degree), color=c, linewidth=1)

    plt.plot(x, bernstein(f, degree)(x), color='orange', linewidth=2)
    plt.plot(x, f(x), '-r', linewidth=2)

    peaks = np.linspace(0, 1, degree + 1)
    plt.scatter(peaks, f(peaks), s=50, c='red')

    plt.axis("off")
    plt.savefig(f"img/expansion_{degree}.png", transparent=True, bbox_inches="tight")
    
    plt.clf()

# Bernstein polynomials

for degree in range(1, 8):
    colors = plt.get_cmap('Blues')(np.linspace(0.5, 1.0, degree + 1))
    for k, c in zip(range(degree + 1), colors):
        p = bernstein_poly(degree, k)
        plt.plot(x, p(x), color=c, linewidth=3)
        plt.scatter(k / degree, p(k / degree), s=50, color=c)

    plt.axis("off")
    plt.savefig(f"img/bernstein_{degree}.png", transparent=True, bbox_inches="tight")
    
    plt.clf()
