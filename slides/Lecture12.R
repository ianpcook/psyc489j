
## ----setup,include=FALSE,echo=FALSE--------------------------------------
library(knitr)
library(ggplot2)
library(lme4)
library(arm)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----,echo=FALSE,fig.width=12,fig.height=10------------------------------
simFun <- function() {
  est <- mean(rbinom(96, 1, .6))
  small.se <- sqrt(est * (1 - est) / 100)
  large.se <- sqrt(est * (1 - est) / 200)
  return(c(est = est, small.se = small.se, large.se = large.se))
}

set.seed(100)
temp <- as.data.frame(t(replicate(20, simFun())))
temp$trial <- 1:nrow(temp)

ggplot(temp, aes(trial, est)) +
  geom_errorbar(aes(ymin = est - small.se, ymax = est + small.se), width = 0, size = 1) +
  geom_errorbar(aes(ymin = est - large.se, ymax = est + large.se), width = 0, size = 2) +
  geom_hline(yintercept = .5, color = "firebrick") +
  theme_classic(base_size = 24) +
  theme(axis.ticks.y = element_blank(), axis.text.y = element_blank()) +
  xlab("") +
  coord_flip()


## ------------------------------------------------------------------------
regDat <- function(n) {
  x <- sample(0:1, n, replace = TRUE)
  y <- rnorm(n, 100, 10) + x * 2
  mod <- lm(y ~ x)
  return(summary(mod)$coef[2,3] > 2)
}

N <- seq(100, 800, by = 50)
sims <- sapply(N, function(x) mean(replicate(1000, regDat(x))))
sims


## ------------------------------------------------------------------------
qplot(N, sims) + theme_classic(base_size = 24)


## ------------------------------------------------------------------------
fakeDat <- function(J, m) {
  x <- sample(0:1, J * m, replace = TRUE)
  person <- rep(1:J, each = m)
  mu.y <- 100
  true.effect <- 2
  sigma.y <- 10
  sigma.a <- 10
  sigma.b <- 3
  ints <- rnorm(J, 0, sigma.a)
  slopes <- rnorm(J, 0, sigma.b)
  y <- rnorm(J * m, mu.y, sigma.y) + x * true.effect + ints[person] + slopes[person]
  return(data.frame(y, x, person))
}


## ------------------------------------------------------------------------
simPower <- function(J, m) {
  dat <- fakeDat(J, m)
  mod <- lmer(y ~ x + (1 + x|person), data = dat)
  return(summary(mod)$coef[2,3] > 2)
}

inputs <- expand.grid(J = seq(10, 100, by = 10), m = seq(10, 20, by = 2))
inputs$sims <- apply(inputs, 1, function(x) mean(replicate(100, simPower(x[1], x[2]))))


## ------------------------------------------------------------------------
head(inputs)


## ------------------------------------------------------------------------
qplot(J, sims, color = m, group = m, geom = c("point", "line"), data = inputs) + theme_classic(base_size = 24)


