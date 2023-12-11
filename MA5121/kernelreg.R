#!/usr/bin/env Rscript

library(MASS)

# Perform kernel regression
kernelreg <- function(x0, x, y, h, kernel = dnorm) {
        W <- sapply(x0, function(s) { kernel((s - x) / h) })
        W <- apply(W, 2, function(l) { l / sum(l) })
        return(list(
                "y" = y %*% W,
                "L" = W
        ))
}

# Perform local polynomial regression
kernelregpoly <- function(x0, x, y, h, degree = 2, kernel = dnorm) {
        if (degree == 0) {
                return(kernelreg(x0, x, y, h, kernel = kernel))
        }
        L <- sapply(x0, function(s) {
                X <- sapply(seq(0, degree), function(d) { (x - s)^d })
                W <- kernel((s - x) / h)
                if (abs(sum(W)) > 0) {
                        W <- W / sum(W)
                }
                W <- diag(W)
                B <- ginv(t(X) %*% W %*% X) %*% t(X) %*% W
                return(B[1, ])
        })
        return(list(
                "y" = y %*% L,
                "L" = L
        ))
}

# Calculate the ordinary cross-validation score
CV <- function(x, y, h, degree = 0, kernel = dnorm) {
        n <- length(x)
        reg <- kernelregpoly(x, x, y, h, degree = degree, kernel = kernel)
        L <- diag(reg$L)
        E <- ((y - reg$y) / (1 - L))^2
        return(mean(E))
}



# x <- runif(50, min = 0, max = 2 * pi)
# y <- cos(x) + rnorm(length(x), sd = 0.1)
# plot(x, y)

# x0 <- seq(0, 2 * pi, length.out = 100)
# lines(x0, kernelreg(x0, x, y, 1.0), lwd = 3)
# lines(x0, kernelreg(x0, x, y, 0.5), lwd = 2)
# lines(x0, kernelreg(x0, x, y, 0.25), lwd = 1)
