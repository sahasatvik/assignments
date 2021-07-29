#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

from bernstein import bernstein

fig, ax = plt.subplots()
fig.set_size_inches(16, 14)

def f(x):
    return np.where(x < 0.5, 0, 1)

MAX_DEGREE = 250
colors = plt.get_cmap('YlOrRd')(np.linspace(0, 0.9, MAX_DEGREE) ** 0.3)

x = np.linspace(0, 1, 500)
for n, c in zip(range(1, MAX_DEGREE), colors):
    plt.plot(x, bernstein(f, n)(x), color=c)

plt.plot(x, f(x), '-r', linewidth=3)

plt.axis("off")
plt.savefig("img/expansions_step.png", transparent=True, bbox_inches="tight")

