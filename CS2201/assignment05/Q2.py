#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt

marks = {'marksstu1': [60, 70, 80], 'marksstu2': [65, 75, 80], 'marksstu3': [70, 70, 90]}
n = len(marks)

df = pd.DataFrame(marks)
corr = df.corr()

x = []
y = []

# Generate the correlations for all unordered pairs
for i in range(n):
    for j in range(i):
        if i == j:
            continue
        x.append(str(j + 1) + '-' + str(i + 1))
        y.append(corr.iloc[j, i])

plt.bar(x, y)
plt.xlabel("Marks/Student pairs")
plt.ylabel("Correlation")
plt.show()
