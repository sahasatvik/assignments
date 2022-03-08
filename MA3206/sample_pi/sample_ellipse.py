#!/usr/bin/env python3

import sys
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
import numpy as np
from random import uniform


def sample_ellipse(n):
    accepted = []
    rejected = []
    while len(accepted) < n:
        x = uniform(-1, 3)
        y = uniform(0, 4)
        if 2 * (x - 1) ** 2 + 5 * (y - 2) ** 2 <= 8:
            accepted.append((x, y))
            print(f"{x:12.8f} {y:12.8f}   accepted", file=sys.stderr)
        else:
            rejected.append((x, y))
            print(f"{x:12.8f} {y:12.8f}   rejected", file=sys.stderr)
    return accepted, rejected


def plot_points(accepted, rejected):
    fig, ax = plt.subplots()
    plt.axis("off")
    ax.axis("equal")
    fig.set_size_inches(10, 10)

    ax.add_patch(Ellipse(xy=(1, 2), width=4, height=2 * np.sqrt(8 / 5), fill=False))
    ax.add_patch(plt.Rectangle((-1, 0), 4, 4, fill=False))

    plt.scatter(*zip(*accepted), color="red", s=10)
    plt.scatter(*zip(*rejected), color="blue", s=10)

    plt.axis((-1.05, 3.05, -0.05, 4.05))

    a = len(accepted)
    total = len(accepted) + len(rejected)
    plt.title(f"{a} accepted out of {total}")
    plt.show()


def main():
    # First command line argument is the number of sample points to be drawn
    n = int(sys.argv[1])
    # Sample 'n' points from the ellipse
    accepted, rejected = sample_ellipse(n)
    # Estimate 'pi' using the areas of the square and the ellipse
    total = len(accepted) + len(rejected)
    pi_estimate = np.sqrt(40) * (n / total)
    error = pi_estimate - np.pi
    error_rel = 100 * error / np.pi

    print(f"{n} samples accepted out of {total} draws.")
    print(f"Estimated value of pi is {pi_estimate:.8f}")
    print(f"Error is {error:.8f} ({error_rel:.6f}%)")

    plot_points(accepted, rejected)


if __name__ == "__main__":
    main()
