
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----load_data,echo=FALSE------------------------------------------------
library(ISwR)
data(juul)


## ------------------------------------------------------------------------
mean(juul$age[juul$sex == 1 & juul$tanner == 1], na.rm = TRUE)
mean(juul$age[juul$sex == 1 | juul$tanner == 1], na.rm = TRUE)


## ----many_small----------------------------------------------------------
points <- rbinom(100, 1, .5)
head(points)
sum(points)
all.points <- matrix(rbinom(10000, 1, .5), ncol = 100)


## ----many_small2---------------------------------------------------------
var(points)
var(colSums(all.points))
mean(colSums(all.points))


## ----clt_hist,echo=FALSE,fig.height=4,fig.width=10-----------------------
qplot(colSums(all.points)) + theme_bw(base_size=24)


## ----calc_viz,echo=FALSE, fig.height=4,fig.width=12----------------------
x <- seq(0, 2, by = .01)
a <- data.frame(x = rep(x, 3), y = c(x^0, x, .5*x^2), measure = rep(factor(1:3, labels = c("acceleration", "speed", "distance")), each = length(x)))
qplot(x, y, data = a, geom = "line", group = 1, size = 1.5) + facet_wrap(~measure, scale = "free_y") + theme_bw(base_size = 24) + guides(size = FALSE)


## ----standard_normal,echo=FALSE,fig.height=4,fig.width=6-----------------
qplot(seq(-4, 4, by = .01), dnorm(seq(-4, 4, by = .01)), geom = "line", size = 1) + ggtitle("Standard normal") + theme_bw() + guides(size = FALSE) + xlab("density") + ylab("x")


## ------------------------------------------------------------------------
pnorm(0)
rnorm(10)


## ----binomial,echo=FALSE,fig.height=5,fig.width=7------------------------
x <- 0:10
a <- data.frame(x = rep(x, 3), y = c(dbinom(x, 10, .5), dbinom(x, 10, .1), dbinom(x, 10, .9)), prob = factor(rep(c(.1, .5, .9), each = length(x))))
qplot(x, y, data = a, color = prob, group = prob, geom = "line") + geom_point(size = 2) + theme_bw(base_size=24)


## ----poisson,echo=FALSE,fig.width=7,fig.height=5-------------------------
x <- 0:20
a <- data.frame(x = rep(x, 3), y = c(dpois(x, 1), dpois(x, 5), dpois(x, 10)), rate = factor(rep(c(1, 5, 10), each = length(x))))
qplot(x, y, data = a, color = rate, group = rate, geom = "line") + geom_point(size = 2) + theme_bw(base_size=24)


## ----pre_bayes,echo=FALSE,fig.width=8,fig.height=14----------------------
x <- seq(0, 1, by = .01)
a <- data.frame(x = rep(x, 3), y = c(dbeta(x, 1, 1), dbeta(x, 1, 5), dbeta(x, 2, 6)), rate = factor(rep(1:3, each = length(x)), labels = c("prior", "likelihood", "posterior")))
qplot(x, y, data = a, geom = "line") + facet_grid(rate~.) + theme_bw(base_size=24)


## ----std_error,fig.width=12,fig.height=4,echo=FALSE----------------------
x <- seq(-1, 1, by = .001)
a <- data.frame(x = rep(x, 2), y = c(dnorm(x, sd = 1/sqrt(10)), dnorm(x, sd = 1/sqrt(100))), group = factor(rep(0:1, each = length(x)), labels = c("10", "100")))
qplot(x, y, data = a, group = group, geom = "line", color = group) + scale_fill_manual(values = c("firebrick", "steelblue")) + theme_bw(base_size = 24)


## ----con_int-------------------------------------------------------------
y <- c(35, 34, 38, 35, 37)
n <- length(y)
estimate <- mean(y)
se <- sd(y)/sqrt(n)
int.50 <- estimate + qt(c(.25, .75), n-1) * se
int.95 <- estimate + qt(c(.025, .975), n-1) * se
int.50
int.95


## ----co_int_prop---------------------------------------------------------
y <- 700
n <- 1000
estimate <- y/n
se <- sqrt(estimate * (1 - estimate)/n)
int.95 <- estimate + qnorm(c(.025, .975)) * se
int.95


## ----discrete_data-------------------------------------------------------
y <- rep(0:4, c(600, 300, 50, 30, 20))
n <- length(y)
estimate <- mean(y)
se <- sd(y)/sqrt(n)
int.50 <- estimate + qt(c(.25, .75), n-1) * se
int.50


## ----visual_comp,echo=FALSE,message=FALSE--------------------------------
polls <- matrix (scan("data/polls.dat"), ncol=5, byrow=TRUE)
support <- polls[,3]/(polls[,3]+polls[,4])
year <-  polls[,1] + (polls[,2]-6)/12
se <- sqrt(support * (1 - support)/1000)
a <- data.frame(year, support, se)


## ----viz_comp_plot,fig.width=14------------------------------------------
qplot(year, support, data = a, geom = "errorbar", ymin = support - se, ymax = support + se) + geom_point(size = 2) + theme_bw(base_size = 24)


## ----problems_with,echo=FALSE,fig.height=6-------------------------------
x <- seq(-3, 4, by = .01)
a <- data.frame(x = rep(x, 3), y = c(dnorm(x), dnorm(x, mean = 1), dnorm(x, mean = 1.2)), rate = factor(rep(0:2, each = length(x)), labels = c("control", "not-significant", "significant")))
qplot(x, y, data = a, group = rate, color = rate, geom = "line") + scale_color_manual(values = c("black", "firebrick", "steelblue")) + theme_bw(base_size = 24)


