#!/usr/bin/env Rscript

library(dplyr)
library(tidyr)
library(ggplot2)

# Monte-Carlo approximation of P(X >= 2)

# E[1_[2, infty)(X)], X ~ Cauchy(0, 1)
mean(rcauchy(1e7) >= 2)

# Importance sampling
# E[f(X)], X ~ Unif(2, M)
u.max <- 1000
f.cauchy <- function(x) 1 / (pi * (1 + x^2))
u <- runif(1e7, min = 2, max = u.max)
mean((u.max - 2) * f.cauchy(u))

u2 <- runif(1e7, min = 0, max = 2)
0.5 - mean(2 * f.cauchy(u2))


n.max <- 1000
reps <- 500

M.cauchy <- replicate(reps, {
        cumsum(rcauchy(n.max) >= 2) / 1:n.max
})

M.uniformI <- replicate(reps, {
        u <- runif(n.max, min = 2, max = u.max)
        cumsum((u.max - 2) * f.cauchy(u)) / 1:n.max
})

M.uniformII <- replicate(reps, {
        u <- runif(n.max, min = 0, max = 2)
        0.5 - cumsum(2 * f.cauchy(u)) / 1:n.max
})

mat.to.df <- function(M, method = NULL) {
        M <- as.data.frame(t(M))
        colnames(M) <- 1:ncol(M)
        M$id <- 1:nrow(M)
        M <- pivot_longer(M, -id, names_to = "n", values_to = method)
        M$n <- as.integer(M$n)
        M
}

M.cauchy    <- mat.to.df(M.cauchy,    method = "Cauchy")
M.uniformI  <- mat.to.df(M.uniformI,  method = "Uniform, I")
M.uniformII <- mat.to.df(M.uniformII, method = "Uniform, II")
M <- purrr::reduce(.x = list(M.cauchy, M.uniformI, M.uniformII), merge)
M <- pivot_longer(M, -c("id", "n"), names_to = "method", values_to = "I")
M$method <- as.factor(M$method)
M.summary <- M %>%
        group_by(n, method) %>%
        summarize(
                median = median(I),
                Q1 = quantile(I, probs = 0.25),
                Q3 = quantile(I, probs = 0.75),
                IQR = Q3 - Q1
        )


cairo_pdf("cauchy.pdf", onefile = TRUE,  width = 8, height = 4)

ggplot(M, aes(x = n)) +
        geom_line(aes(y = I, group = id), alpha = 0.05, color = "grey") +
        geom_line(data = M.summary, aes(y = median, color = method)) +
        geom_ribbon(data = M.summary, aes(ymin = Q1, ymax = Q3, fill = method), alpha = 0.4) +
        facet_grid(cols = vars(method)) +
        scale_x_log10() +
        scale_y_log10() +
        guides(fill = "none", color = "none") +
        labs(
                x = "Number of samples",
                y = "Estimate",
                title = "Monte-Carlo estimate of Cauchy CDF"
        )

ggplot(M.summary, aes(x = n, y = IQR)) +
        geom_line(aes(color = method)) +
        scale_x_log10() +
        scale_y_log10() +
        labs(
                x = "Number of samples",
                y = "IQR of estimate",
                title = "Inter-quartile ranges of estimates by number of samples"
        )

dev.off()
