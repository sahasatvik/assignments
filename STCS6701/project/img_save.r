#!/usr/bin/env Rscript

library(pixmap)


# img.file <- "42049"
# K <- 4

load(sprintf("rdata/%s_K%d.RData", img.file, K))


image.show <- function(x, size, xlab = "", col = NA) {
        plot(
                pixmapRGB(x, nrow = size[1], ncol = size[2]),
                xlab = xlab,
                useRaster = TRUE
        )
}

pdf(sprintf("figures/%s_orig.pdf", img.file), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))
image.show(img.rgb, img.size)
dev.off()

pdf(sprintf("figures/%s_K%d_seg.pdf", img.file, K), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))
image.show(img.seg, img.size)
dev.off()

pdf(sprintf("figures/%s_K%d_beta.pdf", img.file, K), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(1, 2, 1, 1))
ord <- order(-E.beta)
boxplot(
        as.data.frame(t(posterior$beta[ord, ])),
        col = img.col[ord],
        border = img.col[ord],
        names = NA, #paste(1:K)[ord]
        xaxt = "n",
        ylab = expression(bold(beta))
)
dev.off()


pdf(sprintf("figures/%s_grey.pdf", img.file), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))
img.grey <- rowMeans(img.rgb)
image.show(img.grey, img.size)
dev.off()


pdf(sprintf("figures/%s_grey_hist.pdf", img.file), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(3, 2, 1, 1))
# img.grey <- rowMeans(img.rgb)
hist(
        img.grey,
        freq = FALSE,
        # col = NA,
        # border = NA,
        main = "",
)
dev.off()


pdf(sprintf("figures/%s_K%d_seg_kmeans.pdf", img.file, K), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))
image.show(img.seg.km, img.size)
dev.off()

pdf(sprintf("figures/%s_K%d_seg_gmm.pdf", img.file, K), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))
E.mu.gmm <- apply(posterior.gmm$mu, c(1, 2), mean)
# img.col <- apply(E.mu, 2, function(x) rgb(x[1], x[2], x[3]))

img.seg.gmm.z <- apply(posterior.gmm$z, 1, Mode)
img.seg.gmm <- t(E.mu.gmm[, img.seg.gmm.z])
image.show(img.seg.gmm, img.size)
dev.off()

pdf(sprintf("figures/%s_K%d_seg_fixed.pdf", img.file, K), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))
E.mu.fixed <- apply(posterior.fixed$mu, c(1, 2), mean)
# img.col <- apply(E.mu, 2, function(x) rgb(x[1], x[2], x[3]))

img.seg.fixed.z <- apply(posterior.fixed$z, 1, Mode)
img.seg.fixed <- t(E.mu.fixed[, img.seg.fixed.z])
image.show(img.seg.fixed, img.size)
dev.off()
