#!/usr/bin/env python3

import numpy as np

'''
Denote the number of blueberries, cranberries, strawberries as (b, c, s).
Given :
    3b +  c +  s = 30
     b + 3c +  s = 20
     b +  c + 3s = 20
'''

# Store the coefficients and data of the system as arrays
coefficients = np.array([[3, 1, 1], [1, 3, 1], [1, 1, 3]])
values = np.array([30, 20, 20])

# Calculate determinant to ensure that the system is not singular
determinant = np.linalg.det(coefficients)
if abs(determinant) < 1e-5:
    print("Singular matrix! Cannot solve.")
else:
    b, c, s = np.linalg.solve(coefficients, values)
    print(f"The number of blueberries, cranberries, and strawberries is {b}, {c}, and {s}.")
