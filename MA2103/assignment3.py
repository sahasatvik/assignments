#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt

N = 50
A = {n:4 * (1 - np.cos(n * np.pi)) / (n**3 * np.pi**3) for n in range(1, N)}

x_res = 150
y_res = 150

def semi_infinite_plate(x, y):
    return sum(A[n] * np.exp(-n * np.pi * y) * np.sin(n * np.pi * x) for n in range(1, N))

def finite_plate(x, y, H):
    return sum(A[n] * np.sinh(n * np.pi * (H - y)) * np.sin(n * np.pi * x) / np.sinh(n * np.pi * H) for n in range(1, N))

def heat_flow(x, t, alpha):
    return sum(A[n] * np.exp(-(n * np.pi * alpha)**2 * t) * np.sin(n * np.pi * x) for n in range(1, N))

def particle_in_a_box(x, t):
    s = sum(A[n] * np.exp(-(n * np.pi)**2 * t * 1j) * np.sin(n * np.pi * x) for n in range(1, N))
    return np.abs(s)**2

def plucked_string(x, t, v):
    return sum(A[n] * np.sin(n * np.pi * x) * np.cos(n * np.pi * v * t) for n in range(1, N))

def struck_string(x, t, v):
    return sum(A[n] * np.sin(n * np.pi * x) * np.sin(n * np.pi * v * t) / (n * np.pi * v) for n in range(1, N))

def plot(f, X=1, Y=1, xlabel='X', ylabel='Y', clabel='', cmap='afmhot', title='', **args):
    x, y = np.meshgrid(np.linspace(0, X, x_res), np.linspace(0, Y, y_res))
    
    grid = np.empty([y_res, x_res])
    for i in range(x_res):
        for j in range(y_res):
            grid[j][i] = f(1.0 * i * X / x_res, 1.0 * j * Y / y_res, **args)
    
    plt.pcolormesh(x, y, grid, cmap=cmap)
    plt.axis((0, X, 0, Y))
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.colorbar().set_label(clabel)
    plt.title(title)
    plt.show()

plot(semi_infinite_plate, Y=0.5, clabel='Temperature')
plot(finite_plate, H=0.5, Y=0.5, clabel='Temperature', title='$H = 0.5$')
plot(heat_flow, alpha=1, Y=0.25, ylabel='t', clabel='Temperature', title='$\\alpha = 1$')
plot(particle_in_a_box, Y=0.25, ylabel='t', clabel='$|\\Psi|^2$', cmap='bone', title='$\\hbar = 2m$')
plot(plucked_string, v=1, Y=2, ylabel='t', clabel='Displacement', cmap='bwr', title='$v = 1$')
plot(struck_string, v=1, Y=2, ylabel='t', clabel='Displacement', cmap='bwr', title='$v = 1$')
