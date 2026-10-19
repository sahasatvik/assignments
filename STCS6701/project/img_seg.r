#!/usr/bin/env Rscript

source("potts.r")

library(pixmap)
library(foreach)

img.file <- "108073"
K <- 3

# img.file <- "253036"
# K <- 5

# img.file <- "37073"
# K <- 8

# img.file <- "35058"

# img.file <- "198054"
# K <- 3

# img.file <- "253027"
# K <- 3

# img.file <- "295087"
# K <- 8

# img.file <- "42049"
# K <- 5

# img.file <- "43074"
# K <- 5

# img.file <- "38092"
# K <- 7

# img.file <- "86000"
# K <- 5

# img.file <- "300091"
# K <- 5


beta0 <- 1.0

img <- read.pnm(sprintf("img/%s.ppm", img.file))
img.r <- c(img@red)
img.g <- c(img@green)
img.b <- c(img@blue)
img.rgb <- cbind(img.r, img.g, img.b)
img.x <- img.r
img.size <- img@size
N <- length(img.x)
D <- 3

# Compute neighbors of each location
neighbors <- function(i, size) {
        y <- c(i - size[1], i + size[1])
        if ((i %% size[1]) != 1) y <- c(y, i - 1, i - size[1] - 1, i + size[1] - 1);
        if ((i %% size[1]) != 0) y <- c(y, i + 1, i - size[1] + 1, i + size[1] + 1);
        sort(y[1 <= y & y <= size[1] * size[2]])
}

img.neighbors <- sapply(
        1:N,
        function(i) neighbors(i, img.size),
        simplify = FALSE
)


# K <- 4
# n.samples <- 30
# beta <- rep(3.0, K)

# Use KMeans as initial labels
img.kmeans <- kmeans(img.rgb, K)
z.0 <- img.kmeans$cluster

# Use Gaussian likelihoods as weights
# W <- matrix(1, nrow = N, ncol = K)
# for (k in 1:K) {
#         W[, k] <- dnorm(img.x, img.kmeans$centers[k], sqrt(var(img.x[img.kmeans$cluster == k])))
# }

# z.potts <- potts.gibbs(
#         img.neighbors, beta, z.0,
#         n.samples = n.samples, burn = 0,
#         weights = W,
#         refresh = 1
# )$z

# Rcpp::sourceCpp("potts_gibbs_rcpp.cpp")

# z.potts <- potts_gibbs_rcpp(198054.jpg
#     neighbors = img.neighbors,
#     beta = beta,
#     z0 = z.0,
#     n_samples = n.samples,
#     burn = 0,
#     weights = W
# )

n.samples <- 500


# Rcpp::sourceCpp("gmm_potts_gibbs_rcpp.cpp")

# Rcpp::sourceCpp("potts_rcpp.cpp")

# posterior <- gmm_potts_gibbs_rcpp(
#         img.x, img.neighbors, K,
#         a0 = 1, b0 = 1, a_beta = 2, b_beta = 2,
#         m0 = 0.5, kappa0 = 0.1,
#         mu0 = img.kmeans$centers,
#         lambda0 = 1/sqrt(sapply(1:K, function(k) var(img.x[img.kmeans$cluster == k]))),
#         z0 = img.kmeans$cluster,
#         beta0 = rep(0.5, K),
#         n_samples = n.samples, burn = n.samples / 2,
#         n_mh_beta = 20, n_gibbs_aux = 5, sd_mh_beta = 0.01,
#         verbose = TRUE, refresh = 1,
#         # fixed_beta = TRUE
# )

# posterior <- gmm.potts.gibbs(
#         img.x, img.neighbors, K,
#         a.0 = 1, b.0 = 1, a.beta = 2, b.beta = 2,
#         m.0 = 0.5, kappa.0 = 0.1,
#         mu.0 = img.kmeans$centers,
#         lambda.0 = 1/sqrt(sapply(1:K, function(k) var(img.x[img.kmeans$cluster == k]))),
#         z.0 = img.kmeans$cluster,
#         beta.0 = rep(1.0, K),
#         n.samples = n.samples, burn = n.samples / 2,
#         n.mh.beta = 20, n.gibbs.aux = 5, sd.mh.beta = 0.01,
#         verbose = TRUE, refresh = 1,
# )


# Estimate covariances from KMeans
Sigma.0 <- list()
for(k in 1:K) {
    obs <- img.rgb[z.0 == k, , drop=FALSE]
    if(nrow(obs) > 2) {
        Sigma.0[[k]] <- cov(obs)
    } else {
        Sigma.0[[k]] <- diag(0.01, D)
    }
}


Rcpp::sourceCpp("potts_mv_rcpp.cpp")


