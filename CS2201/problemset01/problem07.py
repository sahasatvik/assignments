#!/usr/bin/env python3

"""
Store the marks of five courses CS1101, CH2201, CS3201, CS3202 and LS2201 in a
tuple ‘marks’. Update ‘marks’ by adding grace marks of 5 for the marks less
than 50.
"""

courses = ("CS1101", "CS2202", "CS3201", "CS3202", "LS2201")
marks = (55, 45, 42, 60, 50)

print("Old marks : ", marks)

marks = tuple(m + 5 if m < 50 else m for m in marks)
print("New marks : ", marks)
