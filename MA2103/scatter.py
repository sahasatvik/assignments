#!/usr/bin/env python3

import seaborn
import matplotlib.pyplot as plt
import pandas as pd
from scipy import stats

def scatter(filename, query=[]):
    data = pd.read_csv(filename)
    X, Y = data.columns
    
    x, y = data[X], data[Y]
    slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
    pearson = stats.pearsonr(x, y)
    seaborn.regplot(x=x, y=y, line_kws={'label':"$y = {0:.2f}x + {1:.2f}$".format(slope,intercept)})
    plt.legend()
    plt.show()
    seaborn.residplot(x=x, y=y)
    plt.ylabel(Y + " (Residuals)")
    plt.show()

    print(filename)
    print(len(x), sum(x), sum(y), sum(x * x), sum(y * y), sum(x * y))
    print(slope, intercept)
    print(pearson)
    for q in query:
        print(q, slope * q + intercept)
    print()

scatter('metacarpal.dat', query=[44, 55])
scatter('rental.dat', query=[230000, 400000])
scatter('expectancy.dat', query=[2.7, 8.1])
scatter('brain.dat', query=[62, 180000])
scatter('brain_clean.dat', query=[62, 180000])
