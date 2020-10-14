#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np

# Set constants
wavelength = 650e-9
thickness = 1e-3

# Calculate the refractive index
def n_g(m, theta):
    d1 = 1 - np.cos(theta * np.pi / 180.0)
    d2 = m * wavelength / (2.0 * thickness)
    return d1 * (1 - d2) / (d1 - d2)

# Calculate the propagated error
def err(m, theta):
    xi = np.cos(theta * np.pi / 180.0)
    zeta = m * wavelength / (2.0 * thickness)
    dtheta = 1 * np.pi / 180.0
    dlam = 3e-9
    dt = 0.1e-3

    dxi = np.abs(np.sin(theta * np.pi / 180.0) * dtheta)
    dzeta = zeta * np.sqrt((dlam / wavelength)**2 + (dt / thickness)**2)
    A = zeta * (1 - zeta) / (1 - xi - zeta)**2 * dxi
    B = xi * (1 - xi) / (1 - xi - zeta)**2 * dzeta
    # return np.sqrt(A**2 + B**2)
    return dxi

sheets = pd.read_excel('data.xlsx', sheet_name=None)
for sheet, data in sheets.items():
    fringe, angle, refractive = list(data.columns)
    
    # Set calculated indices and errors
    data[refractive] = n_g(data[fringe], data[angle])
    errors = err(data[fringe], data[angle])
    data.insert(3, 'Error', errors)

    # Output means and standard deviations
    print sheet, np.mean(data[refractive]), np.std(data[refractive])
    for i in [20, 30, 40, 50]:
        print i, np.std(data[data[fringe] == i][angle])
    print np.sqrt(sum(errors**2)) / len(errors)
    print

# Display data in LaTeX tabular format
for sheet, data in sheets.items():
    print sheet
    print data.to_latex(index=False)
