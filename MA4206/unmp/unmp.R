library(tidyverse)
library(rgl)
library(ddalpha)
library(lmreg)
data(imf2015)
attach(imf2015)

imf2015 <- tibble(imf2015)
imf2015 <- dplyr::select(imf2015, Country, GDP, INV, UNMP)

UNMP.lm <- lm(UNMP ~ GDP + INV, data = imf2015)
UNMP.fitted = UNMP.lm$fitted.values

ggplot(imf2015, mapping = aes(x = UNMP, y = UNMP.fitted)) +
    geom_point(colour = "red") +
    geom_abline(slope = 1, intercept = 0, color = "blue", alpha = 0.3) +
    xlab("Unemployment %") +
    ylab("Fitted Unemployment %") +
    theme_minimal() +
    coord_fixed()

ggplot(imf2015, mapping = aes(x = UNMP.fitted, y = UNMP.lm$residuals)) +
    geom_point(colour = "red") +
    xlab("Fitted Unemployment %") +
    ylab("Residuals") +
    theme_minimal() +
    coord_fixed()

predicted <- predict(UNMP.lm, imf2015, interval = "predict", level = 0.95)
predicted.lower <- predicted[, 2]
predicted.upper <- predicted[, 3]
ggplot(imf2015, mapping = aes(x = reorder(Country, UNMP.fitted), y = UNMP.fitted)) +
    geom_linerange(mapping = aes(ymin = predicted.lower, ymax = predicted.upper)) +
    geom_point(mapping = aes(y = UNMP), colour = "red", size = 2, alpha = 0.5) +
    geom_point(mapping = aes(y = UNMP.fitted), colour = "blue", size = 1, alpha = 0.5) +
    geom_point(mapping = aes(y = predicted.lower), size = 1) +
    geom_point(mapping = aes(y = predicted.upper), size = 1) +
    xlab("") +
    ylab("Unemployment %") +
    theme_minimal() +
    coord_flip()


# ---- Leave One Out Cross Validation

for (i in seq(nrow(imf2015))) {
    model <- lm(UNMP ~ GDP + INV, data = imf2015[-i, ])
    imf2015[i, "coeff_intercept"] <- model$coefficients[1]
    imf2015[i, "coeff_GDP"] <- model$coefficients[2]
    imf2015[i, "coeff_INV"] <- model$coefficients[3]
}

plot3d(
    imf2015$coeff_intercept,
    imf2015$coeff_GDP,
    imf2015$coeff_INV,
    size=0.8,
    type = "s",
    xlab = "Intercept",
    ylab = "GDP",
    zlab = "INV",
    ann = FALSE,
    axes = FALSE,
)
text3d(
    imf2015$coeff_intercept,
    imf2015$coeff_GDP,
    imf2015$coeff_INV,
    imf2015$Country,
    adj = c(1, 1),
    cex = 0.5
)
box3d(alpha = 0.3)

coeffs <- dplyr::select(imf2015, starts_with("coeff_"))
imf2015$depths <- depth.Mahalanobis(coeffs, coeffs)
ggplot(imf2015, mapping = aes(x = reorder(Country, -depths), y = depths)) +
    geom_point() +
    xlab("") +
    ylab("Mahalanobis depths") +
    theme_minimal() +
    coord_flip()


# ---- Remove Countries

imf2015_reduced <- subset(imf2015, !Country %in% c("Greece", "Spain"))
UNMP.lm_reduced <- lm(UNMP ~ GDP + INV, data = imf2015_reduced)
UNMP.fitted_reduced = UNMP.lm_reduced$fitted.values

ggplot(imf2015_reduced, mapping = aes(x = UNMP, y = UNMP.fitted_reduced)) +
    geom_point(colour = "red") +
    geom_abline(slope = 1, intercept = 0, color = "blue", alpha = 0.3) +
    xlab("Unemployment %") +
    ylab("Fitted Unemployment %") +
    theme_minimal() +
    coord_fixed()

ggplot(imf2015_reduced, mapping = aes(x = UNMP.fitted_reduced, y = UNMP.lm_reduced$residuals)) +
    geom_point(colour = "red") +
    xlab("Fitted Unemployment %") +
    ylab("Residuals") +
    theme_minimal() +
    coord_fixed()

predicted_reduced <- predict(UNMP.lm_reduced, imf2015_reduced, interval = "predict", level = 0.95)
predicted_reduced.lower <- predicted_reduced[, 2]
predicted_reduced.upper <- predicted_reduced[, 3]
ggplot(imf2015_reduced, mapping = aes(x = reorder(Country, UNMP.fitted_reduced), y = UNMP.fitted_reduced)) +
    geom_linerange(mapping = aes(ymin = predicted_reduced.lower, ymax = predicted_reduced.upper)) +
    geom_point(mapping = aes(y = UNMP), colour = "red", size = 2, alpha = 0.5) +
    geom_point(mapping = aes(y = UNMP.fitted_reduced), colour = "blue", size = 1, alpha = 0.5) +
    geom_point(mapping = aes(y = predicted_reduced.lower), size = 1) +
    geom_point(mapping = aes(y = predicted_reduced.upper), size = 1) +
    xlab("") +
    ylab("Unemployment %") +
    theme_minimal() +
    coord_flip()

for (i in seq(nrow(imf2015_reduced))) {
    model <- lm(UNMP ~ GDP + INV, data = imf2015_reduced[-i, ])
    imf2015_reduced[i, "coeff_intercept"] <- model$coefficients[1]
    imf2015_reduced[i, "coeff_GDP"] <- model$coefficients[2]
    imf2015_reduced[i, "coeff_INV"] <- model$coefficients[3]
}

plot3d(
    imf2015_reduced$coeff_intercept,
    imf2015_reduced$coeff_GDP,
    imf2015_reduced$coeff_INV,
    size=0.8,
    type = "s",
    xlab = "Intercept",
    ylab = "GDP",
    zlab = "INV",
    ann = FALSE,
    axes = FALSE,
)
text3d(
    imf2015_reduced$coeff_intercept,
    imf2015_reduced$coeff_GDP,
    imf2015_reduced$coeff_INV,
    imf2015_reduced$Country,
    adj = c(1, 1),
    cex = 0.5
)
box3d(alpha = 0.3)
