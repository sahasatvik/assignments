#!/usr/bin/env python3

import numpy as np

def newton_forward(x, fx, x_0):
    '''
    Performs interpolation of the curve (x_i, fx_i) at the point x_0
    using Newton's forward difference method.
    '''

    u = (x_0 - x[0]) / (x[1] - x[0])
    diff = fx.copy()
    fx_0 = fx[0]
    p = u
    for i in range(1, len(x)):
        diff = diff[1:] - diff[:-1]
        fx_0 += diff[0] * p
        p *= (u - i) / (i + 1)
    return fx_0

if __name__ == '__main__':
    import matplotlib.pyplot as plt
    x = np.linspace(0, 2 * np.pi, 6)
    y = np.cos(x)
    
    x_interp = np.linspace(0, 2 * np.pi, 101)
    y_interp = [newton_forward(x, y, r) for r in x_interp]

    plt.plot(x, y, label="Original sample of $\cos{x}$")
    plt.plot(x_interp, y_interp, label="Interpolated curve")
    plt.plot(x_interp, np.cos(x_interp), label="Actual curve")
    plt.legend()
    plt.show()
