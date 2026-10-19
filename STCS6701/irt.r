#!/usr/bin/env Rscript


irt.cavi <- function(
        Y,
        iterations = 1000, verbose = TRUE,
        mu.theta = 0, sigma.theta.2 = 1,
        mu.alpha = 1, sigma.alpha.2 = 1,
        mu.beta  = 0, sigma.beta.2 = 1
) {

        present <- (Y == 0 | Y == 1)    # Non-missing votes
        mask <- Y                       # Mask for present votes
        mask[present]  <- 1
        mask[is.na(Y)] <- 0

        n <- nrow(Y)                    # Number of senators
        d <- ncol(Y)                    # Number of bills


        # Relative entropy for Gaussians
        .H <- function(m.1, m.2, s2.1, s2.2) {
                0.5 * (log(s2.2 / s2.1) + 1 - (s2.2 / s2.1) - (m.2 - m.1)^2 / s2.1)
        }

        # Initialize variational parameters using prior values

        mu.theta.q <- rep(mu.theta, n)
        mu.alpha.q <- rep(mu.alpha, d)
        mu.beta.q  <- rep(mu.beta,  d)

        sigma.theta.2.q <- rep(sigma.theta.2, n)
        sigma.alpha.2.q <- rep(sigma.alpha.2, d)
        sigma.beta.2.q  <- rep(sigma.beta.2,  d)

        E.theta <- replicate(d, mu.theta.q)
        E.theta.2 <- replicate(d, mu.theta.q^2 + sigma.theta.2.q)

        E.alpha <- t(replicate(n, mu.alpha.q))
        E.alpha.2 <- t(replicate(n, mu.alpha.q^2 + sigma.alpha.2.q))

        E.beta <- t(replicate(n, mu.beta.q))
        E.beta.2 <- t(replicate(n, mu.beta.q^2 + sigma.beta.2.q))

        ELBO <- numeric(iterations)

        if (verbose) {
                cat(sprintf("Iteration %5d", 0))
        }

        for (iteration in 1:iterations) {

                # Update q(z)
                mu.z.q <- E.alpha * (E.theta - E.beta)
                E.z <- mu.z.q + sign(Y - 0.5) * dnorm(mu.z.q) / (0.5 - sign(Y - 0.5) * (0.5 - pnorm(mu.z.q)))

                # Update q(theta)
                sigma.theta.2.q <- 1/(1/sigma.theta.2 + rowSums(E.alpha.2 * mask))
                mu.theta.q <- sigma.theta.2.q * (mu.theta / sigma.theta.2 + rowSums((E.alpha * E.z + E.alpha.2 * E.beta) * mask, na.rm = TRUE))

                E.theta <- replicate(d, mu.theta.q)
                E.theta.2 <- replicate(d, mu.theta.q^2 + sigma.theta.2.q)

                # Update q(beta)
                sigma.beta.2.q <- 1/(1/sigma.beta.2 + colSums(E.alpha.2 * mask))
                mu.beta.q <- sigma.beta.2.q * (mu.beta / sigma.beta.2 - colSums((E.alpha * E.z - E.alpha.2 * E.theta) * mask, na.rm = TRUE))

                E.beta <- t(replicate(n, mu.beta.q))
                E.beta.2 <- t(replicate(n, mu.beta.q^2 + sigma.beta.2.q))

                # Update q(alpha)
                sigma.alpha.2.q <- 1/(1/sigma.alpha.2 + colSums((E.theta.2 + E.beta.2 - 2 * E.theta * E.beta) * mask))
                mu.alpha.q <- sigma.alpha.2.q * (mu.alpha / sigma.alpha.2 + colSums(((E.theta - E.beta) * E.z) * mask, na.rm = TRUE))

                E.alpha <- t(replicate(n, mu.alpha.q))
                E.alpha.2 <- t(replicate(n, mu.alpha.q^2 + sigma.alpha.2.q))

                # Compute ELBO
                ELBO[iteration] <- sum(.H(mu.theta, mu.theta.q, sigma.theta.2, sigma.theta.2.q)) +
                                        sum(.H(mu.alpha, mu.alpha.q, sigma.alpha.2, sigma.alpha.2.q)) +
                                        sum(.H(mu.beta, mu.beta.q, sigma.beta.2, sigma.beta.2.q)) +
                                        0.5 * sum((2 * E.z - mu.z.q - E.z) * (mu.z.q - E.z) * mask, na.rm = TRUE)

                if (verbose) {
                        cat(sprintf("\rIteration %5d, ELBO = %8.4f", iteration, ELBO[iteration]))
                }

        }

        if (verbose) { cat("\n") }


        # Log posterior predictive density of y_ij
        # Approximated by Monte-Carlo sampling from the variational posterior
        log.predictive <- function(y, i, j, samples = 1000) {
                theta <- rnorm(samples, mu.theta.q[i], sqrt(sigma.theta.2.q[i]))
                alpha <- rnorm(samples, mu.alpha.q[j], sqrt(sigma.alpha.2.q[j]))
                beta  <- rnorm(samples, mu.beta.q[j],  sqrt(sigma.beta.2.q[j]))
                mu    <- alpha * (theta - beta)
                mean(y * log(pnorm(mu)) + (1 - y) * log(1 - pnorm(mu)))
        }

        # Average log posterior predictive density of {y_ij}
        average.log.predictive <- function(y, ij, samples = 1000) {
                mean(sapply(1:length(y), function(k) {
                        log.predictive(y[k], ij[k, 1], ij[k, 2], samples = samples)
                }))
        }

        # Posterior predictive probability of of y_ij = 1
        # Approximated by Monte-Carlo sampling from the variational posterior
        .predictive.prob <- function(y, i, j, samples = 1000) {
                theta <- rnorm(samples, mu.theta.q[i], sqrt(sigma.theta.2.q[i]))
                alpha <- rnorm(samples, mu.alpha.q[j], sqrt(sigma.alpha.2.q[j]))
                beta  <- rnorm(samples, mu.beta.q[j],  sqrt(sigma.beta.2.q[j]))
                mu    <- alpha * (theta - beta)
                mean(pnorm(mu))
        }

        # Posterior predictive probabilities of {y_ij}
        predictive.prob <- function(y, ij, samples = 1000) {
                sapply(1:length(y), function(k) {
                        .predictive.prob(y[k], ij[k, 1], ij[k, 2], samples = samples)
                })
        }


        environment()
}

