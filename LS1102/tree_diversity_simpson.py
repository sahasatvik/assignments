#!/usr/bin/env python

from os import sys
from collections import Counter
import simpson

with open(sys.argv[1]) as data:
    lines = data.readlines()

side = 500
n = 20

squares = []
for i in range(n):
    row = []
    for j in range(n):
        row.append([])
    squares.append(row)

for line in lines:
    d = line.rstrip('\n').split('\t')
    x, y = float(d[2]), float(d[3])
    i, j = int(x * n / side), int(y * n / side)
    squares[i][j].append(d[1])

for i, row in enumerate(squares):
    for j, species in enumerate(row):
        print i, j, 1 - simpson.simpson(Counter(species).values())
