#!/usr/bin/env python3

import sys

d = {1 : 'ONE', 2 : 'TWO', 3 : 'THREE', 4 : 'FOUR', 5 : 'FIVE', 6 : 'SIX', 7 : 'SEVEN', 8 : 'EIGHT', 9 : 'NINE'}
p = {3 : 'HUNDRED', 4 : 'THOUSAND'}
t = {2 : 'TWENTY', 3 : 'THIRTY', 4 : 'FORTY', 5 : 'FIFTY', 6 : 'SIXTY', 7 : 'SEVENTY', 8 : 'EIGHTY', 9 : 'NINETY'}

number = input("Enter a positive (maximum 4 digit) integer : ")

# Verify that the input has at most 4 digits
if len(number) > 4:
    print("Invalid input!")
    sys.exit()

# Verify that the input is indeed a number
for n in number:
    if n not in '0123456789':
        print("Invalid input!")
        sys.exit()

# Pad the beginning with zeroes if necessary
number = '0' * (4 - len(number)) + number
words = ''

# thousands, hundreds, tens, ones = list(number)
# if thousands != '0':
#     words += d[int(thousands)] + ' ' + p[4] + ' '
# if hundreds != '0':
#     words += d[int(hundreds)] + ' ' + p[3] + ' '
# if tens != '0':
#     if tens == '1':
#         print("Invalid input!")
#         sys.exit()
#     words += t[int(tens)] + ' '
# if ones != '0':
#     words += d[int(ones)]

# Loop over the digits
for i, n in zip(range(4, 0, -1), number):
    # Do nothing if the digit is a zero
    if n == '0':
        continue
    # Special case for the tens place
    if i == 2:
        # Cannot handle the teens
        if n == '1':
            print("Invalid input!")
            sys.exit()
        words += ' ' + t[int(n)]
    else:
        words += ' ' + d[int(n)]
        # Add the hundreds/thousands qualifier if available
        if i in p:
            words += ' ' + p[i]
words = words.strip()


print(words)
