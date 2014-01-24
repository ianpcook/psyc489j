
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----exp_plot,echo=FALSE-------------------------------------------------
x <- seq(0, 200, by = .01)
qplot(x, dexp(x, 1/29), geom = "line") + theme_grey(base_size = 24)


## ----gen_data------------------------------------------------------------
library(BEST)
library(ISwR)
data(juul)
juul <- juul[complete.cases(juul$sex, juul$igf1),]
mod <- BESTmcmc(juul$igf1[juul$sex == 1], juul$igf1[juul$sex == 2], verbose = FALSE)


## ----,results='asis',echo=FALSE------------------------------------------
str(mod)


## ----,results='asis',echo=FALSE------------------------------------------
summary(mod)


