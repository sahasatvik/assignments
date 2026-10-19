#!/usr/bin/env Rscript

source("irt.r")


# Load data

senators <- read.table("senators.txt")
senators[, 3] <- sapply(senators[, 2], function(s) substr(s, 2, 2))
senators[, 2] <- sapply(senators[, 2], function(s) substr(s, 4, 5))
colnames(senators) <- c("name", "state", "party")
n.senators <- nrow(senators)

senators[, "party_color"] <- "purple"
senators[senators[, "party"] == "D", "party_color"] <- "blue"
senators[senators[, "party"] == "R", "party_color"] <- "red"

votes <- read.csv("votes.csv", head = FALSE)
votes[votes == -1] <- NA
n.bills <- ncol(votes)

present <- which(!is.na(votes), arr.ind = TRUE) # Indices (i, j) of present votes
n.votes <- nrow(present)


# Hold-out 10% of data

n.test <- round(n.votes / 10)
idx.test <- sample(1:n.votes, n.test)

votes.train <- votes
votes.train[present[idx.test, ]] <- NA

votes.fit <- irt.cavi(votes.train, iterations = 150)

# Ordering of senators by ideology
p <- order(votes.fit$mu.theta.q)


# Use held-out data for testing

votes.test <- votes[present[idx.test, ]]

cat(sprintf(
        "Average log posterior predictive density:      %8.4f\n",
        votes.fit$average.log.predictive(votes.test, present[idx.test, ])
))

votes.test.predictive.prob <- votes.fit$predictive.prob(votes.test, present[idx.test, ])
votes.test.predicted <- round(votes.test.predictive.prob)

cat(sprintf(
        "Predictive accuracy:                           %8.4f\n",
        mean(votes.test == votes.test.predicted)
))



library(scales)

# Plot ideal points and variation of the ELBO

pdf("ideal_points_elbo.pdf", 8, 7)
layout(matrix(c(1, 2), ncol = 2, byrow = TRUE), widths = c(1.4, 1))

par(mar = c(4, 1, 3, 1))

plot(
        votes.fit$mu.theta.q[p],
        1:n.senators,
        col = senators[p, "party_color"],
        pch = 16, cex = 0.5,
        xlab = expression("Ideology (" ~ theta ~ ")"),
        ylab = "", yaxt = "n",
        main = "Ideal points of Senators"
)

segments(
        votes.fit$mu.theta.q[p] - 2 * sqrt(votes.fit$sigma.theta.2.q[p]), 1:n.senators,
        votes.fit$mu.theta.q[p] + 2 * sqrt(votes.fit$sigma.theta.2.q[p]), 1:n.senators,
        col = alpha(senators[p, "party_color"], 0.5)
)
text(
        votes.fit$mu.theta.q[p] - 0.25 * sign(votes.fit$mu.theta.q[p]),
        1:n.senators,
        paste(senators[p, "name"], ", ", senators[p, "state"], sep = ""),
        cex = 0.35,
        col = senators[p, "party_color"]
)
legend(
        "topleft",
        legend = c("Independent", "Democratic", "Republican"),
        col = c("purple", "blue", "red"),
        pch = 16, cex = 0.6
)


par(mar = c(4, 2, 3, 1))

plot(
        votes.fit$ELBO,
        type = "l",
        xlab = "Iterations", ylab = "ELBO",
        main = "ELBO"
)

dev.off()



# Plot bill landscape

pdf("bill_landscape.pdf", 8, 7)
par(mar = c(4, 4.2, 3, 1))

top.alpha <- order(abs(votes.fit$mu.alpha.q), decreasing=TRUE)[1:5]

plot(
        votes.fit$mu.beta.q, votes.fit$mu.alpha.q,
        # col = senators[p, "party_color"],
        pch = 16, cex = 0.3,
        xlab = expression("Ideology (" ~ beta ~ ")"),
        ylab = expression("Poloarization (" ~ alpha ~ ")"),
        main = "Bill landscape"
)

points(
        votes.fit$mu.beta.q[top.alpha], votes.fit$mu.alpha.q[top.alpha],
        cex = 1.5, pch = 4,
        col = alpha(rainbow(5), 0.8)
)
legend(
        "topright",
        legend = paste("Bill", top.alpha),
        col = rainbow(5),
        pch = 4
)

dev.off()
