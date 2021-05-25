#!/usr/bin/env python3

from bisection import bisection
from regula_falsi import regula_falsi
from newton_raphson import newton_raphson, derive

'''
A crude approximation of π by finding the root of the sine function which lies
between 3 and 4. The sine function itself has been approximated as a partial
sum of its Taylor series around 0.
'''

TERMS = 16
DELTA = 1e-12
EPSILON = 1e-12

def sin(x):
    term = x
    total = x
    for n in range(TERMS):
        term *= -1 * x * x / ((2 * n + 2) * (2 * n + 3))
        total += term
    return total

if __name__ == '__main__':
    pi, iterations = bisection(sin, 3, 4, delta=DELTA)
    print(f"BISECTION      : pi = {pi}, tolerance {DELTA}, {iterations} iterations")

    pi, iterations = regula_falsi(sin, 3, 4, epsilon=EPSILON)
    print(f"REGULA-FALSI   : pi = {pi}, tolerance {EPSILON}, {iterations} iterations")

    pi, iterations = newton_raphson(sin, derive(sin), 3, epsilon=EPSILON)
    print(f"NEWTON-RAPHSON : pi = {pi}, tolerance {EPSILON}, {iterations} iterations")
