#!/usr/bin/env python3

"""
Consider three strings str1 = ‘123’, str2 = ‘234’ and str3 = ‘456’ and print
the sum, product and average of the numbers in the strings.
"""

str1 = "123"
str2 = "234"
str3 = "456"

def sum_digits(s):
    total = 0
    for digit in s:
        total += int(digit)
    return total

def prod_digits(s):
    product = 1
    for digit in s:
        product *= int(digit)
    return product

def mean_digits(s):
    return sum_digits(s) / len(s)

for s in [str1, str2, str3]:
    print(f"Sum of digits in {s} is {sum_digits(s)}")
    print(f"Product of digits in {s} is {prod_digits(s)}")
    print(f"Average of digits in {s} is {mean_digits(s)}")
    print()
