#!/usr/bin/env Rscript

library(matlib)
library(tibble)
library(dplyr)
library(npreg)

source("kernelreg.R")

glass <- read.table("glass.dat")
glass <- tibble(glass)
print(glass)

pdf("glass.pdf")

# Plot data
plot(glass$Al, glass$RI, xlab = "Al", ylab = "RI")
abline(lm(RI ~ Al, data = glass), lwd = 2)
title("Linear regression")

n <- length(glass$RI)


# Kernel regression
x <- seq(0, 3.5, length.out = 100)
H <- seq(0.05, 0.2, 0.005)
CV0 <- sapply(H, function(h) { CV(glass$Al, glass$RI, h, degree = 0) })
plot(H, CV0, type = "l", xlab = "h", ylab = "OCV")
title("Cross-Validation error (kernel regression)")
h0 <- H[which.min(CV0)]
sprintf("Kernel regression: h = %f, CV = %f", h0, min(CV0, na.rm = TRUE))

glass.kreg <- kernelreg(x, glass$Al, glass$RI, h0)
plot(glass$Al, glass$RI, xlab = "Al", ylab = "RI")
lines(x, glass.kreg$y, lwd = 2)
title("Kernel regression")

reg <- kernelreg(glass$Al, glass$Al, glass$RI, h0)
E0 <- glass$RI - reg$y
# print(sum(E0^2))
nu0 <- tr(reg$L)
nnu0 <- tr(t(reg$L) %*% reg$L)
sigma02 <- sum(E0^2) / (n - 2*nu0 + nnu0)
sprintf("sigma^2 = %f", sigma02)


# Local linear regression
H <- seq(0.2, 0.35, 0.005)
CV1 <- sapply(H, function(h) { CV(glass$Al, glass$RI, h, degree = 1) })
plot(H, CV1, type = "l", xlab = "h", ylab = "OCV")
title("Cross-Validation error (local linear regression)")
h1 <- H[which.min(CV1)]
sprintf("Local linear regression: h = %f, CV = %f", h1, min(CV1))

glass.kreg1 <- kernelregpoly(x, glass$Al, glass$RI, h1, degree = 1)
plot(glass$Al, glass$RI, xlab = "Al", ylab = "RI")
lines(x, glass.kreg1$y, lwd = 2)
title("Local linear regression")

reg1 <- kernelregpoly(glass$Al, glass$Al, glass$RI, h0, degree = 1)
E1 <- glass$RI - reg1$y
# print(sum(E1^2))
nu1 <- tr(reg1$L)
nnu1 <- tr(t(reg1$L) %*% reg1$L)
sigma12 <- sum(E1^2) / (n - 2*nu1 + nnu1)
sprintf("sigma^2 = %f", sigma12)


# Spline regression
glass.ss <- ss(glass$Al, glass$RI, all.knots = TRUE, method = "OCV")
print(glass.ss)
sprintf("sigma^2 = %f", glass.ss$sigma^2)

plot(glass$Al, glass$RI, xlab = "Al", ylab = "RI")
lines(glass.ss, lwd = 2)
title("Cubic spline regression")


plot(glass$Al, glass$RI, xlab = "Al", ylab = "RI")
abline(lm(RI ~ Al, data = glass), lwd = 2, lty = "dashed")
lines(x, glass.kreg$y, lwd = 2, col = "red")
lines(x, glass.kreg1$y, lwd = 2, col = "green")
lines(glass.ss, lwd = 2, col = "blue")


dev.off()
