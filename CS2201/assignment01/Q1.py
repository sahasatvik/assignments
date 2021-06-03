#!/usr/bin/env python3

import numpy as np

def regula_falsi(f, lo, hi, epsilon=0.001, maxiter=100):
    '''
    Returns the approximate location of a root of the function f, which is
    assumed to contain exactly one root in the interval [lo, hi]. The allowed
    residue is epsilon, and a maximum of maxiter iterations will be executed.
    '''
    
    if f(lo) * f(hi) > 0:
        return None
    for i in range(maxiter):
        x = hi - f(hi) * (hi - lo) / (f(hi) - f(lo))
        print(f"Iteration {i:3d}, x = {x}, f(x) = {f(x)}")
        # Exit if the residue is within tolerance
        if abs(f(x)) < epsilon:
            return x
        if f(lo) * f(x) < 0:
            hi = x
        else:
            lo = x
    return x
    
def f(x):
    '''
    Function whose root is to be found
    '''

    # Return -1 for arguments where f is undefined
    if x <= 0:
        return -1
    return np.log(x) + 0.5

if __name__ == '__main__':
    # Find the root of f using the method of false position
    root = regula_falsi(f, 0, 1, epsilon=1e-9)
    print(f"Root found at {root}, f(x) = {f(root)}")
