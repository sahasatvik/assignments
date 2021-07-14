#!/usr/bin/env python3

from functools import cache
import numpy as np

@cache
def binom(n, k):
    if k > n / 2:
        return binom(n, n - k)
    if k == 0:
        return 1
    return binom(n - 1, k - 1) * n // k

def bernstein_poly(n, k):
    def p(x):
        return binom(n, k) * x**k * (1 - x)**(n - k)
    return p

def bernstein(f, n):
    def p(x):
        terms = [bernstein_poly(n, k)(x) * f(k / n) for k in range(0, n + 1)]
        return np.sum(terms, axis=0)
    return p

if __name__ == '__main__':
    import matplotlib.pyplot as plt
    DEGREE = 8
    colors = plt.get_cmap('Blues')(np.linspace(0.2, 1, DEGREE + 1))
    
    x = np.linspace(0, 1, 100)
    for k, c in zip(range(DEGREE + 1), colors):
        plt.plot(x, bernstein_poly(DEGREE, k)(x), color=c)
    plt.title(f"Bernstein polynomials of degree {DEGREE}")
    plt.xlim(0, 1)
    plt.show()
