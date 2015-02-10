
## ----setup,include=FALSE,echo=FALSE--------------------------------------
library(knitr)
library(ggplot2)
library(arm)
library(dplyr)
library(rstan)
library(MASS)
library(reshape2)
library(gdata)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----, echo=FALSE--------------------------------------------------------
n <- 10
sdat <- as.list(as.data.frame(mvrnorm(n = n, mu = c(10, 0), Sigma = matrix(c(1, .5, .5, 1), ncol = 2))))
sdat$N <- n
sdat$intercept <- rep(1, n)
names(sdat)[1:2] <- c("y", "x")


smod <- "
data {
  int N;
  vector[N] y;
  vector[N] x;
  vector[N] intercept;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
transformed parameters {
  vector[N] yhat;
  yhat <- alpha * intercept + beta * x;
}
model {
  y ~ normal(yhat, sigma);
}
"

sfit <- stan(model_code = smod, data = sdat, refresh = -1, chains = 1, iter = 200)


## ------------------------------------------------------------------------
sdat


## ----,echo=FALSE---------------------------------------------------------
print(sfit, digits = 2, probs = c(.1, .5, .9))


## ----,echo=FALSE---------------------------------------------------------
str(sfit)


## ------------------------------------------------------------------------
str(as.array(sfit))


## ------------------------------------------------------------------------
x <- melt(extract(sfit, inc_warmup = TRUE, permuted = FALSE))
x$period <- factor(ifelse(x$iterations > 100, "post", "burn"))
x <- drop.levels(x[grep("sigma", x$parameters), ])
ac <- melt(lapply(levels(x$parameters), function(par) lapply(levels(x$period), function(per) acf(x$value[x$parameters == par & x$period == per], plot = FALSE)$acf)))
names(ac)[c(1, 5:6)] <- c("lag", "period", "parameters")
ac$period <- factor(ac$period, labels = c("burn", "post"))
ac$parameters <- factor(ac$parameters, labels = levels(x$parameters))


## ----,eval=FALSE---------------------------------------------------------
## ggplot(ac, aes(lag, value)) +
##   geom_point() +
##   geom_segment(aes(x = lag, xend = lag, y = 0, yend = value)) +
##   facet_grid(period ~ parameters) +
##   theme_bw(base_size = 24)


## ----,echo=FALSE,fig.height=10,fig.width=10------------------------------
ggplot(ac, aes(lag, value)) +
  geom_point() +
  geom_segment(aes(x = lag, xend = lag, y = 0, yend = value)) +
  facet_grid(period ~ parameters) +
  theme_bw(base_size = 24)


## ------------------------------------------------------------------------
a <- c("apple[1]", "orange[1]", "orange[2]", "orange[3]")
grep("orange", a)


## ------------------------------------------------------------------------
traceplot(sfit, pars = c("alpha", "beta", "sigma"))


## ------------------------------------------------------------------------
temp <- melt(as.array(sfit))
temp <- temp[grep("yhat", temp$parameters),]
y <- data.frame(y = sdat$y)

pplot <- ggplot(temp, aes(value)) +
  geom_density() +
  geom_density(data = y, aes(y), color = "firebrick") +
  theme_bw(base_size = 24)


## ----,echo=FALSE---------------------------------------------------------
pplot


## ----,warning=FALSE,message=FALSE----------------------------------------
post.sims <- melt(replicate(11, sample(temp$value, length(sdat$y), replace = TRUE)))
post.sims$group <- "sim"
tmp <- data.frame(Var1 = 1:10, Var2 = "obs", value = sdat$y, group = "obs")
post.sims <- rbind(post.sims, tmp)

pplot <- ggplot(post.sims, aes(value)) +
  geom_histogram(aes(fill = group)) +
  facet_wrap(~Var2) +
  theme_bw(base_size = 24)


## ----,echo=FALSE---------------------------------------------------------
pplot


