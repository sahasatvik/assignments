#!/usr/bin/env Rscript

library(pixmap)

# source("potts.r")
Rcpp::sourceCpp("potts_gibbs_rcpp.cpp")

neighbors <- function(i, size) {
        y <- c(i - size[1], i + size[1])
        if ((i %% size[1]) != 1) y <- c(y, i - 1, i - size[1] - 1, i + size[1] - 1);
        if ((i %% size[1]) != 0) y <- c(y, i + 1, i - size[1] + 1, i + size[1] + 1);
        sort(y[1 <= y & y <= size[1] * size[2]])
}


img.size <- c(200, 200)
N <- prod(img.size)
K <- 3

img.neighbors <- sapply(
        1:N,
        function(i) neighbors(i, img.size),
        simplify = FALSE
)

image.show <- function(x, size, xlab = "", col = NA) {
        plot(
                pixmapGrey(x, nrow = size[1], ncol = size[2]),
                xlab = xlab,
                useRaster = TRUE
        )
}

n.samples <- 50
z.0 <- sample.int(K, N, replace = TRUE)

for (beta.all in c(0, 1, 10)) {
        beta <- rep(beta.all, K)

        # img.potts <- potts.gibbs(
        #         img.neighbors, beta, z.0,
        #         n.samples, burn = 0, refresh = 1
        # )$z
        img.potts <- potts_gibbs_rcpp(
                neighbors = img.neighbors,
                beta = beta,
                z0 = z.0,
                n_samples = n.samples,
                burn = 0,
                weights = matrix(1, nrow = N, ncol = K)
        )

        pdf(sprintf("figures/potts_beta_%d.pdf", beta.all), width = 6, height = 6 * img.size[1] / img.size[2])
        par(mar = c(0, 0, 0, 0))
        image.show(img.potts[, n.samples], img.size)
        dev.off()
}

beta = c(1, 1.5, 1.5)
img.potts <- potts_gibbs_rcpp(
        neighbors = img.neighbors,
        beta = beta,
        z0 = z.0,
        n_samples = n.samples,
        burn = 0,
        weights = matrix(1, nrow = N, ncol = K)
)

pdf("figures/potts_beta_custom.pdf", width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))
image.show(img.potts[, n.samples], img.size)
dev.off()
