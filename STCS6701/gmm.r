#!/usr/bin/env Rscript

library(MCMCprecision)

# Generate data from a Gaussian mixture
mixture.data.generate <- function(N, K, m.0, a.0, b.0, k.0, alpha) {
        pi <- rdirichlet(1, alpha)
        lambda <- rgamma(K, a.0, b.0)
        mu <- rnorm(K, m.0, 1/sqrt(k.0 * lambda))
        z <- sample.int(K, N, prob = pi, replace = TRUE)
        x <- rnorm(N, mu[z], 1/sqrt(lambda[z]))
        environment()
}


# Gibbs sampler for Gaussian mixture
gmm.gibbs.blocked <- function(
        x, n.samples, burn = n.samples / 2,
        K, m.0, a.0, b.0, k.0, alpha,
        pi.0, lambda.0, mu.0, z.0,
        refresh = 200, verbose = TRUE
) {
        N <- length(x)

        pi     <- array(dim = c(K, burn + n.samples + 1))
        lambda <- array(dim = c(K, burn + n.samples + 1))
        mu     <- array(dim = c(K, burn + n.samples + 1))
        z      <- array(dim = c(N, burn + n.samples + 1))

        N.k_   <- array(dim = c(K, burn + n.samples + 1))

        log.joint <- array(dim = (burn + n.samples))

        pi[, 1]     <- pi.0
        lambda[, 1] <- lambda.0
        mu[, 1]     <- mu.0
        z[, 1]      <- z.0


        if (verbose && !is.na(refresh)) cat(sprintf("Iteration %5d", 0))
        for (i in 1:(burn + n.samples)) {

                N.k   <- sapply(1:K, function(k) sum(z[, i] == k))
                S.k.1 <- sapply(1:K, function(k) sum(x[z[, i] == k]))
                S.k.2 <- sapply(1:K, function(k) sum(x[z[, i] == k]^2))

                N.k_[, i + 1]  <- N.k

                pi[, i + 1] <- rdirichlet(1, alpha + N.k)
                lambda[, i + 1] <- rgamma(
                        K,
                        a.0 + 0.5 * (N.k + 1),
                        b.0 + 0.5 * k.0 * (mu[, i] - m.0)^2 + 0.5 * S.k.2 - mu[, i] * S.k.1 + 0.5 * N.k * mu[, i]^2
                )
                mu[, i + 1] <- rnorm(
                        K,
                        (k.0 * m.0 + S.k.1) / (k.0 + N.k),
                        1/sqrt(lambda[, i + 1] * (k.0 + N.k))
                )

                z[, i + 1] <- sapply(1:N, function(n) sample.int(
                                K, 1,
                                prob = pi[, i + 1] * sqrt(lambda[, i + 1]) * exp(-0.5 * lambda[, i + 1] * (x[n] - mu[, i + 1])^2),
                                replace = TRUE
                        )
                )

                if (!is.na(refresh) && ((i %% refresh) == 0)) {
                        log.joint[i] <- sum(dnorm(x, mu[z[, i + 1]], 1/sqrt(lambda[z[, i + 1]]), log = TRUE)) +
                                sum((N.k + alpha - 1) * log(pi[, i + 1]))
                }

                if (verbose && !is.na(refresh) && ((i %% refresh) == 0)) {
                        if (i <= burn) {
                                cat(sprintf("\rIteration %5d (Burn) %16.4f", i, log.joint[i]))
                        } else {
                                cat(sprintf("\rIteration %5d        %16.4f", i, log.joint[i]))
                        }
                }

        }

        if (verbose && !is.na(refresh)) cat("\n")

        pi     <- pi[,     (burn + 2):(burn + n.samples + 1)]
        lambda <- lambda[, (burn + 2):(burn + n.samples + 1)]
        mu     <- mu[,     (burn + 2):(burn + n.samples + 1)]
        z      <- z[,      (burn + 2):(burn + n.samples + 1)]
        N.k_   <- N.k_[,   (burn + 2):(burn + n.samples + 1)]


        # Posterior predictive sample
        predictive.sample <- function() {
                sapply(1:n.samples, function(i) {
                        k <- sample.int(K, 1, prob = pi[, i])
                        rnorm(1, mu[k, i], 1/sqrt(lambda[k, i]))
                })
        }

        # Posterior predictive density
        predictive.density <- function(x) {
                sapply(x, function(x_) mean(colSums(pi * dnorm(x_, mu, 1/sqrt(lambda)))))
        }

        # Expected log predictive density
        elpd <- function(x.out) {
                mean(log(predictive.density(x.out)))
        }

        return(list(
                pi     = pi,
                lambda = lambda,
                mu     = mu,
                z      = z,
                N.k    = N.k_,
                log.joint = log.joint,
                predictive.sample = predictive.sample,
                predictive.density = predictive.density,
                elpd = elpd
        ))
}


