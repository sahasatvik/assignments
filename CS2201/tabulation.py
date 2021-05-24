#!/usr/bin/env python3

import numpy as np

'''
Finding the intervals in which a function has roots using tabulation.
'''

def tabulation(f, lo, hi, n):
    '''
    Yields intervals which contain roots of the function f. A total of n
    intervals of equal length within [lo, hi] will be considered.
    '''

    # Create the n + 1 points demarcating the intervals
    points = np.linspace(lo, hi, n + 1)
    # Calculate f at each of these points
    values = f(points)
    for i in range(n):
        # Root found if f changes sign within the interval
        if values[i] * values[i + 1] <= 0:
            yield points[i], points[i + 1]

def f(x):
    return 10**x + x - 4

if __name__ == '__main__':
    # Display all intervals containing roots to the console
    for interval in tabulation(f, 0, 1, 10):
        print(f"Root present in the interval [{interval[0]}, {interval[1]}]")
