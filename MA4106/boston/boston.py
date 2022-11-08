#!/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import colors
from cycler import cycler
import scipy.optimize as optimize
import statsmodels.api as sm

with open("boston") as f:
    lines = f.readlines()

lines = lines[22:]                                              # Remove headers
lines = ''.join(lines).split()                                  # Split lines into values
data  = np.array(lines, dtype=float).reshape(-1, 14)            # Split into rows
data[:, -1] = np.log(data[:, -1])
df    = pd.DataFrame(data, columns=[                            # Store in data-frame
            "CRIM",
            "ZN",
            "INDUS",
            "CHAS",
            "NOX",
            "RM",
            "AGE",
            "DIS",
            "RAD",
            "TAX",
            "PTRATIO",
            "B",
            "LSTAT",
            "LOGMEDV"
        ])
df.to_csv("boston.csv", index=False)
dfx = df.drop(labels="LOGMEDV", axis=1)
mu  = np.array(dfx.mean())
sxx = np.array(((dfx - dfx.mean())**2).sum())
df_norm = (dfx - mu) / np.sqrt(sxx)
# df_norm = (df - df.mean()) / (df.std() * np.sqrt(len(df) - 1))
# print(df_norm)
# print(df_norm.describe())

# for column in df:
#     df.boxplot([column])
#     plt.show()

X_ = np.asarray(df_norm)
X = np.concatenate([np.ones((len(df), 1)), X_], axis=1)
Y = np.asarray(df["LOGMEDV"])

dfx.insert(loc=0, column="BIAS", value=1)
model = sm.OLS(df["LOGMEDV"], dfx)
results = model.fit()
print(results.params)

# def ridge(X, Y, k):
#     return np.linalg.inv((X.T @ X) + k * np.identity(X.shape[1])) @ X.T @ Y

# def ols(X, Y):
#     return ridge(X, Y, 0)

# def beta_recover(beta, mu, sxx):
#     beta0, beta_ = beta[0], beta[1:]
#     return np.concatenate([
#         [beta0 - (mu / np.sqrt(sxx)).dot(beta_)], 
#         beta_ / np.sqrt(sxx)
#     ])

# # print(np.linalg.det(X_.T @ X_))
# # print(X_)
# # print(X_.T @ X_)

# beta_ols = ols(X, Y)
# Y_ols = X @ beta_ols

# E_ols = Y - Y_ols
# print(E_ols.mean(), E_ols.std(), E_ols.var())
# # plt.hist(E_ols, bins=32)
# # plt.xlabel("Residuals")
# # plt.ylabel("Frequency")
# # plt.show()

# # print("Correlation matrix : ", X_.T @ X_)

# beta_orig = beta_recover(beta_ols, mu, sxx)

# VIFs = np.linalg.inv(X_.T @ X_).diagonal()
# print("{:10s}  {:>10s}  {:>10s}  {:>10s}".format("Variable", "beta_j*", "beta_j", "VIF"))
# print("{:10s}  {:10.6f}  {:10.6f}  {:>10s}".format("BIAS", beta_ols[0], beta_orig[0], "-"))
# for i in range(X_.shape[1]):
#     print("{:10s}  {:10.6f}  {:10.6f}  {:10.6f}".format(df.columns[i], beta_ols[i + 1], beta_orig[i + 1], VIFs[i]))
# print()

# syy = ((Y - Y.mean())**2).sum()
# R2 = 1 - E_ols.T @ E_ols / syy
# print("R^2 score :   {:.4f}".format(R2))

# eigenvalues = np.linalg.eigvals(X_.T @ X_)
# kappa = np.sqrt(max(eigenvalues) / min(eigenvalues))
# # print("Eigenvalues : ", eigenvalues)
# print("Kappa     :   {:.4f}".format(kappa))

# # Rxx = X_.T @ X_
# # fig = plt.figure()
# # ax = fig.add_subplot(111)
# # divnorm=colors.TwoSlopeNorm(vmin=-1., vcenter=0., vmax=1.)
# # cax = ax.matshow(df.corr(), cmap="seismic", norm=divnorm)
# # for (i, j), z in np.ndenumerate(df.corr()):
# #     ax.text(j, i, f"{z:0.2f}", ha="center", va="center")
# # fig.colorbar(cax)
# # ax.set_xticks(list(range(0, len(df.columns))))
# # ax.set_yticks(list(range(0, len(df.columns))))
# # ax.set_xticklabels(df.columns)
# # ax.set_yticklabels(df.columns)
# # plt.xticks(rotation=45)
# # plt.show()


