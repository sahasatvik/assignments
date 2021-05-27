#!/usr/bin/env python3

"""
Input your IISER email in format name-rollno@iiserkol.ac.in, extract the name,
roll no using split() and print them.
"""

email = input("Enter your email in the format name-rollno@iiserkol.ac.in : ")
try:
    name_roll, domain = email.split("@")
    name, rollno = name_roll.split("-")
    print(f"Your name is {name}, your roll number is {rollno}.")
except ValueError:
    print("Invalid format!")
