#!/usr/bin/env python

# Calculates the simpson index of diversity for given data.

# Usage:
#   ./simpson.py [frequencies]
#
# frequencies   list (space separated) of frequencies of species

from os import sys
import math

def simpson(data):
    n = sum(data)
    d = 0

    for x in data:
        p = x * 1.0 / n
        d += p*p

    return d

if __name__ == '__main__':
    data = map(int, sys.argv[1:])
    print simpson(data)
