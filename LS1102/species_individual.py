#!/usr/bin/env python

from os import sys
from statistics import stdev
import random
import math

data = map(int, sys.argv[1:])
n = sum(data)

individuals = []
for i, frequency in enumerate(data):
    individuals += [i] * frequency

def count_unique(l):
    return len(set(l))

trials = 50
for i in range(2, n + 2, 2):
    counts = []
    for j in range(trials):
        counts.append(count_unique(random.sample(individuals, i)))
    s = stdev(counts)
    if s == 0:
        s = 1e-12
    print '{}\t{}\t{}'.format(i, 1.0 * sum(counts) / trials, s)
