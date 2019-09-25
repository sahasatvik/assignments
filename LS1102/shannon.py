#!/usr/bin/env python

# Usage
#   ./shannon.py [frequencies]
#
# frequencies   list (space separated) of frequencies of species

from os import sys
import math

data = map(int, sys.argv[1:])
n = sum(data)
h = 0

for x in data:
    p = x * 1.0 / n
    h += p * math.log(p)

print -h
