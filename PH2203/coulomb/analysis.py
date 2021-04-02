#!/usr/bin/env python3

import matplotlib.pyplot as plt
import pandas as pd
import scipy.stats as stats


# Force vs charge
FV = pd.read_csv('F_vs_V.csv')
V_, F_1_, F_2_ = FV.columns
V, F_1, F_2 = FV[V_], FV[F_1_], FV[F_2_]

m_1, c_1, _, _, se_1 = stats.linregress(V**2, F_1)
m_2, c_2, _, _, se_2 = stats.linregress(V**2, F_2)
plt.scatter(V**2, F_1, label="Distance 1")
plt.plot(V**2, m_1 * V**2 + c_1, '--r')
plt.scatter(V**2, F_2, label="Distance 2")
plt.plot(V**2, m_2 * V**2 + c_2, '--b')
plt.xlabel("$V^2$ (kV$^2$)")
plt.ylabel("$F$ (mN)")
plt.title("Variation of force with charge.")
plt.legend()
plt.show()
print(f"m1 = {m_1:.4f}, se1 = {se_1:.4f}")
print(f"m2 = {m_2:.4f}, se2 = {se_2:.4f}")


#Force vs distance
FD = pd.read_csv('F_vs_D.csv')
D_, F_1_, F_2_ = FD.columns
D, F_1, F_2 = FD[D_], FD[F_1_], FD[F_2_]

m_1, c_1, _, _, se_1 = stats.linregress(1 / D**2, F_1)
m_2, c_2, _, _, se_2 = stats.linregress(1 / D**2, F_2)
plt.scatter(1 / D**2, F_1, label="V = 10 kV")
plt.plot(1 / D**2, m_1 / D**2 + c_1, '--r')
plt.scatter(1 / D**2, F_2, label="V = 8 kV")
plt.plot(1 / D**2, m_2 / D**2 + c_2, '--b')
plt.xlabel("$1 / r^2$ (mm$^{-2}$)")
plt.ylabel("$F$ (mN)")
plt.title("Variation of force with distance.")
plt.legend()
plt.show()
print(f"m1 = {m_1:.4f}, se1 = {se_1:.4f}")
print(f"m2 = {m_2:.4f}, se2 = {se_2:.4f}")
