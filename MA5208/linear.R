#!/usr/bin/env Rscript

tau2.alpha <- 1 / rgamma(1, shape = 1)
tau2.beta  <- 1 / rgamma(1, shape = 1)
alpha0 <- rnorm(1, mean = 0, sd = 10)
beta0  <- rnorm(1, mean = 0, sd = sqrt(tau2.beta))

alpha <- c(alpha0)
beta  <- c(beta0)

T <- 50
I <- 10

for (t in 1:T) {
        alpha.t <- rnorm(1, mean = alpha[t], sd = sqrt(tau2.alpha))
        beta.t  <- rnorm(1, mean = beta[t],  sd = sqrt(tau2.beta))
        alpha <- c(alpha, alpha.t)
        beta  <- c(beta,  beta.t)
}

alpha <- matrix(alpha[-1])
beta  <- matrix(beta[-1])

sigma2 <- 1 / rgamma(T, shape = 1)
epsilon <- sapply(sigma2, function(s2) rnorm(I, mean = 0, sd = sqrt(s2)))

X <- matrix(rnorm(I * T), I)
theta <- t(apply(X, 1, function(x) (alpha + beta * x))) + epsilon

Y <- matrix(rpois(length(theta), exp(theta)), I)



####


f.Y <- function(i, t) function(P, x = NULL) {
        if (!is.null(x)) { P$Y[i, t] = x }
        dpois(P$Y[i, t], exp(P$alpha[t] + P$beta[t] * X[i, t] + P$epsilon[i, t]))
}
fc.epsilon <- function(i, t) function(P, x = NULL) {
        if (!is.null(x)) { P$epsilon[i, t] = x }
        dnorm(P$epsilon[i, t], sd = sqrt(P$sigma2[t])) *
                (f.Y(i, t))(P)
}
fc.alpha <- function(t) function(P, x = NULL) {
        if (!is.null(x)) { P$alpha[t] = x }
        if (t == 1) {
                return(
                        dnorm(P$alpha[t], mean = P$alpha0, sd = sqrt(P$tau2.alpha)) *
                                dnorm(P$alpha[t + 1], mean = P$alpha[t], sd = sqrt(P$tau2.alpha)) *
                                prod(sapply(1:I, function(i) (f.Y(i, t))(P)))
                )
        }
        if (t == T) {
                return(
                        dnorm(P$alpha[t], mean = P$alpha[t - 1], sd = sqrt(P$tau2.alpha)) *
                                prod(sapply(1:I, function(i) (f.Y(i, t))(P)))
                )
        }
        return(
                dnorm(P$alpha[t], mean = P$alpha[t - 1], sd = sqrt(P$tau2.alpha)) *
                        dnorm(P$alpha[t + 1], mean = P$alpha[t], sd = sqrt(P$tau2.alpha)) *
                        prod(sapply(1:I, function(i) (f.Y(i, t))(P)))
        )
}
fc.beta <- function(t) function(P, x = NULL) {
        if (!is.null(x)) { P$beta[t] = x }
        if (t == 1) {
                return(
                        dnorm(P$beta[t], mean = P$beta0, sd = sqrt(P$tau2.beta)) *
                                dnorm(P$beta[t + 1], mean = P$beta[t], sd = sqrt(P$tau2.beta)) *
                                prod(sapply(1:I, function(i) (f.Y(i, t))(P)))
                )
        }
        if (t == T) {
                return(
                        dnorm(P$beta[t], mean = P$beta[t - 1], sd = sqrt(P$tau2.beta)) *
                                prod(sapply(1:I, function(i) (f.Y(i, t))(P)))
                )
        }
        return(
                dnorm(P$beta[t], mean = P$beta[t - 1], sd = sqrt(P$tau2.beta)) *
                        dnorm(P$beta[t + 1], mean = P$beta[t], sd = sqrt(P$tau2.beta)) *
                        prod(sapply(1:I, function(i) (f.Y(i, t))(P)))
        )
}

metropolis.hastings <- function(
        f,
        x0 = 0,
        proposal = function(y) rnorm(1, mean = y),
        N = 1000
) {
        x <- x0
        for (i in 1:1000) {
                x.new <- proposal(x)
                alpha <- f(x.new) / f(x)
                if (runif(1) <= alpha) {
                        x <- x.new
                }
        }
        return(x)
}

# Parameter list
P <- list(X = X, Y = Y, alpha = alpha, beta = beta, alpha0 = alpha0, beta0 = beta0, tau2.alpha = tau2.alpha, tau2.beta = tau2.beta, epsilon = epsilon)

# Metropolis-Hastings for beta[3]
f <- function(x) fc.beta(3)(P, x = x)
b <- replicate(
        200,
        metropolis.hastings(
                f,
                x0 = 0,
                # proposal = function(y) rnorm(1, mean = y, sd = sqrt(P$tau2.beta)),
                N = 500
        )
)
x <- seq(min(b), max(b), length.out = 100)
y <- sapply(x, f)
A <- mean(y) * (max(x) - min(x))
hist(b, freq = FALSE)
lines(x, y / A)
