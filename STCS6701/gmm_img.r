#!/usr/bin/env Rscript

source("gmm.r")

library(pixmap)
library(foreach)

img <- read.pnm("iotd.ppm")
img.x <- img@red
img.size <- img@size
N <- length(img.x)

N.in <- 10000
idx.in <- sample(1:N, N.in)
img.x.in  <- img.x[ idx.in]
img.x.out <- img.x[-idx.in]

image.show <- function(x, size, xlab = "", col = NA) {
        M <- t(apply(matrix(x, size[1]), 2, rev))
        if (any(is.na(col))) {
                col <- grey(seq(0, 1, length = 256))
        }
        image(
                M,
                col = col,
                asp = size[1] / size[2],
                useRaster = TRUE,
                xlab = xlab,
                xaxt = "n",
                yaxt = "n",
                axes = FALSE,
        )
}


Mode <- function(x) {
        ux <- unique(x)
        ux[which.max(tabulate(match(x, ux)))]
}

# hist(img.x, probability = TRUE)

# Run overfitted model, multiple chains

K.tune <- 16
chains <- 8

posterior.tune <- foreach(i = 1:chains) %dopar% gmm.gibbs.collapsed(
        img.x.in,
        n.samples = 1000, burn = 1000,
        K = K.tune,
        m.0 = 0.5, a.0 = 1, b.0 = 1, k.0 = 0.1, alpha = rep(1, K.tune),
        pi.0 = 1 / K.tune,
        z.0 = sample.int(K, length(img.x.in), replace = TRUE),
        refresh = 1, verbose = FALSE
)

elpd <- foreach(i = 1:chains, .combine = 'c') %do% posterior.tune[[i]]$elpd(img.x.out)



# Run model with interpretable number of components

K <- 4
posterior <- gmm.gibbs.collapsed(
        img.x,
        n.samples = 1000, burn = 1000,
        K = K,
        m.0 = 0.5, a.0 = 1, b.0 = 1, k.0 = 0.1, alpha = rep(1, K),
        pi.0 = 1 / K,
        z.0 = sample.int(K, length(img.x), replace = TRUE),
        refresh = 100
)


# Posterior expectations

E.m  <- rowMeans(posterior$m)
E.s  <- rowMeans(posterior$s)
E.nu <- rowMeans(posterior$nu)
E.pi <- rowMeans(posterior$pi)


# Segmented image

img.seg.z <- apply(posterior$z, 1, Mode)
img.seg <- E.m[img.seg.z]



# Show intensity distribution, posterior predictive

pdf("iotd_data.pdf", 6.5, 7)

layout(matrix(c(1, 2), ncol = 1, byrow = TRUE))
par(mar = c(4, 4, 4, 4))
hist(
        img.x, probability = TRUE,
        xlab = "Intensity", main = "Distribution of pixel intensities",
        xlim = c(0, 1), ylim = c(0, 3)
)

x <- seq(0, 1, length.out = 256)
lines(x, posterior$predictive.density(x), col = "black", lwd = 2)

old.pal <- pal <- rainbow(K, s = 0.8)
pal[order(E.m)[1]] <- old.pal[4]
pal[order(E.m)[2]] <- old.pal[1]
pal[order(E.m)[3]] <- old.pal[2]
pal[order(E.m)[4]] <- old.pal[3]
for (k in 1:K) {
        lines(x, dt((x - E.m[k]) / E.s[k], E.nu[k]) / E.s[k] * E.pi[k], col = pal[k], lwd = 1.5)
}

par(mar = c(1, 4, 1, 4))
image.show(img.seg, img.size, col = pal[order(E.m)])

dev.off()


trace.log.joint <- function(posterior, c = chains, col = rep("#00000020", 8), xlab = "", ylab = "", xaxt = "s") {
        L <- foreach(i = 1:c, .combine = "rbind") %do% posterior[[i]]$log.joint
        plot(L[1, ], type = "l", ylim = range(L), col = 0, xlab = xlab, ylab = ylab, xaxt = xaxt)
        for (i in 1:c) {
                lines(L[i, ], col = col[i])
        }
}

trace.samples <- function(y, ylim = range(y), col = rainbow(nrow(y), s = 0.8), ylab = "", xlab = "", xaxt = "s", add = FALSE) {
        if (!add) {
                plot(y[1, ], ylim = ylim, col = 0, ylab = ylab, xlab = xlab, xaxt = xaxt)
        }
        for (k in 1:nrow(y)) lines(y[k, ], col = col[k])
}


# Show images

pdf("iotd.pdf", 7, 2)
layout(matrix(c(1, 2), ncol = 2, byrow = TRUE))
par(mar = rep(0.2, 4))
image.show(img.x,   img.size)
image.show(img.seg, img.size)
dev.off()


# Show log joint densities, cluster proportions

pdf("iotd_logjoint.pdf", 6.5, 6)

layout(matrix(c(1, 1, 1, 2, 3, 4), ncol = 3, byrow = TRUE), widths = c(1, 1, 1))
par(mar = c(4, 4, 2, 4))
trace.log.joint(posterior.tune, ylab = "Log joint density", xlab = "Iterations (burn + sampling)")
title("Log joint densities")

par(mar = c(4, 2, 4, 2))
trace.samples(posterior.tune[[1]]$pi, xlab = "Iterations (sampling)")
title("Component proportions")

# Select insignificant components
E.1.pi <- rowMeans(posterior.tune[[1]]$pi)
K.1.insignificant <- which(E.1.pi < 0.05)
tr.colors <- rainbow(K.tune, s = 0.8)
for (k in K.1.insignificant) tr.colors[k] <- paste(tr.colors[k], "10", sep = "")

par(mar = c(4, 2, 4, 2))
trace.samples(posterior.tune[[1]]$m[K.1.insignificant, ], xlab = "Iterations (sampling)", col = tr.colors[K.1.insignificant])
trace.samples(posterior.tune[[1]]$m[-K.1.insignificant, ], col = tr.colors[-K.1.insignificant], add = TRUE)
title("Component means")

par(mar = c(4, 2, 4, 2))
trace.samples(-log(posterior.tune[[1]]$s[K.1.insignificant, ]^2), xlab = "Iterations (sampling)", col = tr.colors[K.1.insignificant], ylim = range(-log(posterior.tune[[1]]$s^2)))
trace.samples(-log(posterior.tune[[1]]$s[-K.1.insignificant, ]^2), col = tr.colors[-K.1.insignificant], add = TRUE)
title("Component (log) precisions")

dev.off()

