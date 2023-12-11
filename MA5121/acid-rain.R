#!/usr/bin/env Rscript

df <- read.table("acid-rain.txt", sep = "\t", header = 1)

pdf("acid-rain.pdf")

hist(df$pH, probability = TRUE, xlab = "pH", main = NULL)
lines(density(df$pH, kernel = "gaussian", bw = "ucv"), lw = 2, col = "red")
lines(density(df$pH, kernel = "gaussian", bw = "nrd"), lw = 2)
legend(5, 1.5, legend = c("Normal reference rule", "Cross validation"), lty = 1, col = c("black", "red"))
title("Density estimate of pH (Gaussian kernel)")

hist(df$pH, probability = TRUE, xlab = "pH", main = NULL)
lines(density(df$pH, kernel = "epanechnikov", bw = "ucv"), lw = 2, col = "red")
lines(density(df$pH, kernel = "epanechnikov", bw = "nrd"), lw = 2)
legend(5, 1.5, legend = c("Normal reference rule", "Cross validation"), lty = 1, col = c("black", "red"))
title("Density estimate of pH (Epanechnikov kernel)")

hist(df$pH, probability = TRUE, xlab = "pH", main = NULL)
lines(density(df$pH, kernel = "rectangular", bw = "ucv"), lw = 2, col = "red")
lines(density(df$pH, kernel = "rectangular", bw = "nrd"), lw = 2)
legend(5, 1.5, legend = c("Normal reference rule", "Cross validation"), lty = 1, col = c("black", "red"))
title("Density estimate of pH (Rectangular kernel)")

hist(df$pH, probability = TRUE, xlab = "pH", main = NULL)
lines(density(df$pH, kernel = "triangular", bw = "ucv"), lw = 2, col = "red")
lines(density(df$pH, kernel = "triangular", bw = "nrd"), lw = 2)
legend(5, 1.5, legend = c("Normal reference rule", "Cross validation"), lty = 1, col = c("black", "red"))
title("Density estimate of pH (Triangular kernel)")

Fn <- ecdf(df$pH)
plot(Fn, xlab = "pH", main = "Empirical CDF of pH")
print(1 - Fn(4.75))

dev.off()
