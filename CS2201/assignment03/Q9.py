#!/usr/bin/env python3

L1 = input("Enter the first list of space separated words  : ").split()
L2 = input("Enter the second list of space separated words : ").split()

L3 = []
for i in L1 + L2:
    # Ignore repeats
    if i in L3:
        continue
    # The condition can be written out explicitly
    if (i in L1 and i not in L2) or (i not in L1 and i in L2):
        L3.append(i)

print(L3)
