#!/usr/bin/env python

from os import sys

data = map(float, sys.stdin)
n = sum(data)

m = max(data)

def in_class(i, x):
    return x >= (i) and x < (i + 1)

i = 0
while i <=  m:
    print '%d-%d\t %d' % (i, i + 1, len(filter(lambda x: in_class(i, x), data)))
    i += 1
