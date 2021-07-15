#!/usr/bin/env python3

from functools import cache
import numpy as np

@cache
def binom(n, k):
    '''
    Calculates the binomial coefficient n choose k.
    '''

    if k > n / 2:
        return binom(n, n - k)
    if k == 0:
        return 1
    return binom(n - 1, k - 1) * n // k

def bernstein_poly(n, k):
    '''
    Returns the k'th Bernstein polynomial of degree n.
    '''

    def p(x):
        return binom(n, k) * x**k * (1 - x)**(n - k)
    return p

def bernstein(f, n):
    '''
    Returns the n'th degree Bernstein expansion of the function f.
    '''

    def p(x):
        terms = [bernstein_poly(n, k)(x) * f(k / n) for k in range(0, n + 1)]
        return np.sum(terms, axis=0)
    return p


if __name__ == '__main__':
    import matplotlib.pyplot as plt
    from matplotlib.widgets import Slider

    fig, ax = plt.subplots()
    plt.subplots_adjust(bottom=0.15)
    fig.set_size_inches(10, 8)

    degree_ax = plt.axes([0.2, 0.05, 0.65, 0.03])
    degree_slider = Slider(degree_ax, 'Degree', 0, valmax=20, valinit=3, valstep=1)
    
    x = np.linspace(0, 1, 100)

    def update(degree):
        degree = int(degree)
        colors = plt.get_cmap('Blues')(np.linspace(0.2, 1, degree + 1))
        ax.cla()
        ax.set_xlim(0, 1)
        ax.set_title(f"Bernstein polynomials of degree {degree}")
        for k, c in zip(range(degree + 1), colors):
            ax.plot(x, bernstein_poly(degree, k)(x), color=c)

    degree_slider.on_changed(update)
    update(3)

    plt.show()
