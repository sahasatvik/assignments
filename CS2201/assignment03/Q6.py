#!/usr/bin/env python3

n = int(input("Enter a positive integer n : "))

# Total 'n' lines
for i in range(n):
    # n - i entries per line
    for j in range(n - i):
        print(str(j + 1) + " ", end="")
    print()
