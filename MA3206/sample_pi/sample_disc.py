#!/usr/bin/env python3

import sys
import matplotlib.pyplot as plt
import numpy as np
from random import uniform


def sample_unit_disc(n):
    # Prepare lists of accepted and rejected points
    accepted = []
    rejected = []
    # Loop until 'n' points from within the unit disc have been accepted
    while len(accepted) < n:
        # Pick a random point uniformly from the square [-1, 1] x [-1, 1]
        x = uniform(-1, 1)
        y = uniform(-1, 1)
        # Check whether (x, y) falls in the unit disc
        if x**2 + y**2 <= 1:
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

    ax.add_patch(plt.Circle((0, 0), 1, fill=False))
    ax.add_patch(plt.Rectangle((-1, -1), 2, 2, fill=False))

    plt.scatter(*zip(*accepted), color="red", s=10)
    plt.scatter(*zip(*rejected), color="blue", s=10)

    plt.axis((-1.05, 1.05, -1.05, 1.05))
    
    a = len(accepted)
    total = len(accepted) + len(rejected)
    plt.title(f"{a} accepted out of {total}")
    plt.show()


def main():
    # First command line argument is the number of sample points to be drawn
    n = int(sys.argv[1])
    # Sample 'n' points from the unit disc
    accepted, rejected = sample_unit_disc(n)
    # Estimate 'pi' using the areas of the square and the disc
    total = len(accepted) + len(rejected)
    pi_estimate = 4 * (n / total)
    error = pi_estimate - np.pi
    error_rel = 100 * error / np.pi

    print(f"{n} samples accepted out of {total} draws.")
    print(f"Estimated value of pi is {pi_estimate:.8f}")
    print(f"Error is {error:.8f} ({error_rel:.6f}%)")

    plot_points(accepted, rejected)


if __name__ == "__main__":
    main()
