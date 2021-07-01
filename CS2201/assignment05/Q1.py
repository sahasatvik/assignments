#!/usr/bin/env python3

import numpy as np
import scipy as sp
import scipy.integrate

def trapezoidal(y, step):
    '''
    Returns the trapezoidal approximation of the integral under the curve
    whose points are (x_i, y_i) where x_i are equally spaced by step.
    '''

    return step * (np.sum(y) - (y[0] + y[-1]) / 2)

def simpson(y, step):
    '''
    Returns the Simpson's approximation of the integral under the curve
    whose points are (x_i, y_i) where x_i are equally spaced by step.
    Note that there must be an odd number of points x_i.
    If not, we take the average of simpsons (first even intervals) + trapezoidal (last interval),
    and simpsons (last even intervals) + trapezoidal (first interval).
    '''

    # If odd number of points, return the usual result
    if len(y) % 2 == 1:
        return step / 3 * (y[0] + 4 * np.sum(y[1:-1:2]) + 2 * np.sum(y[2:-1:2]) + y[-1])
    return 0.5 * ((simpson(y[1:], step) + trapezoidal(y[:2], step)) + (simpson(y[:-1], step) + trapezoidal(y[-2:], step)))

def f(x):
    '''
    The function generating the curve.
    '''

    return 2 * x**15 + 3 * x**3 + 45

x, h = np.linspace(0, 1, 50, retstep=True)
y = f(x)
actual = 2 / 16 + 3 / 4 + 45
trape = trapezoidal(y, h)
trape_sp = sp.integrate.trapz(y, x)
simps = simpson(y, h)
simps_sp = sp.integrate.simpson(y, x)
print("Actual Integral of f from 0 to 1    : {:.6f}".format(actual))
print("Trapezoidal approximation           : {:.6f} (absolute error = {:.6f})".format(trape, abs(trape - actual)))
print("Trapezoidal approximation (scipy)   : {:.6f} (absolute error = {:.6f})".format(trape_sp, abs(trape_sp - actual)))
print("Simpson's approximation             : {:.6f} (absolute error = {:.6f})".format(simps, abs(simps - actual)))
print("Simpson's approximation (scipy)     : {:.6f} (absolute error = {:.6f})".format(simps_sp, abs(simps_sp - actual)))
