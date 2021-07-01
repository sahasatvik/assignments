#!/usr/bin/env python3

import random
import matplotlib.pyplot as plt

path_x = []
path_y = []

x, y = 0, 0
path_x.append(x)
path_y.append(y)

# Exit when either coordinate is 6 away from the origin
while abs(x) != 6 and abs(y) != 6:
    # Toss two coins, giving four equally likely outcomes
    # (the association between a particular outcome and a direction is irrelevant,
    # since the toss is random, hence we skip generating the 'H'/'T' pairs)
    toss = random.random()
    if toss < 0.25:
        x += 1
    elif toss < 0.5:
        x -= 1
    elif toss < 0.75:
        y += 1
    else:
        y -= 1
    path_x.append(x)
    path_y.append(y)

plt.plot(path_x, path_y, 'o:r')
plt.text(0, 0, 'Start')
plt.text(x, y, 'Stop')
plt.show()
