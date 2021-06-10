#!/usr/bin/env python3

# Choose the number of records
n = int(input("Enter the number of people : "))

# Populate a list of the inputs, in the same order as they arrive
info = []
for i in range(n):
    name = input("Enter a name : ")
    age = input("Enter an age : ")
    info.append(name)
    info.append(age)

# The names appear at even indices
names = info[::2]
# The ages appear at odd indices
ages = info[1::2]
# Zip the names and ages as a list of tuples, then parse as a dictionary
names_ages = dict(zip(names, ages))

print("Names and ages : ", names_ages)

