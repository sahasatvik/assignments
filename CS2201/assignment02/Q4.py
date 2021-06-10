#!/usr/bin/env python3

# Favourable outcomes must have heads on the coin, and an even number
# on the die. This limits the possibilities to tuples of the form 
# ('H', n), where 'n' is even.
favourable = [('H', n) for n in [2, 4, 6]]
print("Favourable outcomes : ", favourable)
