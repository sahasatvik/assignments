#!/usr/bin/env Rscript

#
# Sampling from *univariate* Gaussian mixture model with Potts-Markov prior
#


# Samples from Potts model
potts.gibbs <- function(
        neighbors, beta, z.0,
        n.samples, burn = n.samples / 2,
        weights = matrix(1, nrow = length(z.0), ncol = length(beta)),
        refresh = 200, verbose = TRUE
) {
        N <- length(z.0)
        K <- length(beta)

        z <- array(dim = c(N, burn + n.samples + 1))
        z[, 1] <- z.0

        U <- array(dim = c(N, K))
        for (j in 1:N) {
                for (k in 1:K) {
                        U[j, k] <- sum(z.0[neighbors[[j]]] == k, na.rm = TRUE)
                }
        }

        if (verbose && !is.na(refresh)) cat(sprintf("Iteration %5d", 0))
        for (i in 1:(burn + n.samples)) {
                z.now <- z[, i]
                for (j in sample(1:N)) {
                        U[neighbors[[j]], z.now[j]] <- U[neighbors[[j]], z.now[j]] - 1
                        prob <- exp(beta * U[j, ]) * weights[j, ]
                        z.now[j] <- sample.int(K, 1, prob = prob)
                        U[neighbors[[j]], z.now[j]] <- U[neighbors[[j]], z.now[j]] + 1
                }
                z[, i + 1] <- z.now
                if (verbose && !is.na(refresh) && ((i %% refresh) == 0)) {
                        if (i <= burn) {
                                cat(sprintf("\rIteration %5d (Burn)", i))
                        } else {
                                cat(sprintf("\rIteration %5d       ", i))
                        }
                }
        }

        if (verbose && !is.na(refresh)) cat("\n")

        z <- z[, (burn + 2):(burn + n.samples + 1)]
        return(list(
                z = z
        ))
}

potts.gibbs <- compiler::cmpfun(potts.gibbs)


