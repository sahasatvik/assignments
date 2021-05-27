#!/usr/bin/env python3

"""
Write a program that takes an integer as input and outputs whether the input is
a prime number or not. DO NOT use any module (e.g. sympy).
"""

def prime(n):
    if n < 2:
        return False
    if n == 2 or n == 3:
        return True
    for i in range(2, n):
        if (n % i) == 0:
            return False
    return True

number = int(input("Enter a positive integer : "))
if prime(number):
    print("Prime!")
else:
    print("Not prime!")
