#!/usr/bin/env python2

# Calculates the mean and standard deviation of piped input.
#
# Usage example:
#   cat data | ./mean_std.py
#
# data      file containing list of values on separate lines

from os import sys

data = map(float, sys.stdin)
n = len(data)
s = sum(data)
m = s / n
v = sum((x - m)**2 for x in data) / (n - 1)
d = v ** 0.5

print '%16f %16f' % (m, d)
