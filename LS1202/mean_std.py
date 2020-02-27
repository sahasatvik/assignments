#!/usr/bin/env python2

from os import sys

data = map(float, sys.stdin)
n = len(data)
s = sum(data)
m = s / n
v = sum((x - m)**2 for x in data) / (n - 1)
d = v ** 0.5

print '%16f %16f' % (m, d)
