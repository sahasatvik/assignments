#!/usr/bin/env python3

"""
Write a program to find the digits which are absent in a given mobile number.
"""

all_digits = "0123456789"

mobile = input("Enter your mobile number : ")
missing_digits = [d for d in all_digits if d not in mobile]
print("Missing digits : " + "".join(missing_digits))
