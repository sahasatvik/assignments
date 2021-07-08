#!/usr/bin/env python3

# Tree structure
menu = {
    0: [1, 2],
    1: [3, 4],
    2: [5, 6],
    3: [7, 8],
    4: [9, 10],
    5: [11],
    6: [12, 13]
}

# Node labels
names = [
    "Welcome to Festa Italiana",
    "Pizza",
    "Pasta",
    "Veg",
    "Non Veg",
    "Veg",
    "Non Veg",
    "Peppy Paneer",
    "Cheese-Corn",
    "Barbeque",
    "Supreme",
    "Latin white sauce",
    "Bolonese Chicken",
    "Lasagna"
]

current = 0
# Iterate until a leaf is reached
while current in menu:
    print(names[current])
    choices = menu[current]
    # No options
    if len(choices) == 1:
        current = choices[0]
        continue
    s = ', '.join(str(i) + ' for ' + names[c] for i, c in enumerate(choices))
    n = int(input("Give " + s + " : "))
    if n not in range(len(choices)):
        print("Invalid choice! Try again.")
        continue
    # Update current node
    current = choices[n]

print("Enjoy your {}!".format(names[current]))
