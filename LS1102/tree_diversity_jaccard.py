#!/usr/bin/env python

from os import sys
import random

with open(sys.argv[1]) as data:
    lines = data.readlines()

side = 500
n = 20

squares = []
for i in range(n):
    row = []
    for j in range(n):
        row.append(set())
    squares.append(row)

for line in lines:
    d = line.rstrip('\n').split('\t')
    x, y = float(d[2]), float(d[3])
    i, j = int(x * n / side), int(y * n / side)
    squares[i][j].add(d[1])

for i1 in range(n):
    for j1 in range(n):
        for i2 in range(n):
            for j2 in range(n):
                s1 = squares[i1][j1]
                s2 = squares[i2][j2]
                a = len(s1 & s2)
                b = len(s1 - s2)
                c = len(s2 - s1)
                fi1 = i1 + 2 * random.random() - 1
                fj1 = j1 + 2 * random.random() - 1
                fi2 = i2 + 2 * random.random() - 1
                fj2 = j2 + 2 * random.random() - 1
                dist = ((fi1 - fi2)**2 + (fj1 - fj2)**2) ** 0.5 * side / n
                if a + b + c == 0:
                    index = 0
                else:
                    index = float(a) / float(a + b + c)
                print dist, index
