#!/usr/bin/env python

# Calculates species-individual curve data by repeated, random sampling.

# Usage:
#   ./species_individual.py trials step [frequencies]
#
# trials        number of trials for a given sample size
# step          incremenent of sample size
# frequencies   list (space separated) of frequencies of species

from os import sys
from statistics import stdev
import random
import math

trials = int(sys.argv[1])
step = int(sys.argv[2])
data = map(int, sys.argv[3:])
n = sum(data)

individuals = []
for i, frequency in enumerate(data):
    individuals += [i] * frequency

def count_unique(l):
    return len(set(l))

for i in range(step, n, step):
    counts = []
    for j in range(trials):
        counts.append(count_unique(random.sample(individuals, i)))
    s = stdev(counts)
    if s == 0:
        s = 1e-12
    print '{}\t{}\t{}'.format(i, 1.0 * sum(counts) / trials, s)
