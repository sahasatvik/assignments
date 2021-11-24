#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import odeint

fig = plt.figure(figsize=(6, 6))

def f(y, x):
    return y - x

X, Y = np.meshgrid(np.linspace(0, 5, 20), np.linspace(0, 5, 20))

U = 1.0
V = f(Y, X)
N = np.sqrt(U**2 + V**2)
U /= N
V /= N

plt.quiver(X, Y, U, V, angles="xy")

plt.xlim([0, 5])
plt.ylim([0, 5])
plt.xlabel("x")
plt.ylabel("y")

plt.tight_layout()
plt.savefig("../img/directionfield.png", transparent=True)


x = np.linspace(0, 5, 100)
for y0 in np.linspace(0, 2, 7):
    y = odeint(f, y0, x)
    plt.plot(x, y, "-", color="orange", linewidth=2.0)

y = odeint(f, 2.0 / 3, x)
plt.plot(x, y, "-r", linewidth=3.0)

# x = np.linspace(0, 5, 20)
# h = x[1] - x[0]
# y = [0.8]
# for x_i in x[:-1]:
#     y.append(y[-1] + h * f(y[-1], x_i))
# plt.scatter(x, y)


plt.savefig("../img/directionfield_curves.png", transparent=True)

plt.show()
