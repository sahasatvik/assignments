#!/usr/bin/env python3

import sys
import matplotlib.pyplot as plt
import numpy as np
from sample_disc import sample_unit_disc


def pi_estimate(samples):
    # Estimate the value of pi using 'samples' sample points
    accepted, rejected = sample_unit_disc(samples)
    total = len(accepted) + len(rejected)
    return 4 * (samples / total)


def main():
    # First command line argument is the number of runs to perform
    # Second command line argument is the number of sample points to be drawn per run
    runs, samples = int(sys.argv[1]), int(sys.argv[2])
    # Calculate the estimates
    estimates = [pi_estimate(samples) for i in range(runs)]
    mean_pi_estimate = sum(estimates) / runs
    error = mean_pi_estimate - np.pi
    error_rel = 100 * error / np.pi

    print(
        f"Mean of pi estimates from {runs} runs, each with {samples} samples, is {mean_pi_estimate}"
    )
    print(f"Error is {error:.8f} ({error_rel:.6f}%)")

    plt.hist(estimates, bins=20)
    plt.axvline(x=np.pi, color="red", label="$\pi$")
    plt.axvline(x=mean_pi_estimate, color="orange", label="Mean of runs")
    plt.title(f"{runs} runs, each with {samples} samples")
    plt.legend()
    plt.show()


if __name__ == "__main__":
    main()
