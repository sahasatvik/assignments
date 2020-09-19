#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import pandas as pd
import matplotlib.pyplot as plt
from os import sys

filename = sys.argv[1]
zoom = 1.0                                              # Zoom factor for x axis
if len(sys.argv) > 2:
    zoom = float(sys.argv[2])

data = pd.read_excel(filename)                          # Read data from file
intensity, displacement = list(data.columns)            # Extract columns
intensities = data[intensity]
displacements = data[displacement]

scale_factor = 0.05 / 0.0946                            # Calculate scale factor
displacements *= scale_factor                           # Scale displacements
intensities /= intensities.max()                        # Normalize intensities

maxima_position = displacements[intensities.idxmax()]   # Get maxima position
displacements -= maxima_position                        # Centre the maxima

max_displacement = displacements.abs().max()
x_limit = max_displacement / zoom                       # Limit for x axis

plt.plot(displacements, intensities)                    # Plot columns
plt.xlabel("Displacement (metres)")
plt.ylabel("Intensity (normalized)")
plt.axis((-x_limit, +x_limit, -0.05, +1.05))            # Set axis limits
plt.show()
