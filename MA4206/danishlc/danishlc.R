#!/usr/bin/env Rscript

library(GLMsData)
library(ggplot2)
library(ggthemes)
library(tibble)

data(danishlc)
attach(danishlc)

pdf(file = "plot_%02d.pdf", onefile = FALSE, width = 7, height = 5)

df <- tibble(danishlc)

agelevels <- c("40-54", "55-59", "60-64", "65-69", "70-74", ">74")
Age.ord = ordered(Age, levels = agelevels)

case_rate <- ggplot(df, aes(x = Age.ord, y = 1000 * Cases / Pop, group = City, color = City)) +
        geom_path() +
        geom_point(size = 2) +
        xlab("Age") +
        ylab("Cases per 1000") +
        theme_clean() +
        theme(plot.background = element_blank())

print(case_rate)

model.age_city <- glm(Cases ~ Age * City + offset(log(Pop)), family = poisson(link = "log"))
summary(model.age_city)
model.age_city.pred <- predict(model.age_city, df, type = "response")
model.age_city.plot <- ggplot(df, aes(x = Age.ord, group = City, color = City)) +
        geom_path(aes(y = 1000 * model.age_city.pred / Pop)) +
        geom_point(aes(y = 1000 * model.age_city.pred / Pop), size = 2) +
        geom_path(aes(y = 1000 * Cases / Pop), linetype = "dashed", alpha = 0.7) +
        geom_point(aes(y = 1000 * Cases / Pop), size = 2, alpha = 0.7) +
        xlab("Age") +
        ylab("Cases per 1000") +
        theme_clean() +
        theme(plot.background = element_blank())
print(model.age_city.plot)

model.age <- glm(Cases ~ Age + offset(log(Pop)), family = poisson(link = "log"))
summary(model.age)
model.age.pred <- predict(model.age, df, type = "response")
model.age.plot <- ggplot(df, aes(x = Age.ord, group = City, color = City)) +
        geom_path(aes(y = 1000 * model.age.pred / Pop), color = "black") +
        geom_point(aes(y = 1000 * model.age.pred / Pop), size = 2, color = "black") +
        geom_path(aes(y = 1000 * Cases / Pop), linetype = "dashed", alpha = 0.7) +
        geom_point(aes(y = 1000 * Cases / Pop), size = 2, alpha = 0.7) +
        xlab("Age") +
        ylab("Cases per 1000") +
        theme_clean() +
        theme(plot.background = element_blank())
print(model.age.plot)


df$AgeLower <- Age.ord
levels(df$AgeLower) <- c(40, 55, 60, 65, 70, 75)
df$AgeLower <- as.numeric(df$AgeLower)

model.age_lower <- glm(Cases ~ AgeLower + offset(log(Pop)), family = poisson(link = "log"), data = df)
summary(model.age_lower)
model.age_lower.pred <- predict(model.age_lower, df, type = "response")
model.age_lower.plot <- ggplot(df, aes(x = Age.ord, group = City, color = City)) +
        geom_path(aes(y = 1000 * model.age_lower.pred / Pop), color = "black") +
        geom_point(aes(y = 1000 * model.age_lower.pred / Pop), size = 2, color = "black") +
        geom_path(aes(y = 1000 * Cases / Pop), linetype = "dashed", alpha = 0.7) +
        geom_point(aes(y = 1000 * Cases / Pop), size = 2, alpha = 0.7) +
        xlab("Age") +
        ylab("Cases per 1000") +
        theme_clean() +
        theme(plot.background = element_blank())
print(model.age_lower.plot)

model.age_lower_quad <- glm(Cases ~ poly(AgeLower, 2) + offset(log(Pop)), family = poisson(link = "log"), data = df)
summary(model.age_lower_quad)
model.age_lower_quad.pred <- predict(model.age_lower_quad, df, type = "response")
model.age_lower_quad.plot <- ggplot(df, aes(x = Age.ord, group = City, color = City)) +
        geom_path(aes(y = 1000 * model.age_lower_quad.pred / Pop), color = "black") +
        geom_point(aes(y = 1000 * model.age_lower_quad.pred / Pop), size = 2, color = "black") +
        geom_path(aes(y = 1000 * Cases / Pop), linetype = "dashed", alpha = 0.7) +
        geom_point(aes(y = 1000 * Cases / Pop), size = 2, alpha = 0.7) +
        xlab("Age") +
        ylab("Cases per 1000") +
        theme_clean() +
        theme(plot.background = element_blank())
print(model.age_lower_quad.plot)

model.plots <- ggplot(df, aes(x = Age.ord, group = City, color = City)) +
        geom_path(aes(y = 1000 * Cases / Pop), linetype = "dashed", linewidth = 0.4, alpha = 0.7) +
        geom_point(aes(y = 1000 * Cases / Pop), size = 1, alpha = 0.7) +
        geom_path(aes(y = 1000 * model.age.pred / Pop), color = "red") +
        geom_point(aes(y = 1000 * model.age.pred / Pop), size = 2, color = "red") +
        geom_path(aes(y = 1000 * model.age_lower.pred / Pop), color = "green") +
        geom_point(aes(y = 1000 * model.age_lower.pred / Pop), size = 2, color = "green") +
        geom_path(aes(y = 1000 * model.age_lower_quad.pred / Pop), color = "blue") +
        geom_point(aes(y = 1000 * model.age_lower_quad.pred / Pop), size = 2, color = "blue") +
        xlab("Age") +
        ylab("Cases per 1000") +
        theme_clean() +
        theme(plot.background = element_blank())
print(model.plots)

case_rate_box <- ggplot(df, aes(x = Age.ord, y = 1000 * Cases / Pop)) +
        geom_boxplot() +
        xlab("Age") +
        ylab("Cases per 1000") +
        theme_clean() +
        theme(plot.background = element_blank())

print(case_rate_box)


dev.off()
