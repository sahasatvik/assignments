#!/usr/bin/env Rscript

source("gmm.r")
library(foreach)

N <- 2000
K <- 3

N.hold <- 500
N.in <- N - N.hold

X <- mixture.data.generate(
        N, K,
        m.0 = 0, a.0 = 2, b.0 = 1, k.0 = 0.1, alpha = rep(1, K)
)

x.in  <- X$x[1:(N - N.hold)]
z.in  <- X$z[1:(N - N.hold)]
x.out <- X$x[(N - N.hold):N]

# hist(x.in)

pal <- rainbow(K, s = 0.8)

Mode <- function(x) {
        ux <- unique(x)
        ux[which.max(tabulate(match(x, ux)))]
}

n.samples <- 1000
chains <- 8

K.model <- K

posterior.blocked <- foreach(i = 1:chains) %dopar% gmm.gibbs.blocked(
        x.in,
        n.samples = n.samples, burn = 1000,
        K = K.model,
        m.0 = 0, a.0 = 1, b.0 = 1, k.0 = 0.1, alpha = rep(1, K.model),
        pi.0 = 1 / K.model,
        lambda.0 = 1,
        mu.0 = 0,
        z.0 = sample.int(K.model, length(x.in), replace = TRUE),
        refresh = 1, verbose = FALSE
)

z.blocked <- apply(posterior.blocked[[1]]$z, 1, Mode)

posterior.collapsed <- foreach(i = 1:chains) %dopar% gmm.gibbs.collapsed(
        x.in,
        n.samples = n.samples, burn = 1000,
        K = K.model,
        m.0 = 0, a.0 = 1, b.0 = 1, k.0 = 0.1, alpha = rep(1, K.model),
        pi.0 = 1 / K.model,
        z.0 = sample.int(K.model, length(x.in), replace = TRUE),
        refresh = 1, verbose = FALSE
)

z.collapsed <- apply(posterior.collapsed[[1]]$z, 1, Mode)




# Show data and clustering

pdf(sprintf("gmm_Q3_hist_%d.pdf", K.model))

layout(matrix(c(1,1,2), ncol = 1, byrow = TRUE), heights = c(1, 1, 1))
par(mar = c(5, 4, 3, 4))
hist(
        x.in, probability = TRUE,
        xlab = expression("x"["in"]), main = "Training data, with component-wise densities",
        xlim = range(X$x), ylim = c(0, 0.3)
)

for (k in 1:K) {
        d.k <- density(x.in[z.in == k])
        lines(d.k$x, d.k$y * X$pi[k], col = pal[k], lwd = 2)
}

par(mar = c(5, 4, 0, 4))

plot(x.in, x.in * 0, col = 0, xlim = range(X$x), ylim = c(-0.3, 2.3), axes = 0, ylab = "", xlab = "Cluster labels (actual and fitted)")

points(x.in, 0 + runif(N.in, -0.3, 0.3), col = z.blocked + 1,   pch = 3)
points(x.in, 1 + runif(N.in, -0.3, 0.3), col = z.collapsed + 1, pch = 3)
points(x.in, 2 + runif(N.in, -0.3, 0.3), col = z.in + 1,        pch = 3)
axis(2, at = c(0, 1, 2), labels = c("Collapsed", "Blocked", "Actual"))

dev.off()

# X.pred <- posterior$predictive.sample()

# lines(density(X.pred), col = "blue")
# points(x.out, posterior$predictive.density(x.out))

elpd.blocked <- foreach(i = 1:chains, .combine = 'c') %do% posterior.blocked[[i]]$elpd(x.out)
elpd.collapsed <- foreach(i = 1:chains, .combine = 'c') %do% posterior.collapsed[[i]]$elpd(x.out)

trace.log.joint <- function(posterior, c = chains, col = rep("#00000020", 8), xlab = "", ylab = "", xaxt = "s") {
        L <- foreach(i = 1:c, .combine = "rbind") %do% posterior[[i]]$log.joint
        plot(L[1, ], type = "l", ylim = range(L), col = 0, xlab = xlab, ylab = ylab, xaxt = xaxt)
        for (i in 1:c) {
                lines(L[i, ], col = col[i])
        }
}

trace.samples <- function(y, ylim = range(y), col = rainbow(nrow(y), s = 0.8), ylab = "", xlab = "", xaxt = "s") {
        plot(y[1, ], ylim = ylim, col = 0, ylab = ylab, xlab = xlab, xaxt = xaxt)
        for (k in 1:nrow(y)) lines(y[k, ], col = col[k])
}



# Show log joint densities, cluster means

pdf(sprintf("gmm_Q3_logjoint_%d.pdf", K.model), 7, 5)

layout(matrix(c(1,3,1,3, 2,4, 2,4), ncol = 2, byrow = TRUE), heights = c(2, 1.5, 2, 2), widths = c(2, 1))
par(mar = c(1, 4, 3, 1))
trace.log.joint(posterior.blocked, ylab = "Log joint density", xaxt = "n")
title(main = "Blocked Gibbs sampler")
par(mar = c(5, 4, 3, 1))
trace.log.joint(posterior.collapsed, ylab = "Log joint density", xlab = "Iterations (burn + sampling)")
title(main = "Collapsed Gibbs sampler")

par(mar = c(1, 4, 3, 2))
trace.samples(posterior.blocked[[1]]$mu, ylab = "Component means", xaxt = "n")
par(mar = c(5, 4, 3, 2))
trace.samples(posterior.collapsed[[1]]$m, ylab = "Component means", xlab = "Iterations (sampling)")

dev.off()



# Show ELPD estimates

pdf(sprintf("gmm_Q3_elpd_%d.pdf", K.model), 5, 5)

boxplot(elpd.blocked, elpd.collapsed, names = c("Blocked", "Collapsed"))
title(main = "Estimated ELPD", ylab = "")

dev.off()

