#!/usr/bin/env python3

import numpy as np
from numpy.random import multivariate_normal as mvn
import matplotlib.pyplot as plt


N = 10000

mean = np.zeros(2)
cov1 = np.identity(2)
cov2 = np.array([[1, 0.5], [0.5, 1]])

fig, axs = plt.subplots(1, 2, dpi=100)

axs[0].plot(*mvn(mean, cov1, N).T, '.', alpha=0.2, color='blue')
axs[0].set_aspect('equal', 'box')
axs[0].axis([-5, 5, -5, 5])
axs[0].set_title('Cov[X] $= \mathbb{I}_n$')

axs[1].plot(*mvn(mean, cov2, N).T, '.', alpha=0.2, color='orange')
axs[1].set_aspect('equal', 'box')
axs[1].axis([-5, 5, -5, 5])
axs[1].set_title('Cov[X] $\\neq \mathbb{I}_n$')

plt.show()


