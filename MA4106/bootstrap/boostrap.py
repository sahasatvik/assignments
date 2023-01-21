#!/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# Load data

with open("admission") as f:
    lines = f.readlines()

lines = lines[1:]
lines = ''.join(lines).split()
data  = np.array(lines).reshape(-1, 3)

admission = pd.DataFrame({
    "School": data[:, 0].astype(int),
    "LSAT"  : data[:, 1].astype(float),
    "GPA"   : data[:, 2].astype(float)
})
admission.set_index("School", inplace=True)
n = len(admission)

print(admission.corr())


# Calculate bootstrap sample correlations

correlations = []
B_max = 3000

for i in range(B_max):
    sample = admission.sample(n, replace=True)
    correlations.append(sample.corr()["LSAT"]["GPA"])

correlations = np.array(correlations)


# Estimate the standard errors
std_estimates = [(B, correlations[:B].std()) for B in range(25, B_max)]
std_estimates = np.array(std_estimates)


# Show the variation of se_B(\rho) with B
plt.plot(*std_estimates.T)
plt.xlabel("B")
plt.ylabel("Standard error estimate")
plt.show()

print("Estimate of standard error is {}".format(std_estimates[-1, 1]))


# Show the estimated distribution of the correlation
plt.hist(correlations)
plt.xlabel("Correlation between LSAT and GPA")
plt.ylabel("Frequency")
plt.show()


# Calculate the proportion of correlations above 0.5
print("Estimated probability of (correlation > 0.5) is {}".format((correlations > 0.5).mean()))
