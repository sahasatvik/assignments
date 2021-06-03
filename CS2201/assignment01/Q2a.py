#!/usr/bin/env python3

import numpy as np

def get_vec(length):
    '''
    Gets a vector of given length from the user.
    '''

    entries = input(f"Enter {length} numbers: ").split()
    numbers = map(float, entries)
    return np.array(list(numbers))

def dot(a, b, n):
    '''
    Calculates the dot product of two vectors of length n.
    '''

    total = 0
    for i in range(n):
        total += a[i] * b[i]
    return total

if __name__ == '__main__':
    n = int(input("Enter the dimension of each vector: "))
    A = get_vec(n)
    B = get_vec(n)

    print("Dot product: " + str(dot(A, B, n)))