# plt.rc(
#     'axes',
#     prop_cycle=(
#         cycler('linestyle', ['-', '--', ':']) *
#         cycler('color', "rgbcm")
#     )
# )

# # K = np.logspace(-4, 4, 100)

# # estimates = [ridge(X, Y, k) for k in K]
# # plt.semilogx(K, estimates, label=["BIAS", *df.columns[:-1]])
# # plt.axhline(y=0, c="black", linewidth=0.5)
# # plt.axvline(x=0.01, c="green", linewidth=0.5)
# # plt.axvline(x=0.008, c="blue", linewidth=0.5)
# # plt.xticks(np.logspace(-4, 4, 9))
# # plt.xlabel("$k$")
# # plt.ylabel("$\\beta_j^*$")
# # plt.legend()
# # plt.show()


# K = np.linspace(0, 0.02, 51)

# def loocv(X, Y, k=0.0):
#     total = 0
#     for i in range(len(X)):
#         X_ = np.concatenate([X[:i], X[i + 1:]])
#         Y_ = np.concatenate([Y[:i], Y[i + 1:]])
#         beta_ = ridge(X_, Y_, k)
#         Y_pred = X[i] @ beta_
#         E_ = Y[i] - Y_pred
#         total += E_**2
#     return total / len(X)

# # mses = [loocv(X, Y, k) for k in K]
# # plt.plot(K, mses)
# # plt.xlabel("$k$")
# # plt.ylabel("Cross-Validation Error")
# # plt.show()

# k = optimize.minimize(lambda x: loocv(X, Y, x), 0.01, tol=1e-6)
# print("Minimizer of Leave-One-Out Cross Validation MSE : ", k.x[0])

# k_loocv = k.x
# k_plot  = 0.01

# beta_loocv = ridge(X, Y, k_loocv)
# beta_plot  = ridge(X, Y, k_plot)

# beta_loocv_orig = beta_recover(beta_loocv, mu, sxx)
# beta_plot_orig  = beta_recover(beta_plot,  mu, sxx)

# print("{:10s}  {:>10s}  {:>10s}  {:>10s}  {:>10s}  {:>10s}  {:>10s}".format("Variable", "OLS", "LOOCV", "RidgeTrace", "OLS", "LOOCV", "RidgeTrace"))
# print("{:10s}  {:10.6f}  {:10.6f}  {:>10.6f}  {:10.6f}  {:10.6f}  {:>10.6f}".format("BIAS", beta_ols[0], beta_loocv[0], beta_plot[0], beta_orig[0], beta_loocv_orig[0], beta_plot_orig[0]))
# for i in range(X_.shape[1]):
#     print("{:10s}  {:10.6f}  {:10.6f}  {:10.6f}  {:10.6f}  {:10.6f}  {:>10.6f}".format(df.columns[i], beta_ols[i + 1], beta_loocv[i + 1], beta_plot[i + 1], beta_orig[i + 1], beta_loocv_orig[i + 1], beta_plot_orig[i + 1]))
# print()

# Y_loocv = X @ beta_loocv
# Y_plot = X @ beta_plot

# E_loocv = Y - Y_loocv
# E_plot = Y - Y_plot

# R2_loocv = 1 - E_loocv.T @ E_loocv / syy
# R2_plot = 1 - E_plot.T @ E_plot / syy
# print("R^2 score (LOOCV)       :   {:.4f}".format(R2_loocv))
# print("R^2 score (Ridge-Trace) :   {:.4f}".format(R2_plot))

# # plt.hist(E_ols, bins=32, label="k = 0", alpha=0.5)
# # plt.hist(E_loocv, bins=32, label="k = 0.008", alpha=0.5)
# # plt.hist(E_plot, bins=32, label="k = 3", alpha=0.5)
# # plt.xlabel("Residuals")
# # plt.ylabel("Frequency")
# # plt.legend()
# # plt.show()

# A = np.linalg.inv((X.T @ X) + k_plot * np.identity(X.shape[1])) @ X.T
# print((A @ A.T).diagonal())
