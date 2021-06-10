#!/usr/bin/env python3

original = input("Enter a space separated list (e.g. 1 2 2 3) : ").split()

# Populate a list of repeats
repeats = []
for i, n in enumerate(original):
    # An element is repeated if it appears in the list which excludes itself.
    # Also, ensure that we haven't already captured this element.
    if n in original[:i] + original[i+1:] and n not in repeats:
        repeats.append(n)

print(repeats)