# Collapsed Gibbs sampler for Gaussian mixture
gmm.gibbs.collapsed <- function(
        x, n.samples, burn = n.samples / 2,
        K, m.0, a.0, b.0, k.0, alpha,
        pi.0, z.0,
        refresh = 200, verbose = TRUE
) {
        N <- length(x)
        x.2 <- x^2

        pi <- array(dim = c(K, burn + n.samples + 1))
        z  <- array(dim = c(N, burn + n.samples + 1))

        nu.k_ <- array(dim = c(K, burn + n.samples + 1))
        m.k_  <- array(dim = c(K, burn + n.samples + 1))
        s.k_  <- array(dim = c(K, burn + n.samples + 1))
        N.k_  <- array(dim = c(K, burn + n.samples + 1))

        log.joint <- array(dim = (burn + n.samples))

        pi[, 1] <- pi.0
        z[, 1]  <- z.0

        N.k   <- sapply(1:K, function(k) sum(z[, 1] == k))
        S.k.1 <- sapply(1:K, function(k) sum(x[z[, 1] == k]))
        S.k.2 <- sapply(1:K, function(k) sum(x.2[z[, 1] == k]))
        x.bar.k <- S.k.1 / N.k
        x.bar.k[N.k == 0] <- 0
        a.k <- a.0 + N.k / 2
        b.k <- b.0 + 0.5 * k.0 * N.k * (m.0 - x.bar.k)^2 / (k.0 + N.k) + 0.5 * (S.k.2 - N.k * x.bar.k^2)
        m.k <- (k.0 * m.0 + S.k.1) / (k.0 + N.k)
        k.k <- k.0 + N.k
        nu.k <- 2 * a.k
        s.k <- sqrt(b.k * (k.k + 1) / (a.k * k.k))


        if (verbose && !is.na(refresh)) cat(sprintf("Iteration %5d", 0))
        for (i in 1:(burn + n.samples)) {

                pi[, i + 1] <- rdirichlet(1, alpha + N.k)

                z.now <- z[, i]
                for (n in 1:N) {
                        k <- z.now[n]

                        # Recompute after removing x_n from component k
                        N.k[k]<- N.k[k] - 1
                        S.k.1[k] <- S.k.1[k] - x[n]
                        S.k.2[k] <- S.k.2[k] - x.2[n]
                        x.bar.k[k] <- S.k.1[k] / N.k[k]
                        x.bar.k[N.k == 0] <- 0
                        a.k[k] <- a.0 + N.k[k] / 2
                        b.k[k] <- b.0 + 0.5 * k.0 * N.k[k] * (m.0 - x.bar.k[k])^2 / (k.0 + N.k[k]) + 0.5 * (S.k.2[k] - N.k[k] * x.bar.k[k]^2)
                        m.k[k] <- (k.0 * m.0 + S.k.1[k]) / (k.0 + N.k[k])
                        k.k[k] <- k.0 + N.k[k]
                        nu.k[k] <- 2 * a.k[k]
                        s.k[k] <- sqrt(b.k[k] * (k.k[k] + 1) / (a.k[k] * k.k[k]))

                        p.pred <- dt((x[n] - m.k) / s.k, nu.k) / s.k

                        z.now[n] <- k <- sample.int(
                                K, 1,
                                prob = pi[, i + 1] * p.pred,
                                replace = TRUE
                        )

                        # Recompute after adding x_n to (newly assigned) component k
                        N.k[k]<- N.k[k] + 1
                        S.k.1[k] <- S.k.1[k] + x[n]
                        S.k.2[k] <- S.k.2[k] + x.2[n]
                        x.bar.k[k] <- S.k.1[k] / N.k[k]
                        x.bar.k[N.k == 0] <- 0
                        a.k[k] <- a.0 + N.k[k] / 2
                        b.k[k] <- b.0 + 0.5 * k.0 * N.k[k] * (m.0 - x.bar.k[k])^2 / (k.0 + N.k[k]) + 0.5 * (S.k.2[k] - N.k[k] * x.bar.k[k]^2)
                        m.k[k] <- (k.0 * m.0 + S.k.1[k]) / (k.0 + N.k[k])
                        k.k[k] <- k.0 + N.k[k]
                        nu.k[k] <- 2 * a.k[k]
                        s.k[k] <- sqrt(b.k[k] * (k.k[k] + 1) / (a.k[k] * k.k[k]))
                }
                z[, i + 1] <- z.now

                nu.k_[, i + 1] <- nu.k
                m.k_[, i + 1]  <- m.k
                s.k_[, i + 1]  <- s.k
                N.k_[, i + 1]  <- N.k

                if (!is.na(refresh) && ((i %% refresh) == 0)) {
                        log.joint[i] <- sum(dt((x - m.k[z.now]) / s.k[z.now], nu.k[z.now], log = TRUE) - log(s.k[z.now])) +
                                sum((N.k + alpha - 1) * log(pi[, i + 1]))
                }

                if (verbose && !is.na(refresh) && ((i %% refresh) == 0)) {
                        if (i <= burn) {
                                cat(sprintf("\rIteration %5d (Burn) %16.4f", i, log.joint[i]))
                        } else {
                                cat(sprintf("\rIteration %5d        %16.4f", i, log.joint[i]))
                        }
                }
        }

        if (verbose && !is.na(refresh)) cat("\n")

        pi <- pi[, (burn + 2):(burn + n.samples + 1)]
        z  <- z[,  (burn + 2):(burn + n.samples + 1)]

        nu.k_ <- nu.k_[, (burn + 2):(burn + n.samples + 1)]
        m.k_  <- m.k_[,  (burn + 2):(burn + n.samples + 1)]
        s.k_  <- s.k_[,  (burn + 2):(burn + n.samples + 1)]
        N.k_  <- N.k_[,  (burn + 2):(burn + n.samples + 1)]

        # Posterior predictive sample
        predictive.sample <- function() {
                sapply(1:n.samples, function(i) {
                        k <- sample.int(K, 1, prob = pi[, i])
                        s.k_[k, i] * rt(1, nu.k_[k, i]) + m.k_[k, i]
                })
        }

        # Posterior predictive density
        predictive.density <- function(x) {
                sapply(x, function(x_) mean(colSums(pi * dt((x_ - m.k_) / s.k_, nu.k_) / s.k_)))
        }

        # Expected log predictive density
        elpd <- function(x.out) {
                mean(log(predictive.density(x.out)))
        }

        return(list(
                pi  = pi,
                z   = z,
                m   = m.k_,
                s   = s.k_,
                nu  = nu.k_,
                N.k = N.k_,
                log.joint = log.joint,
                predictive.sample = predictive.sample,
                predictive.density = predictive.density,
                elpd = elpd
        ))
}
