#!/usr/bin/env python3

import sys

s1 = input("Enter the first bit string  : ")
s2 = input("Enter the second bit string : ")

# Ensure that the strings are of the same length
if len(s1) != len(s2):
    print("Strings must be of the same length!")
    sys.exit()

n = len(s1)
p = int(input(f"Enter the crossover point p (between {0} and {n-1}) : "))

# Ensure that the crossover point is within the strings
if p >= 0 and p < n:
    # Swap substrings from index 'p' (inclusive) onwards
    s1, s2 = s1[:p] + s2[p:], s2[:p] + s1[p:]
    print("Updated first bit string    : " + s1)
    print("Updated second bit string   : " + s2)
else:
    print("Invalid position!")
