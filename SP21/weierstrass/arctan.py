#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
fig.set_size_inches(16, 14)

def f_n(n):
    def f(x):
        return np.sum([(-1)**k * x ** (2*k + 1) / (2*k + 1) for k in range(n)], axis=0)
    return f

MAX_DEGREE = 10
colors = plt.get_cmap('YlOrRd')(np.linspace(0, 0.2, MAX_DEGREE) ** 0.3)

x = np.linspace(0.5, 1.15, 100)
for n, c in zip(range(1, MAX_DEGREE), colors):
    plt.plot(x, f_n(n)(x), linestyle="dashed", color=c)

plt.plot(x, f_n(MAX_DEGREE)(x), color="orange", linewidth=3)
plt.plot(x, np.arctan(x), '-r', linewidth=4)
plt.scatter(1, np.arctan(1), s=70, c="red")

plt.axis("off")
plt.savefig("img/arctan.png", transparent=True, bbox_inches="tight")

