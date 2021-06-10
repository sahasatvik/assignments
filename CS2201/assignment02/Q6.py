#!/usr/bin/env python3

import numpy as np

# Formatting the array helps visually
arr = np.array([
                    [
                        [1, 2, 3],
                        [4, 5, 6]
                    ],
                    [
                        [7, 8, 9],
                        [10, 11, 12]
                    ]
                ])

# Take elements from both blocks,
# only from the first line of each block,
# and only the 0th and 2nd column of each line.
sliced = arr[:, 1, [0, 2]]
print(sliced)
