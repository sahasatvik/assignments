#!/usr/bin/env Rscript

library(coin)

pdf("final_plots.pdf")

# Test of scale
print("Test of scale")

X <- c(35, 66, 58, 83, 71)
Y <- c(46, 56, 60, 49)

boxplot(list(X = X, Y = Y))
stripchart(list(X = X, Y = Y), pch = 4, col = "red", method = "jitter", vertical = TRUE, add = TRUE)
title("X and Y")

mood.test(X, Y, alternative = "two.sided")
ansari.test(X, Y, alternative = "two.sided")

var.test(X, Y, alternative = "two.sided")


# Tuberculosis treatment
print("Tuberculosis treatment")

control <- c(5, 6, 7, 7, 8, 8, 8, 9, 12)
drug    <- c(7, 8, 8, 8, 9, 9, 12, 13, 14, 17)

days <- c(control, drug)
treatment <- c(rep("control", length(control)), rep("drug", length(drug)))
treatment <- as.factor(treatment)

boxplot(list(control = control, drug = drug), ylab = "Days till death")
stripchart(days ~ treatment, pch = 4, col = "red", method = "jitter", vertical = TRUE, add = TRUE)
title("Tuberculosis treatment")

mood.test(days ~ treatment, alternative = "two.sided")
ansari.test(days ~ treatment, alternative = "two.sided")

wilcox.test(days ~ treatment, alternative = "less", exact = TRUE, correct = TRUE)
wilcox_test(days ~ treatment, alternative = "less")
median_test(days ~ treatment, alternative = "less")

shapiro.test(control)
shapiro.test(drug)
t.test(days ~ treatment, alternative = "less")

A <- (control - mean(control)) / sd(control)
B <- (drug - mean(drug)) / sd(drug)
qqplot(A, B, main = "Q-Q Plot for B versus A")
abline(0, 1)

qqnorm(A, main = "Normal Q-Q Plot for A")
qqline(A)
qqnorm(B, main = "Normal Q-Q Plot for B")
qqline(B)

dev.off()
