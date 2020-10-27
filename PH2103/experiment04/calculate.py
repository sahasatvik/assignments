#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np

f = 50.1e6
length_water = 100
length_resin = 29

sheets = pd.read_excel('data.xlsx', header=1, sheet_name=None)

empty, water, resin = sheets['Empty'], sheets['Water'], sheets['Resin']

c_dx = np.mean(empty['x2'] - empty['x1'])
w_dx = np.mean(water['x2'] - water['x1'])
r_dx = np.mean(resin['x2'] - resin['x1'])

c   = 4 * f * c_dx * 1e-2
n_w = 1.0 + 2.0 * w_dx / length_water
n_r = 1.0 + 2.0 * r_dx / length_resin
c_w = c / n_w
c_r = c / n_r

err_f = 0.01e6
err_c_dx = np.std(empty['x2'] - empty['x1'])
err_w_dx = np.std(water['x2'] - water['x1'])
# err_r_dx = np.std(resin['x2'] - resin['x1'])
err_r_dx = 0.5

err_c = c * np.sqrt((err_f / f)**2 + (err_c_dx / c_dx)**2)
err_n_w = n_w * np.sqrt((err_w_dx / w_dx)**2 + (0.5 / length_water)**2)
err_n_r = n_r * np.sqrt((err_r_dx / r_dx)**2 + (0.5 / length_resin)**2)
err_c_w = c_w * np.sqrt((err_c / c)**2 + (err_n_w / n_w)**2)
err_c_r = c_r * np.sqrt((err_c / c)**2 + (err_n_r / n_r)**2)

print 'x2 - x1 (Air):   ', c_dx, err_c_dx
print 'x2 - x1 (Water): ', w_dx, err_w_dx
print 'x2 - x1 (Resin): ', r_dx, err_r_dx
print 'Speed of Light (Air):   ', c, err_c
print 'Speed of Light (Water): ', c_w, err_c_w
print 'Speed of Light (Resin): ', c_r, err_c_r
print 'Refractive index (Water): ', n_w, err_n_w
print 'Refractive index (Resin): ', n_r, err_n_r
