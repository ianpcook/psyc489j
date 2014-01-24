
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----,eval=FALSE---------------------------------------------------------
## data {
##   int<lower=0> N;
##   int<lower=0> lvl;
##   vector[N] y;
##   int x[N];
##   vector[lvl] n;
##   real muM;
##   real muP;
##   real sigmaLow;
##   real sigmaHigh;
##   real df;
## }


## ----,eval=FALSE---------------------------------------------------------
## parameters {
##   real mu[lvl];
##   real<lower=0> sigma[lvl];
##   real<lower=0> nuM;
## }


## ----,eval=FALSE---------------------------------------------------------
## transformed parameters {
##   real muDiff;
##   real sigmaDiff;
##   real<lower=0> nu;
##   real effSize;
##   muDiff <- mu[1] - mu[2];
##   sigmaDiff <- sigma[1] - sigma[2];
##   nu <- nuM + 1;
##   effSize <- (mu[1] - mu[2])/sqrt((((n[1] - 1) * sigma[1]) + ((n[2] - 1) * sigma[2]))/(N - 2));
## }


## ----,eval=FALSE---------------------------------------------------------
## model {
##   nuM ~ exponential(df);
##   for (i in 1:N)
##     y[i] ~ student_t(nuM + 1, mu[x[i]], sigma[x[i]]);
##   for (j in 1:2) {
##     mu[j] ~ normal(muM, muP);
##     sigma[j] ~ uniform(sigmaLow, sigmaHigh);
##   }
## }


## ----,eval=FALSE---------------------------------------------------------
## test_dat <- list(
##   N = length(c(g1, g2)),
##   n = c(length(g1), length(g2)),
##   lvl = 2,
##   y = c(g1, g2),
##   x = rep(1:2, c(length(g1), length(g2))),
##   muM = mean(c(g1, g2)),
##   muP = (1e6 * var(c(g1, g2))),
##   sigmaLow = (var(c(g1, g2))/1000),
##   sigmaHigh = (var(c(g1, g2)) * 1000),
##   df = 1/29)


## ----full_code,echo=FALSE------------------------------------------------
library(rstan)
library(ISwR)
data(juul)
juul <- juul[complete.cases(juul$sex, juul$igf1),]

g1 <- juul$igf1[juul$sex == 1]
g2 <- juul$igf1[juul$sex == 2]
  
t_code <- '
  data {
    int<lower=0> N; // number of samples
    int<lower=0> lvl; // number of groups
    vector[N] y; // outcome
    int x[N]; // group
    vector[lvl] n;
    real muM;
    real muP;
    real sigmaLow;
    real sigmaHigh;
    real df;
  }
  parameters {
    real mu[lvl];
    real<lower=0> sigma[lvl];
    real<lower=0> nuM;
  }
  transformed parameters {
    real muDiff;
    real sigmaDiff;
    real<lower=1> nu;
    real effSize;
    muDiff <- mu[1] - mu[2];
    sigmaDiff <- sigma[1] - sigma[2];
    nu <- nuM + 1;
    effSize <- (mu[1] - mu[2])/sqrt((((n[1] - 1) * sigma[1]) + ((n[2] - 1) * sigma[2]))/(N - 2));
  }
  model {
    nuM ~ exponential(df);
    for (i in 1:N)
      y[i] ~ student_t(nu, mu[x[i]], sigma[x[i]]);
    for (j in 1:2) {
      mu[j] ~ normal(muM, muP);
      sigma[j] ~ uniform(sigmaLow, sigmaHigh);
    }
  }
'

test_dat <- list(
  N = length(c(g1, g2)),
  n = c(length(g1), length(g2)),
  lvl = 2,
  y = c(g1, g2),
  x = rep(1:2, c(length(g1), length(g2))),
  muM = mean(c(g1, g2)),
  muP = (1e6 * var(c(g1, g2))),
  sigmaLow = (sd(c(g1, g2))/1000),
  sigmaHigh = (sd(c(g1, g2)) * 1000),
  df = 1/29)


## ----model_fit,message=FALSE,echo=FALSE----------------------------------
fit <- stan(model_code = t_code, data = test_dat, iter = 1000, chains = 3, verbose = FALSE)


