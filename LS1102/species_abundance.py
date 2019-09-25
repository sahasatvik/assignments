#!/usr/bin/env python

from os import sys

data = map(int, sys.argv[1:])
n = sum(data)

m = max(data)

def in_class(i, x):
    return x >= (2 ** i) and x < (2 ** (i + 1))

i = 0
while 2 ** i <  m:
    print i, len(filter(lambda x: in_class(i, x), data))
    i += 1
