#!/usr/bin/env Rscript

library("lmreg")
library("matlib")
library("rgl")


beta_hat <- function(X, y) {
    ginv(t(X) %*% X) %*% t(X) %*% y
}


data(denim)
attach(denim)

# png(file = "boxplot.png", width = 768, height = 768)
# boxplot(Abrasion ~ Denim + Laundry, data = denim)
# dev.off()

## Estimates from full model ----

treatments <- data.frame(
    y       <- Abrasion,
    mu      <- rep(1, 90),
    tau1    <- (Denim == 1) + 0,
    tau2    <- (Denim == 2) + 0,
    tau3    <- (Denim == 3) + 0,
    beta1   <- (Laundry == 1) + 0,
    beta2   <- (Laundry == 2) + 0,
    beta3   <- (Laundry == 3) + 0
)

X <- data.matrix(treatments[2:8])
colnames(X) <- c("mu", "tau1", "tau2", "tau3", "beta1", "beta2", "beta3")

print("Design matrix :")
print(X)

beta_h <- beta_hat(X, treatments$y)
rownames(beta_h) <- c("mu", "tau1", "tau2", "tau3", "beta1", "beta2", "beta3")

print("Parameter estimates : ")
print(beta_h)

A_groups <- X[!duplicated(X), ]
y_groups <- A_groups %*% beta_h

group_means = data.frame(
    i       <- A_groups[, 2] + 2 * A_groups[, 3] + 3 * A_groups[, 4],
    j       <- A_groups[, 5] + 2 * A_groups[, 6] + 3 * A_groups[, 7],
    y_hat   <- y_groups
)
colnames(group_means) <- c("i", "j", "y_hat")

print("Predicted means per group : ")
print(group_means)



## Estimates from restricted model ----

treatments_restricted <- data.frame(
    y       <- Abrasion,
    mu      <- rep(1, 90),
    tau1    <- (Denim == 1) + 0 - (Denim == 3),
    tau2    <- (Denim == 2) + 0 - (Denim == 3),
    beta1   <- (Laundry == 1) + 0 - (Laundry == 3),
    beta2   <- (Laundry == 2) + 0 - (Laundry == 3)
)

X_star <- data.matrix(treatments_restricted[2:6])
colnames(X_star) <- c("mu", "tau1", "tau2", "beta1", "beta2")

print("Design matrix (restricted model) :")
print(X_star)

beta_h_star <- beta_hat(X_star, treatments_restricted$y)
rownames(beta_h_star) <- c("mu", "tau1", "tau2", "beta1", "beta2")

print("Parameter estimates : ")
print(beta_h_star)

A_groups_star <- X_star[!duplicated(X_star), ]
y_groups_star <- A_groups_star %*% beta_h_star

group_means_star = data.frame(
    i       <- group_means$i,
    j       <- group_means$j,
    y_hat   <- y_groups_star
)
colnames(group_means_star) <- c("i", "j", "y_hat")

print("Predicted means per group (restricted model) : ")
print(group_means_star)

print("Difference : ")
print(group_means$y - group_means_star$y)
print("(No change)")




## Estimates of differences of tau_i ----

png(file = "confidence_regions.png", width = 768, height = 768)

open3d()

plotCubeCR <- function(x, y, z, p, q, r, color) {
    c <- cube3d()
    c <- scale3d(c, p, q, r)
    c <- translate3d(c, x, y, z)
    shade3d(c, meshColor="faces", color=color, alpha=0.05)
    wire3d(c, meshColor="edges", lwd=3, color=color)
}


a12 <- c(0, 1, -1, 0, 0, 0, 0)
a13 <- c(0, 1, 0, -1, 0, 0, 0)
a23 <- c(0, 0, 1, -1, 0, 0, 0)
A   <- rbind(a12, a13, a23)

A_beta_hat = A %*% beta_h
rownames(A_beta_hat) <- c("tau1 - tau2", "tau1 - tau3", "tau2 - tau3")
print("Estimates of differences of tau_i : ")
print(A_beta_hat)

a12_beta_hat <- A_beta_hat[1]
a13_beta_hat <- A_beta_hat[2]
a23_beta_hat <- A_beta_hat[3]


