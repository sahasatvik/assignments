#!/usr/bin/env python3

# Store data
years = [2009, 2010, 2011, 2012, 2013, 2015]
rainfall = [166.6, 473.2, 426.7, 318.3, 389.5, 458.5]

target = 2014
interp = 0.0

# Perform Lagrangian interpolation

for i, y_i in enumerate(years):
    term = rainfall[i]
    for j, y_j in enumerate(years):
        if i == j:
            continue
        term *= (target - y_j) / (y_i - y_j)
    interp += term

print("Rainfall for the year {} is {} mm.".format(target, interp))
