#!/usr/bin/env python3

import numpy as np

'''
Finding roots of a function using the Newton-Raphson iterative method.
'''

def newton_raphson(f, df, x_0, epsilon=0.001, maxiter=100):
    '''
    Returns the approximate location of a root of the function f, which is
    assumed to contain exactly one root in the neighbourhood of the inital
    guess x_0. The allowed residue is epsilon, and a maximum of maxiter
    iterations will be executed.
    '''

    for i in range(maxiter):
        # Exit if the residue is within tolerance
        if abs(f(x_0)) < epsilon:
            return x_0, i
        x_0 -= f(x_0) / df(x_0)
    return x_0, maxiter

def derive(f, h=1e-6):
    '''
    Returns a function which numerically approximates the derivative of f.
    '''

    return lambda x: (f(x + h) - f(x)) / h
    
def f(x):
    return 10**x + x - 4
def df(x):
    return 10**x * np.log(10) + 1

if __name__ == '__main__':
    # Display the approximate root
    root, i = newton_raphson(f, df, 0.5, epsilon=1e-6)
    print(f"Root at {root}, f(x) = {f(root)}, {i} iterations")

    # Use a numerical approximation of the derivative
    root, i = newton_raphson(f, derive(f), 0.5, epsilon=1e-6)
    print(f"Root at {root}, f(x) = {f(root)}, {i} iterations")
