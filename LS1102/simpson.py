#!/usr/bin/env python

from os import sys
import math

data = map(int, sys.argv[1:])
n = sum(data)
d = 0

for x in data:
    p = x * 1.0 / n
    d += p*p

print d
