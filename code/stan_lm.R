library(rstan)

stanLM <- function(form, data, copy.lm = TRUE, ...) {
  if (!require(rstan)) {
    stop("You must install the rstan package.")
  }

  x <- model.matrix(form, data, copy.lm = TRUE)

  stanlm_dat <- list(
    y = model.frame(form, data)[,1],
    x = x,
    N = nrow(x),
    K = ncol(x)
  )

  if (copy.lm) {
	  stanlm_model <- "
      data {
        int<lower=0> N;
        int<lower=0> K;
        vector[N] y;
        matrix[N,K] x; 
      }
      parameters {
        vector[K] beta;
        real<lower=0> sigma;
      }
      model {
        y ~ normal(x * beta, sigma);
      }
    "
  } else {
    stanlm_model <- "
      data {
        int<lower=0> N;
        int<lower=0> K;
        vector[N] y;
        matrix[N,K] x; 
      }
      parameters {
        vector[K] beta;
        real<lower=0> sigma;
      }
      model {
        beta ~ normal(0, 1);
        sigma ~ inv_chi_square(2);
        y ~ student_t(4, x * beta, sigma);
      }
    "
  }
  stanlm.fit <- stan(model_code = stanlm_model, data = stanlm_dat, ...)

  return(stanlm.fit)
}