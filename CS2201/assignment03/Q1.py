#!/usr/bin/env python3

import numpy as np

def pseudo_newton_raphson(f, lo, hi, epsilon=0.001, maxiter=100):
    '''
    Returns the approximate location of a root of the function f, in the
    interval [lo, hi]. The allowed residue is epsilon, and a maximum of maxiter
    iterations will be executed.
    '''
    
    if f(lo) * f(hi) > 0:
        return None
    for i in range(maxiter):
        if abs(f(hi)) < epsilon:
            break
        lo, hi = hi, hi - f(hi) * (hi - lo) / (f(hi) - f(lo))
    return hi
    
def f(x):
    '''
    Function whose root is to be found
    '''

    # Return -1 for arguments where f is undefined
    if x <= 0:
        return -1
    return np.log(x) + 0.5


root = pseudo_newton_raphson(f, 0, 1, epsilon=1e-9)
print(f"Root found at {root}, f(x) = {f(root)}")