# Naive GMM
posterior.gmm <- gmm_mv_potts_gibbs_rcpp(
        img.rgb, img.neighbors, K,
        a_beta = 2, b_beta = 2,
        m0 = rep(0.5, D), kappa0 = 0.01, nu0 = 5, S0 = diag(1/K, D),
        mu0 = img.kmeans$centers,
        Sigma0 = Sigma.0,
        z0 = img.kmeans$cluster,
        beta0 = rep(0.0, K),
        n_samples = n.samples, burn = n.samples / 2,
        n_mh_beta = 10, n_gibbs_aux = 5, sd_mh_beta = 0.005,
        target_acceptance_rate = 0.30,
        verbose = TRUE, refresh = 1,
        fixed_beta = TRUE
)

# Potts mixture with fixed smoothness beta
posterior.fixed <- gmm_mv_potts_gibbs_rcpp(
        img.rgb, img.neighbors, K,
        a_beta = 2, b_beta = 2,
        m0 = rep(0.5, D), kappa0 = 0.01, nu0 = 5, S0 = diag(1/K, D),
        # mu0 = matrix(runif(K * D), nrow = K, ncol = D),
        # Sigma0 = sapply(1:K, function(k) diag(1e-3, D), simplify = FALSE),
        # z0 = sample.int(K, N, replace = TRUE),
        mu0 = img.kmeans$centers,
        Sigma0 = Sigma.0,
        z0 = img.kmeans$cluster,
        beta0 = rep(1.0, K),
        n_samples = n.samples, burn = n.samples / 2,
        n_mh_beta = 10, n_gibbs_aux = 5, sd_mh_beta = 0.005,
        target_acceptance_rate = 0.30,
        verbose = TRUE, refresh = 1,
        fixed_beta = TRUE
)

# Potts mixture
posterior <- gmm_mv_potts_gibbs_rcpp(
        img.rgb, img.neighbors, K,
        a_beta = 2, b_beta = 2,
        m0 = rep(0.5, D), kappa0 = 0.01, nu0 = 5, S0 = diag(1/K, D),
        # mu0 = matrix(runif(K * D), nrow = K, ncol = D),
        # Sigma0 = sapply(1:K, function(k) diag(1e-3, D), simplify = FALSE),
        # z0 = sample.int(K, N, replace = TRUE),
        mu0 = img.kmeans$centers,
        Sigma0 = Sigma.0,
        z0 = img.kmeans$cluster,
        beta0 = rep(beta0, K),
        # beta0 = rep(0.0, K),
        n_samples = n.samples, burn = n.samples / 2,
        # n_samples = n.samples, burn = 0,
        n_mh_beta = 10, n_gibbs_aux = 5, sd_mh_beta = 0.005,
        target_acceptance_rate = 0.30,
        verbose = TRUE, refresh = 1,
        # fixed_beta = TRUE
)

image.show <- function(x, size, xlab = "", col = NA) {
        # M <- t(apply(matrix(x, size[1]), 2, rev))
        # if (any(is.na(col))) {
        #         col <- grey(seq(0, 1, length.out = 256))
        # }
        # image(
        #         M,
        #         col = col,
        #         asp = size[1] / size[2],
        #         useRaster = TRUE,
        #         xlab = xlab,
        #         xaxt = "n",
        #         yaxt = "n",
        #         axes = FALSE,
        # )
        plot(
                pixmapRGB(x, nrow = size[1], ncol = size[2]),
                xlab = xlab
        )
}


img.seg.km <- img.kmeans$centers[img.kmeans$cluster, ]

# layout(matrix(c(1, 2), ncol = 2, byrow = TRUE))
# for (i in 1:n.samples) {
#         image.show(t(posterior$mu[, posterior$z[, i], i]), img.size)
#         Sys.sleep(0.1)
# }



Mode <- function(x) {
        ux <- unique(x)
        ux[which.max(tabulate(match(x, ux)))]
}

E.mu <- apply(posterior$mu, c(1, 2), mean)
img.col <- apply(E.mu, 2, function(x) rgb(x[1], x[2], x[3]))

img.seg.z <- apply(posterior$z, 1, Mode)
img.seg <- t(E.mu[, img.seg.z])


show.segmented <- function() {
        image.show(img.rgb, img.size)
        Sys.sleep(0.5)
        image.show(img.seg.km, img.size)
        Sys.sleep(0.5)
        image.show(img.seg, img.size)
}


E.beta <- apply(posterior$beta, 1, mean)

trace.beta <- function() {
        matplot(1:n.samples, t(posterior$beta), type = "l", lwd = 2, col = img.col)
}

box.beta <- function() {
        ord <- order(-E.beta)
        boxplot(
                as.data.frame(t(posterior$beta[ord, ])),
                col = img.col[ord],
                names = paste(1:K)[ord]
        )
}


save.image(file = sprintf("rdata/%s_K%d.RData", img.file, K))
