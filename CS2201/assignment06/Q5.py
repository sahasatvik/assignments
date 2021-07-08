#!/usr/bin/env python3

from random import random

# Prepare lists of possible ascii codes
numbers = list(range(ord('0'), ord('9') + 1))
lower   = list(range(97, 123))
upper   = list(range(65, 91))

def choose(items):
    '''
    Chooses an item from 'items' randomly, with uniform distribution
    '''

    n = len(items)
    r = random()
    for i, item in enumerate(items):
        if r <= (i + 1) / n:
            return item


captcha = ""
for i in range(4):
    type_ = choose([numbers, lower, upper]) # choose a type
    chr_  = choose(type_)                   # choose a character from that type
    captcha += chr(chr_)

print(captcha)
