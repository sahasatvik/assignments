#!/usr/bin/env python3

import numpy as np
import pandas as pd
import scipy.stats as stats


with open("boston") as f:
    lines = f.readlines()

lines = lines[22:]                                              # Remove headers
lines = ''.join(lines).split()                                  # Split lines into values
data  = np.array(lines, dtype=float).reshape(-1, 14)            # Split into rows
data[:, -1] = np.log(data[:, -1])

boston = pd.DataFrame(data, columns=[                           # Store in data-frame
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
boston_features = boston.columns[:-1]



def ols(data, target, features, name=""):
    y = data[target].to_numpy()
    X = data[features].to_numpy()
    X_ = np.hstack([np.ones((X.shape[0], 1)), X])               # Insert column of ones

    beta = np.linalg.inv(X_.T @ X_) @ X_.T @ y                  # Calculate parameter estimates

    def model(x):                                               # Estimator of y
        return beta[0] + x @ beta[1:]

    model.beta = beta                                           # Bundle parameter estimates
    model.coefficients = dict(zip(features, beta[1:]))
    model.bias = beta[0]

    model.features = list(features)                             # Bundle features
    model.n_features = len(model.features)

    y_pred = model(X)                                           # Bundle additional statistics
    model.residuals = y - y_pred
    model.RSS = model.residuals.T @ model.residuals
    ssy = (y - y.mean()).T @ (y - y.mean())
    model.R2 = 1 - model.RSS / ssy
    model.adj_R2 = 1 - (1 - model.R2) * (len(y) - 1) / (len(y) - (model.n_features + 1))

    model.AIC = len(y) * np.log(model.RSS / len(y)) + 2 * model.n_features

    model.name = name

    return model



def forward_selection(data, target, allfeatures, features=[], F_in=2.0, use_p=False, alpha=0.05, name=""):
    n = len(data[target])
    model = ols(data, target, features, name=name)              # Initial (empty) model

    while len(features) < len(allfeatures):
        p = len(features)
        newmodels = dict()
        remainingfeatures = set(allfeatures).difference(features)

        for feature in remainingfeatures:
            newfeatures = features + [feature]
            newmodel = ols(data, target, newfeatures, name=name)
            newmodel.F = (n - (p + 2)) * (model.RSS - newmodel.RSS) / newmodel.RSS
            newmodel.p = 1 - stats.f.cdf(newmodel.F, 1, n - (p + 2))
            newmodels[feature] = newmodel

        print("Current model uses features {}".format(features))

        for feature in sorted(remainingfeatures, key=lambda f: newmodels[f].AIC):
            m = newmodels[feature]
            print("+{:10s} => F = {:8.4f}, p = {:6.4f}, adjR2 = {:8.4f}, D_AIC = {:8.4f}".format(feature, m.F, m.p, m.adj_R2, m.AIC - model.AIC))

        bestfeature = max(remainingfeatures, key=lambda f: newmodels[f].F)
        if use_p:
            bestp = newmodels[bestfeature].p
            if bestp > alpha:
                break
        else:
            bestF = newmodels[bestfeature].F
            if bestF < F_in:                                    # Check threshold for inclusion
                break

        features.append(bestfeature)
        model = newmodels[bestfeature]                          # Update model
        print("Added   {:10s}".format(bestfeature))
        print()

    return model



def backward_elimination(data, target, allfeatures, F_out=1.0, use_p=False, alpha=0.05, name=""):
    n = len(data[target])
    features = list(allfeatures)
    model = ols(data, target, features, name=name)

    while len(features) >= 0:
        p = len(features)
        newmodels = dict()

        for feature in features:
            newfeatures = list(set(features).difference([feature]))
            newmodel = ols(data, target, newfeatures, name=name)
            newmodel.F = (n - (p + 1)) * (newmodel.RSS - model.RSS) / model.RSS
            newmodel.p = 1 - stats.f.cdf(newmodel.F, 1, n - (p + 1))
            newmodels[feature] = newmodel

        print("Current model uses features {}".format(features))

        for feature in sorted(features, key=lambda f: newmodels[f].AIC):
            m = newmodels[feature]
            print("-{:10s} => F = {:8.4f}, p = {:6.4f}, adjR2 = {:8.4f}, D_AIC = {:8.4f}".format(feature, m.F, m.p, m.adj_R2, m.AIC - model.AIC))

        worstfeature = min(features, key=lambda f: newmodels[f].F)
        if use_p:
            worstp = newmodels[worstfeature].p
            if worstp < alpha:
                break
        else:
            worstF = newmodels[worstfeature].F
            if worstF > F_out:
                break

        features.remove(worstfeature)
        model = newmodels[worstfeature]
        print("Removed {:10s}".format(worstfeature))
        print()

    return model


def forward_backward_stepwise(data, target, allfeatures, features=[], F_in=2.0, F_out=1.0, use_p=False, alpha=0.05, name=""):
    n = len(data[target])
    model = ols(data, target, features, name=name)

    while len(features) < len(allfeatures) and len(features) >= 0:
        changed = False

        # Forward pass
        p = len(features)
        newmodels = dict()
        remainingfeatures = set(allfeatures).difference(features)

        for feature in remainingfeatures:
            newfeatures = features + [feature]
            newmodel = ols(data, target, newfeatures, name=name)
            newmodel.F = (n - (p + 2)) * (model.RSS - newmodel.RSS) / newmodel.RSS
            newmodel.p = 1 - stats.f.cdf(newmodel.F, 1, n - (p + 2))
            newmodels[feature] = newmodel

        print("Current model uses features {}".format(features))

        print("Forward pass")

        for feature in sorted(remainingfeatures, key=lambda f: newmodels[f].AIC):
            m = newmodels[feature]
            print("+{:10s} => F = {:8.4f}, p = {:6.4f}, adj_R2 = {:8.4f}, D_AIC = {:8.4f}".format(feature, m.F, m.p, m.adj_R2, m.AIC - model.AIC))

        bestfeature = max(remainingfeatures, key=lambda f: newmodels[f].F)
        if use_p:
            bestp = newmodels[bestfeature].p
            if bestp <= alpha:
                features.append(bestfeature)
                model = newmodels[bestfeature]
                print("Added   {:10s}".format(bestfeature))
                changed = True
        else:
            bestF = newmodels[bestfeature].F
            if bestF >= F_in:
                features.append(bestfeature)
                model = newmodels[bestfeature]
                print("Added   {:10s}".format(bestfeature))
                changed = True

        # Backward pass
        p = len(features)
        newmodels = dict()

        for feature in features:
            newfeatures = list(set(features).difference([feature]))
            newmodel = ols(data, target, newfeatures, name=name)
            newmodel.F = (n - (p + 1)) * (newmodel.RSS - model.RSS) / model.RSS
            newmodel.p = 1 - stats.f.cdf(newmodel.F, 1, n - (p + 1))
            newmodels[feature] = newmodel

        print("Backward pass")

        for feature in sorted(features, key=lambda f: newmodels[f].AIC):
            m = newmodels[feature]
            print("-{:10s} => F = {:8.4f}, p = {:6.4f}, adjR2 = {:8.4f}, D_AIC = {:8.4f}".format(feature, m.F, m.p, m.adj_R2, m.AIC - model.AIC))

        worstfeature = min(features, key=lambda f: newmodels[f].F)
        if use_p:
            worstp = newmodels[worstfeature].p
            if worstp >= alpha:
                features.remove(worstfeature)
                model = newmodels[worstfeature]
                print("Removed {:10s}".format(worstfeature))
                changed = True
        else:
            worstF = newmodels[worstfeature].F
            if worstF <= F_out:
                features.remove(worstfeature)
                model = newmodels[worstfeature]
                print("Removed {:10s}".format(worstfeature))
                changed = True

        print()

        if not changed:
            break

    return model



# F_out, F_in = 1.0, 2.0
# print("Using thresholds F_out = {}, F_in = {}\n".format(F_out, F_in))

model_ols = ols(
    boston,
    "LOGMEDV",
    boston_features,
    name="OLS"
)

print("Forward Selection")
model_forward = forward_selection(
    boston,
    "LOGMEDV",
    boston_features,
    # F_in=F_in,
    use_p=True,
    name="Forward"
)
print()
print("Final model uses {} features {}".format(model_forward.n_features, model_forward.features))
print("\n")

print("Backward Elimination")
model_backward = backward_elimination(
    boston,
    "LOGMEDV",
    boston_features,
    # F_out=F_out,
    use_p=True,
    name="Backward"
)
print()
print("Final model uses {} features {}".format(model_backward.n_features, model_backward.features))
print("\n")

print("Forward-Backward Stepwise")
model_fb = forward_backward_stepwise(
    boston,
    "LOGMEDV",
    boston_features,
    # F_in=F_in,
    # F_out=F_out,
    use_p=True,
    name="Forward-Backward"
)
print()
print("Final model uses {} features {}".format(model_fb.n_features, model_fb.features))


print()
print("Summary of models")

models = [model_ols, model_forward, model_backward, model_fb]
models.sort(key=lambda m: m.AIC)
bestAIC = min(model.AIC for model in models)
for model in models:
    print("{:16s} :  K = {:2d}, adjR2 = {:8.4f}, D_AIC = {:8.4f}  {}".format(model.name, model.n_features, model.adj_R2, model.AIC - bestAIC, model.features))
print()



# Show parameters

print("{:10s} ".format(""), end="")
for model in models:
    print(" {:>16s} ".format(model.name), end="")
print()

print("{:>10s} ".format("(bias)"), end="")
for model in models:
    print(" {:16.4f} ".format(model.bias), end="")
print()

for feature in boston_features:
    print("{:>10s} ".format(feature), end="")
    for model in models:
        print(" {:16.4f} ".format(model.coefficients.get(feature, 0.0)), end="")
    print()


from itertools import chain, combinations

def powerset(iterable):
    s = list(iterable)
    return chain.from_iterable(combinations(s, r) for r in range(len(s) + 1))

allmodels = []
for features in powerset(boston_features):
    model = ols(boston, "LOGMEDV", list(features))
    allmodels.append(model)

allmodels.sort(key=lambda m: m.AIC)
bestAIC = allmodels[0].AIC
print()
print("Best models (brute force)")
for model in allmodels[:10]:
    print("K = {:2d}, adjR2 = {:8.4f}, D_AIC = {:8.4f}  {}".format(model.n_features, model.adj_R2, model.AIC - bestAIC, model.features))
