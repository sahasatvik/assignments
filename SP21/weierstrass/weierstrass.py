#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d as interp

fig, ax = plt.subplots()
plt.subplots_adjust(bottom=0.15)
fig.set_size_inches(16, 8)

f_points = np.array([
    (0, 0),
    (0.2, 0.1),
    (0.4, 0.2),
    (0.7, -0.5),
    (1, 0.2)
])
f = interp(*f_points.T, kind="cubic")

x = np.linspace(0, 1, 500)
epsilon = 0.2

plt.plot(x, f(x), '-r', linewidth=3)
plt.plot(x, f(x) + epsilon, ':r', linewidth=1)
plt.plot(x, f(x) - epsilon, ':r', linewidth=2)
plt.text(1.02, f(1) - 0.02, "$f$", fontsize=16)
plt.text(1.02, f(1) + epsilon - 0.02, "$f + \epsilon$", fontsize=16)
plt.text(1.02, f(1) - epsilon - 0.02, "$f - \epsilon$", fontsize=16)

anchor = (0.1, f(0.1))
marks = np.array([0.5, 0.3, 0.7])
points_i = [
    [
        (0, 0.7),
        anchor,
        (0.5, f(0.5)),
        (1, -0.2)
    ],
    [
        (0, -0.3),
        anchor,
        (0.3, f(0.3)),
        (0.5, -0.18),
        (1, -1.0)
    ],
    [
        (0, 0.2),
        anchor,
        (0.7, f(0.7)),
        (1, 1)
    ],
]

idx = 1
curves = []

plt.scatter(*anchor, s=50, c="blue")
plt.text(anchor[0], anchor[1] + 0.08, "$s$", fontsize=16)
plt.ylim(-1.15, 1.3)
plt.axis("off")

for points in points_i:
    points = np.array(points)
    f_i = interp(*points.T, kind="cubic")
    plt.plot(x, f_i(x), linewidth=1, color="gray")
    plt.scatter(marks[idx - 1], f(marks[idx - 1]), s=50, c="red")
    plt.text(-0.04, points[0][1], "$g_{st_{" + str(idx) + "}}$", fontsize=16)
    plt.text(marks[idx - 1], f(marks[idx - 1]) + 0.08, "$t_{" + str(idx) + "}$", fontsize=14)
    plt.savefig(f"img/weierstrass_A_{idx}.png", transparent=True, bbox_inches="tight")
    curves.append(f_i(x))
    idx += 1

g_s = np.max(curves, axis=0)
plt.plot(x, g_s, linewidth=2, color="black")
plt.plot(x, f(x) - epsilon, '--r', linewidth=2)
plt.text(0.75, 0.65, "$g_{s}$", fontsize=14)

plt.savefig(f"img/weierstrass_A_{idx}.png", transparent=True, bbox_inches="tight")


plt.clf()

plt.plot(x, f(x), '-r', linewidth=3)
plt.plot(x, f(x) + epsilon, ':r', linewidth=2)
plt.plot(x, f(x) - epsilon, '--r', linewidth=2)
plt.text(1.02, f(1) - 0.02, "$f$", fontsize=16)
plt.text(1.02, f(1) + epsilon - 0.02, "$f + \epsilon$", fontsize=16)
plt.text(1.02, f(1) - epsilon - 0.02, "$f - \epsilon$", fontsize=16)

marks = np.array([0.1, 0.4, 0.8])
points_i = [
    [
        (0, 0.1),
        (0.1, f(0.1)),
        (0.5, 0.6),
        (1, 1)
    ],
    [
        (0, 0.7),
        (0.4, f(0.4)),
        (0.6, -0.3),
        (1, 0.5)
    ],
    [
        (0, 0.4),
        (0.4, 0.6),
        (0.6, 0.1),
        (0.8, f(0.8)),
        (1, 0.1)
    ],
]

idx = 1
curves = []

plt.ylim(-1.15, 1.3)
plt.axis("off")

for points in points_i:
    points = np.array(points)
    f_i = interp(*points.T, kind="cubic")
    plt.plot(x, f_i(x), linewidth=1, color="gray")
    plt.scatter(marks[idx - 1], f(marks[idx - 1]), s=50, c="red")
    plt.text(-0.04, points[0][1], "$g_{s_{" + str(idx) + "}}$", fontsize=16)
    plt.text(marks[idx - 1], f(marks[idx - 1]) + 0.08, "$s_{" + str(idx) + "}$", fontsize=14)
    plt.savefig(f"img/weierstrass_B_{idx}.png", transparent=True, bbox_inches="tight")
    curves.append(f_i(x))
    idx += 1

g_s = np.min(curves, axis=0)
plt.plot(x, g_s, linewidth=2, color="black")
plt.plot(x, f(x) + epsilon, '--r', linewidth=2)
plt.plot(x, f(x) - epsilon, '--r', linewidth=2)
plt.text(0.97, -0.3, "$g$", fontsize=14)

plt.savefig(f"img/weierstrass_B_{idx}.png", transparent=True, bbox_inches="tight")


