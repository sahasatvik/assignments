#!/usr/bin/env python3

"""
(a) Take the name and age of a student as input and store them in a tuple.
(b) Take the same information (name and age) of 10 students and make a list of tuples.
(c) Search: take a name from the user as input and output the corresponding age.
"""

info = []

for i in range(2):
    print(f"Record {i + 1} - ")
    name = input("\tEnter name : ")
    age = input("\tEnter age : ")
    info.append((name, age))

search_name = input("Enter name to search : ")
for name, age in info:
    if name == search_name:
        print(f"Age of {name} is {age}")
        break
else:
    print(f"{search_name} not found!")

# Better way using dictionaries

# info = dict(info)
# age = info.get(search_name, "Not found!")
# print(f"Age : {age}")
