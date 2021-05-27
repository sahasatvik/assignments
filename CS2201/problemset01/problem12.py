#!/usr/bin/env python3

import numpy as np

"""
(a) Write a python code to do tabular root finding from a starting interval [0, 1]
for step lengths = 0.1, 0.01, 0.001 for f(x) = e^x - 5. You should write a
function ‘tabular(a, b, steplen)’ and call it to find the desired interval.
(b) Use the above function tabular() to get the initial interval and pass it to
another function Newton-Raphson() the find the root for f(x) = ex - 5.
(c) Replace the derivative function above by the one that computes the
derivative (df) using the following formula (chose h as a small float number)
and use it to find the root using the Newton-Raphson() functon.
    
    df(x) = \lim_{h -> 0} (f(x + h) - f(x)) / h

"""

def f(x):
    return np.exp(x) - 5
def df(x):
    return np.exp(x)
def df_numeric(x, h = 1e-6):
    return (f(x + h) - f(x)) / h

def tabular(a, b, steplen):
    # Sanity check
    if f(a) * f(b) > 0:
        return None, None
    # Create arrays of points and functional values
    points = np.arange(a, b + steplen, steplen)
    values = f(points)
    for i in range(len(points) - 1):
        if values[i] == 0:
            return points[i], None
            break
        if values[i] * values[i + 1] < 0:
            return points[i], points[i + 1]
            break
    return None, None

def newton_raphson(f, df, x_0, tolerance = 1e-12, maxiter = 100):
    for i in range(maxiter):
        if abs(f(x_0)) < tolerance:
            break
        x_0 -= f(x_0) / df(x_0)
    return x_0

# Note that f(0) = -4, f(3) = e**3 - 5 > 2**3 - 5 >= 3
# Refine the interval containing the root successively
left, right = tabular(0, 3, 0.1)
left, right = tabular(left, right, 0.01)
left, right = tabular(left, right, 0.001)

print(f"Root in interval {left:.3f}, {right:.3f}")
print()

root = newton_raphson(f, df, left)
root_numeric_derivative = newton_raphson(f, df_numeric, left)
print(f"Root at {root} using the analytic derivative, f(x) = {f(root)}")
print(f"Root at {root_numeric_derivative} using the numeric derivative, f(x) = {f(root_numeric_derivative)}")
print()

print("Set a lower tolerance of 1e-16")
root = newton_raphson(f, df, left, tolerance = 1e-16)
root_numeric_derivative = newton_raphson(f, df_numeric, left, tolerance = 1e-16)
print(f"Root at {root} using the analytic derivative, f(x) = {f(root)}")
print(f"Root at {root_numeric_derivative} using the numeric derivative, f(x) = {f(root_numeric_derivative)}")
