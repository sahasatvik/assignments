#!/usr/bin/env python3

n = int(input("Enter a positive integer : "))

# Loop over 0, 1, 2, ..., n - 1, n, n - 1, ..., 1, 0
for i in list(range(n)) + list(range(n, -1, -1)):
    # There are n - i blank spaces per line
    blanks = (n - i) * ' '
    # The numbers run from 1, ..., i
    numbers = map(lambda n: str(n + 1), range(i))
    # Alternate the stars among the numbers
    stars_numbers = ''.join('*' + n for n in numbers) + '*'
    print(blanks + stars_numbers)
