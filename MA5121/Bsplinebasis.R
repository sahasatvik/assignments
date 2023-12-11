#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)


# Returns a function B(x, i) which calculates the value of
# the 'i'-th B-spline basis of order 'p' at 'x', with knots at 'knots'.
# Note that 'knots' should include the endpoints.
makeBp <- function(knots, p) {
        m <- length(knots) - 2                  # Number of knots
        a <- knots[1]
        b <- knots[m + 2]

        # Get the 'i'-th knot, properly accounting for endpoints
        k <- function(i) {
                if (i <= 0) {
                        return(a)
                } else if (i > m) {
                        return(b)
                }
                return(knots[i + 1])
        }

        # Base case (p = 0)
        if (p <= 0) {
                B0 <- function(x, i) {
                        as.numeric((k(i) <= x) & (x < k(i + 1)))
                }
                return(B0)
        }

        # Calculate Bp recursively
        Bprev <- makeBp(knots, p - 1)
        Bp <- function(x, i) {
                s <- 0.0
                if (k(i + p) > k(i)) {
                        s <- s + (x - k(i)) * Bprev(x, i) / (k(i + p) - k(i))
                }
                if (k(i + p + 1) > k(i + 1)) {
                        s <- s + (k(i + p + 1) - x) * Bprev(x, i + 1) / (k(i + p + 1) - k(i + 1))
                }
                return(s)
        }
        return(Bp)
}

# Randomized knots in (0, 1)
m <- 4                                          # Number of knots between 0, 1
hs <- runif(m + 1, min = 1, max = 4)
knots <- c(0.0, cumsum(hs) / sum(hs))
print(knots)

# Make a B-spline basis or order 'p'
p <- 3                                          # Order
B <- makeBp(knots, p)                           # Basis functions
I <- seq(-p, m)                                 # Indices for basis elements

x <- seq(0, 1, by = 0.001)
dat = data.frame(x)

# Calculate and store functional values
for (i in I) {
        dat = cbind(dat, i = B(x, i))
}

colnames(dat) <- c("x", I)
dat <- melt(dat, id.var = "x")

pdf("splines.pdf")

ggplot() +
        geom_line(data = dat, aes(x = x, y = value, col = variable)) +
        geom_point(data = data.frame(x = knots, y = 0 * knots), aes(x = x, y = y)) +
        labs(y = "", col = "i") +
        theme_classic()

dev.off()
