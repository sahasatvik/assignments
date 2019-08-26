#!/usr/bin/env python

from os import sys
import random
import math

data = map(int, sys.argv[1:])
n = sum(data)

individuals = []
for i, frequency in enumerate(data):
    individuals += [i] * frequency

def count_unique(l):
    return len(set(l))

for i in range(5, n, 5):
    s = []
    for j in range(10):
        s.append(count_unique(random.sample(individuals, i)))
    print '{}\t{}'.format(i, sum(s) / 10.0)