# Posterior samples from univariate Gaussian mixture with Potts-Markov prior
gmm.potts.gibbs <- function(
        x, neighbors, K,
        a.0, b.0, a.beta, b.beta, m.0, kappa.0,
        mu.0, lambda.0, z.0, beta.0,
        n.samples, burn = n.samples / 2,
        fixed.beta = FALSE,
        n.mh.beta = 10, n.gibbs.aux = 10, sd.mh.beta = 0.1,
        refresh = 200, verbose = TRUE
) {
        N <- length(x)

        lambda  <- array(dim = c(K, burn + n.samples + 1))
        mu      <- array(dim = c(K, burn + n.samples + 1))
        beta    <- array(dim = c(K, burn + n.samples + 1))
        z       <- array(dim = c(N, burn + n.samples + 1))

        lambda[, 1]     <- lambda.0     # Precisions
        mu[, 1]         <- mu.0         # Means
        beta[, 1]       <- beta.0       # Potts temperatures
        z[, 1]          <- z.0          # Labels

        log.likelihoods <- array(dim = c(N, K))


        # z.N[k] counts the number of items with label k
        z.N <- sapply(1:K, function(k) sum(z.0 == k, na.rm = TRUE))

        # U[j, k] counts the number of neighbors of j with label k
        U <- array(dim = c(N, K))
        for (j in 1:N) {
                for (k in 1:K) {
                        U[j, k] <- sum(z.0[neighbors[[j]]] == k, na.rm = TRUE)
                }
        }

        # T.z[k] counts the number of edges with both ends labeled k
        T.z <- 0.5 * sapply(1:K, function(k) sum(U[z.0 == k, k], na.rm = TRUE))


        if (verbose && !is.na(refresh)) cat(sprintf("Iteration %5d", 0))
        for (i in 1:(burn + n.samples)) {

                x.S.1 <- sapply(1:K, function(k) sum(x[z[, i] == k]))
                x.S.2 <- sapply(1:K, function(k) sum(x[z[, i] == k]^2))

                # Update precisions
                lambda[, i + 1] <- rgamma(
                        K,
                        a.0 + 0.5 * (z.N + 1),
                        b.0 + 0.5 * kappa.0 * (mu[, i] - m.0)^2 + 0.5 * x.S.2 - mu[, i] * x.S.1 + 0.5 * z.N * mu[, i]^2
                )

                # Update means
                mu[, i + 1] <- rnorm(
                        K,
                        (kappa.0 * m.0 + x.S.1) / (kappa.0 + z.N),
                        1/sqrt(lambda[, i + 1] * (kappa.0 + z.N))
                )

                # Compute Gaussian log-likelihoods for all data-cluster combinations
                for (k in 1:K) {
                        log.likelihoods[, k] <- dnorm(x, mu[k, i + 1], 1/sqrt(lambda[k, i + 1]), log = TRUE)
                }


                # Update labels
                order.z <- sample(1:N)
                z.now <- z[, i]
                for (j in order.z) {
                        z.N[z.now[j]] <- z.N[z.now[j]] - 1
                        T.z[z.now[j]] <- T.z[z.now[j]] - U[j, z.now[j]]
                        U[neighbors[[j]], z.now[j]] <- U[neighbors[[j]], z.now[j]] - 1
                        prob <- exp(beta[, i] * U[j, ] + log.likelihoods[j, ])
                        z.now[j] <- sample.int(K, 1, prob = prob)
                        U[neighbors[[j]], z.now[j]] <- U[neighbors[[j]], z.now[j]] + 1
                        T.z[z.now[j]] <- T.z[z.now[j]] + U[j, z.now[j]]
                        z.N[z.now[j]] <- z.N[z.now[j]] + 1
                }
                z[, i + 1] <- z.now

                # Update beta, using single variable exchange
                beta[, i + 1] <- beta[, i]
                beta.acceptance <- 0
                if (!fixed.beta) {
                        p.beta <- prod(dgamma(beta[, i + 1], a.beta, b.beta))

                        for (i.mh in 1:n.mh.beta) {
                                # Propose new beta
                                beta.star <- beta[, i + 1] + rnorm(K, 0, sd.mh.beta)

                                # Draw auxiliary variable z.star from Potts prior with parameter beta.star
                                z.star <- z.now         # Initialize with current z
                                T.z.star <- T.z
                                U.star <- U
                                for (i.aux in 1:n.gibbs.aux) {
                                        for (j in order.z) {
                                                T.z.star[z.star[j]] <- T.z.star[z.star[j]] - U.star[j, z.star[j]]
                                                U.star[neighbors[[j]], z.star[j]] <- U.star[neighbors[[j]], z.star[j]] - 1
                                                prob <- exp(beta.star * U.star[j, ])
                                                z.star[j] <- sample.int(K, 1, prob = prob)
                                                U.star[neighbors[[j]], z.star[j]] <- U.star[neighbors[[j]], z.star[j]] + 1
                                                T.z.star[z.star[j]] <- T.z.star[z.star[j]] + U.star[j, z.star[j]]
                                        }
                                }

                                # Compute Metropolis-Hastings acceptance
                                p.beta.star <- prod(dgamma(beta.star, a.beta, b.beta))
                                alpha <- p.beta.star / p.beta * exp(sum((beta.star - beta[i + 1]) * (T.z - T.z.star)))

                                # Accept with probability alpha
                                if (runif(1) < alpha) {
                                        beta[, i + 1] <- beta.star
                                        p.beta <- p.beta.star
                                        beta.acceptance <- beta.acceptance + 1
                                }
                        }
                }



                if (verbose && !is.na(refresh) && ((i %% refresh) == 0)) {
                        if (i <= burn) {
                                cat(sprintf("\rIteration %5d (Burn), %.3f MH acceptance", i, beta.acceptance / n.mh.beta))
                        } else {
                                cat(sprintf("\rIteration %5d       , %.3f MH acceptance", i, beta.acceptance / n.mh.beta))
                        }
                }
        }

        if (verbose && !is.na(refresh)) cat("\n")


        # Discard burn-in samples
        lambda  <- lambda[, (burn + 2):(burn + n.samples + 1)]
        mu      <- mu[,     (burn + 2):(burn + n.samples + 1)]
        beta    <- beta[,   (burn + 2):(burn + n.samples + 1)]
        z       <- z[,      (burn + 2):(burn + n.samples + 1)]

        return(list(
                lambda = lambda,
                mu     = mu,
                beta   = beta,
                z      = z
        ))
}

gmm.potts.gibbs <- compiler::cmpfun(gmm.potts.gibbs)
