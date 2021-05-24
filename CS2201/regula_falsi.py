#!/usr/bin/env python3

'''
Finding roots of a function using the method of false position.
'''

def regula_falsi(f, lo, hi, epsilon=0.001, maxiter=100):
    '''
    Returns the approximate location of a root of the function f, which is
    assumed to contain exactly one root in the interval [lo, hi]. The allowed
    residue is epsilon, and a maximum of maxiter iterations will be executed.
    '''
    
    if f(lo) * f(hi) > 0:
        return None, None
    for i in range(maxiter):
        x = hi - f(hi) * (hi - lo) / (f(hi) - f(lo))
        # Exit if the residue is within tolerance
        if abs(f(x)) < epsilon:
            return x, i
        if f(lo) * f(x) < 0:
            hi = x
        else:
            lo = x
    return x, maxiter
    
def f(x):
    return 10**x + x - 4

if __name__ == '__main__':
    # Display the approximate root
    root, i = regula_falsi(f, 0, 1, epsilon=1e-6)
    if root is not None:
        print(f"Root at {root}, f(x) = {f(root)}, {i} iterations")
