
## ----setup,include=FALSE,echo=FALSE--------------------------------------
library(knitr)
library(foreign)
library(ggplot2)
library(arm)
library(rstan)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----,echo=FALSE,message=FALSE,results='hide'----------------------------
smod <- "
data {
  int<lower=0> N;
  int<lower=0> J;
  vector[N] y;
  vector[N] x;
  int subj[N];
}
parameters {
  vector[J] a;
  real b[J];
  real g_0;
  real g_1;
  real<lower=0> sigma_y;
  real<lower=0> sigma_a;
  real<lower=0> sigma_b;
}
transformed parameters {
  vector[N] yhat;
  real ahat;
  vector[N] e_y;
  vector[J] e_j;
  
  for (n in 1:N)
    yhat[n] <- a[subj[n]] + b[subj[n]] * x[n];
  e_y <- y - yhat;
  
  ahat <- g_0 + g_1;
  e_j <- a - ahat;
}
model {
  for (j in 1:J)
    a[j] ~ normal(g_0, sigma_a);
  for (j in 1:J)
    b[j] ~ normal(g_1, sigma_b);
  y ~ normal(yhat, sigma_y);
} 
"

sdat <- list(y = sleepstudy$Reaction,
             x = sleepstudy$Days,
             N = nrow(sleepstudy),
             J = length(levels(sleepstudy$Subject)),
             subj = unclass(sleepstudy$Subject))

sfit <- stan(model_code = smod, data = sdat, chains = 2, iter = 500, refresh = -1)


## ----,echo=FALSE---------------------------------------------------------
print(sfit, pars = c("g_0", "g_1", "sigma_y", "sigma_a", "sigma_b"), probs = c(.025, .975))


## ------------------------------------------------------------------------
display(lmer(Reaction ~ Days + (1 + Days | Subject), data = sleepstudy))


