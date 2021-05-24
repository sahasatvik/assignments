#!/usr/bin/env python3

'''
Finding roots of a function using the method of successive bisection.
'''

def bisection(f, lo, hi, delta=0.001, maxiter=100):
    '''
    Returns the approximate location of a root of the function f, which is
    assumed to contain exactly one root in the interval [lo, hi]. The allowed
    error in the root is delta, and a maximum of maxiter iterations will be
    executed.
    '''

    # Check that a root does indeed lie within the interval
    if f(lo) * f(hi) > 0:
        return None, None
    for i in range(maxiter):
        x = (lo + hi) / 2
        # Exit if the interval is smaller than delta
        if (hi - lo) <= delta:
            return x, i
        # Halve the size of the interval, based on where the root lies
        if f(lo) * f(x) <= 0:
            hi = x
        else:
            lo = x
    
def f(x):
    return 10**x + x - 4

if __name__ == '__main__':
    # Display the approximate root
    root, i = bisection(f, 0, 1, delta=1e-6)
    if root is not None:
        print(f"Root at {root}, f(x) = {f(root)}, {i} iterations")
