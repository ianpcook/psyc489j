
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----pre_bayes,echo=FALSE,fig.width=14,fig.height=6----------------------
x <- seq(0, 1, by = .01)
a <- data.frame(x = rep(x, 3), y = c(dbeta(x, 1, 1), dbeta(x, 1, 5), dbeta(x, 2, 6)), rate = factor(rep(1:3, each = length(x)), labels = c("prior", "likelihood", "posterior")))
qplot(x, y, data = a, geom = "line") + facet_grid(.~rate) + theme_bw(base_size=24)


## ----cancer_calc---------------------------------------------------------
.01 * .8/(.01 * .8 + .99 * .096)


## ----poisson_setup,echo=FALSE--------------------------------------------
obs <- c(1, 1, 2, 5)
obs


## ----priors--------------------------------------------------------------
priors <- c(.2, .2, .4, .2)


## ----poisson_lik---------------------------------------------------------
rates <- 3:6
lik <- sapply(rates, function(x) sum(dpois(obs, x)))
lik


## ----post_odds-----------------------------------------------------------
priors * lik


## ------------------------------------------------------------------------
pd <- sum(lik)
lik * priors/pd


