#!/usr/bin/env python

# Calculates the shannon index of diversity for given data.

# Usage:
#   ./shannon.py [frequencies]
#
# frequencies   list (space separated) of frequencies of species

from os import sys
import math

def shannon(data):
    n = sum(data)
    h = 0

    for x in data:
        p = x * 1.0 / n
        h += p * math.log(p)

    return -h

if __name__ == '__main__':
    data = map(int, sys.argv[1:])
    print shannon(data)
