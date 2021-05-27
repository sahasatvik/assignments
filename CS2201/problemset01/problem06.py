#!/usr/bin/env python3

from random import random

"""
Given the temperatures in Farenheit in a list ‘farenheit’, store the celsius
equivalents in another list ‘celsius’ using list comprehension.
"""

fahrenheit = [random() * 100 for i in range(20)]
celsius = [(f - 32) * 5 / 9 for f in fahrenheit]

print("Fahrenheit    Celsius")
for f, c in zip(fahrenheit, celsius):
    print(f"{f:>10.2f} {c:>10.2f}")
