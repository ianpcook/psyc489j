
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----,eval=FALSE---------------------------------------------------------
## sum(dpois(obs, rate))


## ----,eval=FALSE---------------------------------------------------------
## prod(dpois(obs, rate))


## ----,eval=FALSE---------------------------------------------------------
## exp(sum(log(dpois(obs, rate))))


## ----rand_print,echo=FALSE-----------------------------------------------
n <- 5
dat <- rnorm(n)
dat


## ----lik_plot,echo=FALSE,fig.height=4,fig.width=10-----------------------
df <- data.frame(x = rep(dat,2), y = c(dnorm(dat), rep(0, n)), groups = rep(1:n, 2))
df.2 <- data.frame(x = seq(-5, 5, by = .01), y = dnorm(seq(-5, 5, by = .01)))
ggplot(df, aes(x = x, y = y, group = groups)) + geom_line(color = "firebrick") + geom_line(data = df.2, aes(x = x, y = y, group = 1), color = "black") + theme_grey(base_size = 24) + xlim(c(-5, 5))


## ----lik_plot2,echo=FALSE,fig.height=7,fig.width=14----------------------
df <- data.frame(x = rep(dat,4), y = c(dnorm(dat), rep(0, n), dnorm(dat, mean = 1), rep(0, n)), groups = rep(1:n, 4), mu = rep(0:1, each = 2*n))
df.2 <- data.frame(x = rep(seq(-5, 5, by = .01), 2), y = c(dnorm(seq(-5, 5, by = .01)), dnorm(seq(-5, 5, by = .01), mean = 1)), mu = rep(0:1, each = length(seq(-5, 5, by = .01))))
ggplot(df, aes(x = x, y = y, group = groups)) + geom_line(color = "firebrick") + geom_line(data = df.2, aes(x = x, y = y, group = 1), color = "black") + theme_grey(base_size = 24) + facet_wrap(~mu) + xlim(c(-5, 5))


## ------------------------------------------------------------------------
logL <- function(coefs, y, x, sdr) {
  means <- coefs[1] + coefs[2] * x
  dat <- cbind(y, means, sdr)
  ll <- apply(dat, 1, function(x) dnorm(x[1], mean = x[2], sd = x[3]))
  return(sum(log(ll)))
}
bootS <- function(model.formula, df) {
  new.df <- df[sample(nrow(df), nrow(df), replace = TRUE),]
  mod <- lm(model.formula, data = new.df)
  return(coef(mod))
}
getRSD <- function(coefs, y, x) {
  y.hat <- coefs[1] + coefs[2] * x
  resids <- y - y.hat
  return(sd(resids))
}


## ----,echo=FALSE---------------------------------------------------------
options(digits = 5)


## ------------------------------------------------------------------------
data(women)
fit <- lm(weight ~ height, data = women)
fit.ll <- logL(coef(fit), women$weight, women$height, sd(residuals(fit)))
b <- t(replicate(100, bootS(weight ~ height, women)))
rsds <- apply(b, 1, function(x) getRSD(x, women$weight, women$height))
a <- cbind(b, rsds)
all.lls <- apply(a, 1, function(x) logL(x[1:2], women$weight, women$height, x[3]))
c(fit.ll, max(all.lls))


## ----,echo=FALSE---------------------------------------------------------
options(digits = 3)


## ------------------------------------------------------------------------
xs <- runif(10000, -3, 10)
xs[dnorm(xs) == max(dnorm(xs))]


## ----mc_code-------------------------------------------------------------
islands <- 1:6
visits <- rep(NA, times = 100000)
visits[1] <- sample(islands, 1)
for (i in 1:(length(visits) - 1)) {
  if (visits[i] == 1) {
    choose.direction <- sample(c(0, 1), 1)
  } else if (visits[i] == 6) {
    choose.direction <- sample(c(-1, 0), 1)
  } else {
    choose.direction <- sample(c(-1, 1), 1)
  }
  if (islands[visits[i]] < islands[visits[i] + choose.direction]) {
    visits[i + 1] <- visits[i] + choose.direction
  } else if (runif(1) < islands[visits[i] + choose.direction]/islands[visits[i]]) {
    visits[i + 1] <- islands[visits[i]] + choose.direction
  } else {
    visits[i + 1] <- visits[i]
  }
}


## ----run_mc--------------------------------------------------------------
mcmc.approx <- table(visits)/length(visits)
true.props <- islands/sum(islands)
names(true.props) <- names(mcmc.approx)

mcmc.approx
true.props


