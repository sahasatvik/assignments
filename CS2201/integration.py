#!/usr/bin/env python3

import numpy as np

def rectangular(y, step):
    '''
    Returns the rectangular approximation of the integral under the curve
    whose points are (x_i, y_i) where x_i are equally spaced by step.
    '''

    return step * np.sum(y[:-1])    # Remove the endpoint

def trapezoidal(y, step):
    '''
    Returns the trapezoidal approximation of the integral under the curve
    whose points are (x_i, y_i) where x_i are equally spaced by step.
    '''

    return step * (np.sum(y) - (y[0] + y[-1]) / 2)

def simpson(y, step):
    '''
    Returns the trapezoidal approximation of the integral under the curve
    whose points are (x_i, y_i) where x_i are equally spaced by step.
    '''

    # Must have an odd number of points
    if len(y) % 2 == 0:
        return
    return step / 3 * (y[0] + 4 * np.sum(y[1:-1:2]) + 2 * np.sum(y[2:-1:2]) + y[-1])

def f(x):
    '''
    The function generating the curve.
    '''

    return x**2

x, h = np.linspace(0, 10, 101, retstep=True)
y = f(x)
print("Integral of x^2 from 0 to 10 : {:.4f}".format(10 ** 3 / 3))
print("Rectangular approximation : {:.4f}".format(rectangular(y, h)))
print("Trapezoidal approximation : {:.4f}".format(trapezoidal(y, h)))
print("Simpson's approximation   : {:.4f}".format(simpson(y, h)))
