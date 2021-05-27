#!/usr/bin/env python3

"""
Write a program to print out a list containing all the colors from color_list_1
which are not present in color_list_2.
"""

color_list_1 = ["red", "green", "blue", "purple"]
color_list_2 = ["red", "yellow", "orange", "blue"]

colors = [c for c in color_list_1 if c not in color_list_2]

print("List 1 : ",  color_list_1)
print("List 2 : ",  color_list_2)
print("Colors from list 1 not in list 2", colors)
