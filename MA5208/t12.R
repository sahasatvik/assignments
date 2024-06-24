#!/usr/bin/env Rscript

library(dplyr)
library(tidyr)
library(ggplot2)

h <- function(x) sqrt(abs(x / (1 - x)))

x.t12 <- rt(1e7, df = 12)
mean(h(x.t12))

x.cauchy <- rcauchy(1e7)
mean(h(x.cauchy) * dt(x.cauchy, df = 12) / dcauchy(x.cauchy))

y.gamma <- rgamma(1e7, shape = 1/2, rate = 1)
s   <- sign(runif(1e7) - 0.5)
g   <- function(x) 0.5 * dgamma(abs(x - 1), shape = 1/2, rate = 1)
x.g <- s * y.gamma + 1
mean(h(x.g) * dt(x.g, df = 12) / g(x.g))



n.max <- 1000
reps <- 500

M.t12 <- replicate(reps, {
        t <- rt(n.max, df = 12)
        cumsum(h(t)) / 1:n.max
})

M.cauchy <- replicate(reps, {
        x <- rcauchy(n.max)
        cumsum(h(x) * dt(x, df = 12) / dcauchy(x)) / 1:n.max
})

M.gamma <- replicate(reps, {
        y <- rgamma(n.max, shape = 1/2, rate = 1)
        s <- sign(runif(n.max) - 0.5)
        x <- s * y + 1
        cumsum(h(x) * dt(x, df = 12) / g(x)) / 1:n.max
})

mat.to.df <- function(M, method = NULL) {
        M <- as.data.frame(t(M))
        colnames(M) <- 1:ncol(M)
        M$id <- 1:nrow(M)
        M <- pivot_longer(M, -id, names_to = "n", values_to = method)
        M$n <- as.integer(M$n)
        M
}

M.t12    <- mat.to.df(M.t12,    method = "t12")
M.cauchy <- mat.to.df(M.cauchy, method = "Cauchy")
M.gamma  <- mat.to.df(M.gamma,  method = "Gamma")
M <- purrr::reduce(.x = list(M.t12, M.cauchy, M.gamma), merge)
M <- pivot_longer(M, -c("id", "n"), names_to = "method", values_to = "E")
M$method <- factor(M$method, levels = c("t12", "Cauchy", "Gamma"))
M.summary <- M %>%
        group_by(n, method) %>%
        summarize(
                median = median(E),
                Q1 = quantile(E, probs = 0.25),
                Q3 = quantile(E, probs = 0.75),
                IQR = Q3 - Q1
        )


cairo_pdf("t12.pdf", onefile = TRUE, width = 8, height = 4)

ggplot(M, aes(x = n)) +
        geom_line(aes(y = E, group = id), alpha = 0.05, color = "grey") +
        geom_line(data = M.summary, aes(y = median, color = method)) +
        geom_ribbon(data = M.summary, aes(ymin = Q1, ymax = Q3, fill = method), alpha = 0.4) +
        ylim(c(0, 5)) +
        scale_x_log10() +
        facet_grid(cols = vars(method)) +
        guides(fill = "none", color = "none") +
        labs(
                x = "Number of samples",
                y = "Estimate",
                title = expression("Monte-Carlo estimate of E[h(X)], X ~ t"[12])
        )

ggplot(M.summary, aes(x = n, y = IQR)) +
        geom_line(aes(color = method)) +
        scale_x_log10() +
        labs(
                x = "Number of samples",
                y = "IQR of estimate",
                title = "Inter-quartile ranges of estimates by number of samples"
        )

dev.off()
