#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy import optimize

cos2 = lambda x, a, b, c: a + b * np.cos(x - c)**2
cos4 = lambda x, a, b, c: a + b * np.cos(x - c)**4
coscos = lambda x, a, b, c, d, e, f: (a + b * np.cos(x - c)) * (d + e * np.cos(x - f))

sheets = pd.read_excel('data.xlsx', sheet_name=None)
polarisers = ['Polariser I', 'Polariser II']
waveplates = ['Waveplate I', 'Waveplate II']

for name in polarisers:
    sheet = sheets[name]
    angle, intensity = sheet['Angle'], sheet['Intensity']
    coeff2, cov2 = optimize.curve_fit(cos2, angle, intensity)
    coeff4, cov4 = optimize.curve_fit(cos4, angle, intensity)
    plt.scatter(angle, intensity, label=name, s=12)
    plt.plot(angle, cos2(angle, *coeff2), '-r', label="Fit to $a + b\cos^2(x - c)$")
    plt.plot(angle, cos4(angle, *coeff4), '--g', label="Fit to $a + b\cos^4(x - c)$")
    print(coeff2, np.sqrt(np.diag(cov2)))
    plt.xlabel("Angle (rad)")
    plt.ylabel("Intensity (percentage of total)")
    plt.legend(loc="lower right")
    plt.show()
    
    a, b, c = coeff2
    x = np.linspace(-1, 1, 100)
    normalized = (intensity - a) / b
    plt.scatter(np.cos(angle - c), normalized, label='Normalized intensity vs $\cos(x - c)$', s=12)
    plt.plot(x, x**2, '-r')
    plt.scatter(np.cos(angle - c) ** 2, normalized, label='Normalized intensity vs $\cos^2(x - c)$', s=12)
    plt.plot(x[x > 0], x[x > 0], '-g')
    plt.xlabel("$\cos\\theta$ and $\cos^2\\theta$")
    plt.ylabel("Normalized intensity")
    plt.legend()
    plt.show()


for name in waveplates:
    sheet = sheets[name]
    angle, intensity = sheet['Angle'], sheet['Intensity']
    coeff, cov = optimize.curve_fit(coscos, angle, intensity)
    plt.scatter(angle, intensity, label=name, s=12)
    plt.plot(angle, coscos(angle, *coeff), '-r', label="Fit to $(a + b\cos(x - c))(d + e\cos(x - f))$")
    print(coeff, np.sqrt(np.diag(cov)))
    plt.xlabel("Angle (rad)")
    plt.ylabel("Intensity (percentage of total)")
    plt.legend(loc="lower right")
    plt.show()
