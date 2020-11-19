#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy import optimize

q_e = 1.60217662e-19
V = lambda f, h, phi: h * f / q_e - phi
I = lambda r, k, I_0: k / r**2 + I_0

sheets = pd.read_excel('data.xlsx', sheet_name=None)
potentials, currents = sheets['Potential'], sheets['Current']

frequency, stopping_V = potentials['Frequency'], -potentials['Stopping potential']
frequency *= 1e14

coeff, cov = optimize.curve_fit(V, frequency, stopping_V)
h, phi = coeff
plt.scatter(frequency, stopping_V, label="Retarding potential")
plt.plot(frequency, V(frequency, *coeff), '-r', label="Linear fit, $V = h\\nu / e - \phi$")
plt.xlabel("Frequency $\\nu$ (Hz)")
plt.ylabel("Retarding potential (V)")
plt.legend()
plt.show()

print(coeff, np.sqrt(np.diag(cov)))

wavelength_rgba = {
    635: (1.0, 0.22370171555399954, 0.0, 1.0),
    570: (0.8839802626950386, 1.0, 0.0, 1.0),
    540: (0.5077133368038188, 1.0, 0.0, 1.0),
    500: (0.0, 0.6, 0.5743491774985174, 1.0),
    460: (0.0, 0.4804497735925725, 1.0, 1.0)
}

fig, (ax1, ax2) = plt.subplots(1, 2)
for w in wavelength_rgba:
    data = currents[currents['Filter'] == w]
    distance = data['Distance'] * 1e-2
    current = data['Current'] * 1e-6
    coeff, cov = optimize.curve_fit(I, distance, current)
    ax1.scatter(distance, current, color=wavelength_rgba[w], label=str(w) + ' nm')
    ax2.scatter(1 / distance**2, current, color=wavelength_rgba[w])
    x = np.linspace(min(distance), max(distance), 100)
    ax1.plot(x, I(x, *coeff), linestyle='--', color=wavelength_rgba[w])
    ax2.plot(1 / x**2, I(x, *coeff), linestyle='--', color=wavelength_rgba[w])
    print(w, coeff, np.sqrt(np.diag(cov)))

fig.suptitle("Fits to $I = I_0 + k /r^2$")
ax1.set(xlabel = "Distance $r$ ($m$)", ylabel="Current $I$ ($A$)")
ax2.set(xlabel = "Inverse squared distance $1 / r^2$ ($m^{-2}$)")
fig.legend(loc="right")
plt.show()
