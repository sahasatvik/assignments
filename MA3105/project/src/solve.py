#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

def newton(f, df, x0, maxiter=10, tol=1e-6):
    for i in range(maxiter):
        x = x0 - f(x0) / df(x0)
        if abs(x0 - x) < tol:
            return x
        x0 = x
    return x

def euler(f, x0, xn, y0, h):
    yield y0
    for x in np.arange(x0, xn, h):
        y0 += h * f(y0, x)
        yield y0

def trapezoidal(f, dfdy, x0, xn, y0, h):
    yield y0
    for x in np.arange(x0, xn, h):
        F = lambda t: -t + y0 + 0.5 * h * (f(y0, x) + f(t, x + h))
        dF = lambda t: -1 + 0.5 * h * dfdy(t, x + h)
        y0 = newton(F, dF, y0 + h * f(y0, x))
        yield y0


def f(y, x):
    return y - x

def dfdy(y, x):
    return 1

def y_analytic(x):
    return 1 + x - np.exp(x) / 3.0

# Euler

fig = plt.figure(figsize=(8, 6))

h = 1.0
for i in range(10):
    x = np.arange(0, 2 + h, h)
    y = np.array(list(euler(f, 0, 2, 2.0 / 3, h)))
    plt.plot(x, y, "-", color="orange", linewidth=1.0, alpha=(i + 1.0) / (i + 2.0))
    plt.scatter(1.0, y[x == 1.0], color="orange", s=10, alpha=(i + 1.0) / (i + 2.0))
    h /= 2.0

x = np.linspace(0, 2, 200)
plt.plot(x, y_analytic(x), "-r", linewidth=2.0)
plt.scatter(1.0, y_analytic(1.0), color="red", s=20, alpha=0.7)

plt.xlim([0, 2])
plt.xlabel("x")
plt.ylabel("y")

plt.tight_layout()
plt.savefig("../img/euler.png", transparent=True)

# Trapezoidal

fig = plt.figure(figsize=(8, 6))

h = 1.0
for i in range(10):
    x = np.arange(0, 2 + h, h)
    y = np.array(list(euler(f, 0, 2, 2.0 / 3, h)))
    plt.plot(x, y, "-", color="orange", linewidth=1.0, alpha=(i + 1.0) / (i + 2.0))
    h /= 2.0

h = 1.0
for i in range(10):
    x = np.arange(0, 2 + h, h)
    y = np.array(list(trapezoidal(f, dfdy, 0, 2, 2.0 / 3, h)))
    plt.plot(x, y, "-", color="green", linewidth=1.5, alpha=(i + 1.0) / (i + 2.0))
    plt.scatter(1.0, y[x == 1.0], color="green", s=10, alpha=(i + 1.0) / (i + 2.0))
    # print(h, y[x == 1.0])
    h /= 2.0

x = np.linspace(0, 2, 200)
plt.plot(x, y_analytic(x), "-r", linewidth=2.0)
plt.scatter(1.0, y_analytic(1.0), color="red", s=20, alpha=0.7)

plt.xlim([0, 2])
plt.xlabel("x")
plt.ylabel("y")

plt.tight_layout()
plt.savefig("../img/trapezoidal.png", transparent=True)

plt.xlim([0.9, 1.1])
plt.ylim([1.05, 1.15])
plt.savefig("../img/trapezoidal_zoom.png", transparent=True)


# Errors

fig = plt.figure(figsize=(7, 6))

H = []
e_euler = []
e_trapezoidal = []

h = 1.0
for i in range(10):
    H.append(h)
    x = np.arange(0, 2 + h, h)
    y_euler = np.array(list(euler(f, 0, 2, 2.0 / 3, h)))
    y_trapezoidal = np.array(list(trapezoidal(f, dfdy, 0, 2, 2.0 / 3, h)))
    y_actual = y_analytic(x)

    e_euler.append(np.max(np.abs(y_actual - y_euler)))
    e_trapezoidal.append(np.max(np.abs(y_actual - y_trapezoidal)))
    h /= 2.0

plt.loglog(H, e_euler, "-x", color="orange", label=r"Slope $\approx 1$")
plt.loglog(H, e_trapezoidal, "-x", color="green", label=r"Slope $\approx 2$")

# plt.xlim([0, 2])
plt.xlabel("$\log{h}$")
plt.ylabel("$\log{e_h}$")
plt.legend()

plt.tight_layout()
plt.savefig("../img/errors.png", transparent=True)
