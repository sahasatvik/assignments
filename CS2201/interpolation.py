#!/usr/bin/env python3

import numpy as np

def newton_forward(x, fx, x_0):
    def r_cal(r, n):
        t = 1
        for i in range(1, n):
            t *= (r - i) / i
        return t
    n = len(x)
    r = (x[0] - x_0) / (x[1] - x[0])
    diff = fx.copy()
    print(diff)
    fx_0 = fx[0]
    for i in range(n - 1):
        diff = diff[1:] - diff[:-1]
        print(diff)
        fx_0 += diff[0] * r_cal(r, i)
    return fx_0

x = np.linspace(0, 10, 11)
y = x**2
print(newton_forward(x, y, 1))