dof <- dim(X)[1] - R(X)
rho <- 2
y_hat <- X %*% beta_h
e_hat <- y - y_hat
var_hat <- t(e_hat) %*% e_hat / dof

alpha <- 0.05


grid.a12 <- seq(-1, 2, by=0.005)
grid.a13 <- seq(-1, 2, by=0.005)
grid     <- expand.grid(x = grid.a12, y = grid.a13)
grid$z   <- with(grid, y - x)

f_crit <- qf(p = alpha, df1 = rho, df2 = dof, lower.tail = FALSE)
cutoff <- 2 * var_hat * f_crit
M <- ginv(A %*% ginv(t(X) %*% X) %*% t(A))
g <- grid[apply(grid, 1, function(x) (t(x - A_beta_hat) %*% M %*% (x - A_beta_hat)) < cutoff), ]
g <- data.matrix(g)

plot3d(g[, 1], g[, 2], g[, 3], type="l", lwd=5, col="yellow", alpha=1.0, xlab="tau1 - tau2", ylab="tau1 - tau3", zlab="tau2 - tau3")


t_crit <- qt(p = alpha/2, df = dof, lower.tail = FALSE)
delta_a12 <- sqrt(var_hat * t(a12) %*% ginv(t(X) %*% X) %*% a12) * t_crit
delta_a13 <- sqrt(var_hat * t(a13) %*% ginv(t(X) %*% X) %*% a13) * t_crit
delta_a23 <- sqrt(var_hat * t(a23) %*% ginv(t(X) %*% X) %*% a23) * t_crit

plotCubeCR(a12_beta_hat, a13_beta_hat, a23_beta_hat, delta_a12, delta_a13, delta_a23, "red")
print("Individial CI :")
print(c(a12_beta_hat - delta_a12, a12_beta_hat + delta_a12))
print(c(a13_beta_hat - delta_a13, a13_beta_hat + delta_a13))
print(c(a23_beta_hat - delta_a23, a23_beta_hat + delta_a23))


gamma <- alpha / rho
t_crit_bf <- qt(p = gamma/2, df = dof, lower.tail = FALSE)
delta_a12_bf <- sqrt(var_hat * t(a12) %*% ginv(t(X) %*% X) %*% a12) * t_crit_bf
delta_a13_bf <- sqrt(var_hat * t(a13) %*% ginv(t(X) %*% X) %*% a13) * t_crit_bf
delta_a23_bf <- sqrt(var_hat * t(a23) %*% ginv(t(X) %*% X) %*% a23) * t_crit_bf

plotCubeCR(a12_beta_hat, a13_beta_hat, a23_beta_hat, delta_a12_bf, delta_a13_bf, delta_a23_bf, "green")
print("Bonferroni CI :")
print(c(a12_beta_hat - delta_a12_bf, a12_beta_hat + delta_a12_bf))
print(c(a13_beta_hat - delta_a13_bf, a13_beta_hat + delta_a13_bf))
print(c(a23_beta_hat - delta_a23_bf, a23_beta_hat + delta_a23_bf))


f_crit_sc <- qf(p = alpha, df1 = rho, df2 = dof, lower.tail = FALSE)
delta_a12_sc <- sqrt(rho * var_hat * t(a12) %*% ginv(t(X) %*% X) %*% a12 * f_crit_sc)
delta_a13_sc <- sqrt(rho * var_hat * t(a13) %*% ginv(t(X) %*% X) %*% a13 * f_crit_sc)
delta_a23_sc <- sqrt(rho * var_hat * t(a23) %*% ginv(t(X) %*% X) %*% a23 * f_crit_sc)

plotCubeCR(a12_beta_hat, a13_beta_hat, a23_beta_hat, delta_a12_sc, delta_a13_sc, delta_a23_sc, "blue")
print("Scheffe CI :")
print(c(a12_beta_hat - delta_a12_sc, a12_beta_hat + delta_a12_sc))
print(c(a13_beta_hat - delta_a13_sc, a13_beta_hat + delta_a13_sc))
print(c(a23_beta_hat - delta_a23_sc, a23_beta_hat + delta_a23_sc))

axes3d()

