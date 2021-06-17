#!/usr/bin/env python3

number = int(input("Enter a positive integer : "))

# It is more efficient (?) to pre-compute a dictionary of possible cubes,
# and their corresponding roots.
cubes = dict()
for i in range(1, number):
    # Break when the cube exceeds the number itself
    if i**3 > number:
        break
    cubes[i**3] = i


solutions = []
# Only iterate over potential cubes
for cube in cubes:
    difference = number - cube
    # n = a^3 + b^3 only if n - a^3 is a cube
    if cube < difference and difference in cubes:
        solutions.append((cubes[cube], cubes[difference]))

if len(solutions) > 1:
    print("Ramanujan number!")
    print(solutions)
else:
    print("Not a Ramanujan number.")
