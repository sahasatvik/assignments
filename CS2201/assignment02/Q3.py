#!/usr/bin/env python3

import numpy as np

def complement(bit):
    '''
    Returns the complementary bit. Bit must be 0 or 1.
    '''
    return 1 - bit

I = np.array([1, 0, 1, 0, 0, 0, 1, 1])
J = complement(I)
print("Original   : ", I)
print("Complement : ", J)
