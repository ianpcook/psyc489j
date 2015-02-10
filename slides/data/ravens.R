library(rstan)

dat <- read.csv("ravensdata.csv")

logit_code <- '
data {
  int<lower=0> N;
  int<lower=1> P;
  int<lower=2> K;
  int<lower=1,upper=K> y[N];
  row_vector[P] x[N];
}
parameters {
  vector[P] b;
  real mu_b;
  ordered[K-1] c;
}
model {
  mu_b ~ double_exponential(0.0, 1.0);
  b ~ normal(mu_b, K/4.0);
  for (n in 1:N)
    y[n] ~ ordered_logistic(x[n] * b, c);
}
'

x <- model.matrix(~ shape * nfc, dat)

sdat <- list(y = dat$ravens,
             x = x,
             N = nrow(x),
             K = length(unique(dat$ravens)),
             P = ncol(x)
)

jeff <- stan(model_code = logit_code, data = sdat, iter = 2000, chains = 2)

save(jeff, file = "mod.RData")

