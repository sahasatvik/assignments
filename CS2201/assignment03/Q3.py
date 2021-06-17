#!/usr/bin/env python3

import numpy as np

def b2d(binary):
    '''
    Takes a 'binary' number (int with only 0, 1 as digits) and returns
    the decimal equivalent.
    '''

    decimal = 0
    power = 0
    while binary > 0:
        decimal += (binary % 10) * (2 ** power)
        binary //= 10
        power += 1
    return decimal

numpy_BinaryToDecimal = np.frompyfunc(b2d, 1, 1)
A = np.array([1, 10, 11, 100, 101])
B = numpy_BinaryToDecimal(A)
print("Binary numbers  : ", A)
print("Decimal numbers : ", B)
