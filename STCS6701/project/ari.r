#!/usr/bin/env Rscript

suppressMessages(library(mclust))
library(pixmap)

args <- commandArgs(TRUE)

img.file <- args[1]
K <- as.integer(args[2])

load(sprintf("rdata/%s_K%d.RData", img.file, K))

human.seg <- read.table(sprintf("seg/%s.seg", img.file), skip = 11)
human.z <- matrix(0, nrow = img.size[1], ncol = img.size[2])

for (i in 1:nrow(human.seg)) {
        row <- human.seg[i, 2] + 1
        cols <- (human.seg[i, 3] + 1):(human.seg[i, 4] + 1)
        human.z[row, cols] <- human.seg[i, 1] + 1
}

human.z <- c(human.z)
img.seg.gmm.z <- apply(posterior.gmm$z, 1, Mode)
img.seg.fixed.z <- apply(posterior.fixed$z, 1, Mode)


cat(sprintf("Human identified %d segments.\n", max(human.z)))

cat(sprintf("KMeans :        %.4f\n", adjustedRandIndex(human.z, img.kmeans$cluster)))
cat(sprintf("GMM :           %.4f\n", adjustedRandIndex(human.z, img.seg.gmm.z)))
cat(sprintf("Fixed beta :    %.4f\n", adjustedRandIndex(human.z, img.seg.fixed.z)))
cat(sprintf("Learned beta :  %.4f\n", adjustedRandIndex(human.z, img.seg.z)))


image.show <- function(x, size, xlab = "", col = NA) {
        plot(
                pixmapRGB(x, nrow = size[1], ncol = size[2]),
                xlab = xlab,
                useRaster = TRUE
        )
}

pdf(sprintf("figures/%s_seg_human.pdf", img.file), width = 6, height = 6 * img.size[1] / img.size[2])
par(mar = c(0, 0, 0, 0))

colors <- sapply(1:max(human.z), function(k) colMeans(img.rgb[human.z == k, , drop = FALSE]))
image.show(t(colors[, human.z]), img.size)

dev.off()
