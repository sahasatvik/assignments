library("manipulate")
library("soundgen")
library("rstanarm")

logit <- qlogis
invlogit <- plogis

n <- 100
a <- 1
b <- 0.5
sigma <- 0.3
x <- runif(n, -5, 5)
p <- invlogit(a + b * x)
y <- rbinom(n, size = 1, prob = p)
y.jitter <- y + runif(n, -0.01, 0.01)
df <- data.frame(x = x, y = y)

fit.logit <- stan_glm(y ~ x, family = binomial(link = "logit"), data = df)
a.fit <- coef(fit.logit)[1]
b.fit <- coef(fit.logit)[2]
x.grid <- seq(-5, 5, length.out = 100)

x.Q2.fit <- (logit(0.5)  - a.fit) / b.fit
x.Q3.fit <- (logit(0.75) - a.fit) / b.fit

tone <- function(pitch_multiplier) {
  f0_Hz = 220 * pitch_multiplier
  sound = sin(2 * pi * f0_Hz * (1:16000) / 16000)
  playme(sound, 16000)
}

viz <- function(x.Q2, x.Q3) {
  plot(x, y.jitter, type = "n")
  mtext("The Squealer", side = 3, line = 2.5)
  mtext("Click on the gear, move the sliders to move the two red squares\nand drag the red line,and see what happens", side=3, line=0.5, cex=.8, col="red")
  points(x, y.jitter, pch = 20)
  lines(x.grid, invlogit(a.fit + b.fit * x.grid), col = "blue")
  
  b.guess <- (logit(0.75) - logit(0.5)) / (x.Q3 - x.Q2)
  a.guess <- logit(0.5) - b.guess * x.Q2
  lines(x.grid, invlogit(a.guess + b.guess * x.grid), col = "red")
  points(c(x.Q2, x.Q3), c(0.5, 0.75), pch = 15, cex = 2, col = "red")
  
  ll.fit   <- log_likelihood(a.fit,   b.fit) 
  ll.guess <- log_likelihood(a.guess, b.guess)
  text(max(x), 0.17, paste("Fit LL = ", round(ll.fit, 3)), adj = 1, col = "blue")
  text(max(x), 0.1, paste("Guess LL = ", round(ll.guess, 3)), adj = 1, col = "red")
  print(ll.fit - ll.guess)
  
  alpha <- 0.7
  tone(1 + alpha * (ll.fit - ll.guess))
}

log_likelihood <- function(a, b) {
  p.guess <- invlogit(a + b * x)
  sum(y * log(p.guess) + (1 - y) * log(1 - p.guess))
}

manipulate(
  viz(x.Q2, x.Q3),
  x.Q3 = slider(min(x), max(x), initial = x.Q3.fit),
  x.Q2 = slider(min(x), max(x), initial = x.Q2.fit)
)

