#!/usr/bin/env python

from os import sys

with open(sys.argv[1]) as data:
    lines = data.readlines()

corners = []
for i in range(4):
    corners.append(set())

for line in lines:
    d = line.rstrip('\n').split('\t')
    x, y = float(d[2]), float(d[3])
    if x < 50 and y < 50:
        corners[0].add(d[1])
    elif x > 450 and y < 50:
        corners[1].add(d[1])
    elif x < 50 and y > 450:
        corners[3].add(d[1])
    elif x > 450 and y > 450:
        corners[2].add(d[1])

for i, c1 in enumerate(corners):
    for j, c2 in enumerate(corners):
        print '{:.4}\t'.format(float(len(c1 & c2)) / float(len(c1 | c2))),
    print
