<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Stan
========================================================
author: Jeffrey Chrabaszcz
date: 16 January 2014
transition: none
width: 1024
height: 760




Outline
========================================================

1. How do we know what BEST is doing?
2. MCMC samplers
3. Stan/HMC
4. Data
5. Parameters
6. Transformed parameters
7. Model

How do we know what BEST is doing?
========================================================

```
model = {"
  for (i in 1:Ntotal) {
    y[i] ~ dt(mu[x[i]], tau[x[i]], nu)
  }
  for (j in 1:2) {
    mu[j] ~ dnorm(muM, muP)
    tau[j] <- 1/pow(sigma[j], 2)
    sigma[j] ~ dunif(sigmaLow, sigmaHigh)
  }
  nu <- nuMinusOne+1
  nuMinusOne ~ dexp(1/29)
"}
```

MCMC samplers
========================================================

The above is mode code for **JAGS** - just another gibbs sampler.

* very fast
* not dependent on a specific software
* open source

This is not the only sampler!
It does happen to be the most common one at the moment.

Stan/HMC
========================================================

Stan is a piece of software developed to implement Hamiltonian Markov Chain simulations.
Stan can be controlled from R, this solves a lot of problems with data management and output inspection.
Unfortunately, as with JAGS, Stan has a unique syntax for building models.
This syntax comes in four sections:

* Data
* Parameters
* Transformed Parameters
* Model

Data
========================================================


```r
data {
  int<lower=0> N;
  int<lower=0> lvl;
  vector[N] y;
  int x[N];
  vector[lvl] n;
  real muM;
  real muP;
  real sigmaLow;
  real sigmaHigh;
  real df;
}
```


Parameters
========================================================


```r
parameters {
  real mu[lvl];
  real<lower=0> sigma[lvl];
  real<lower=0> nuM;
}
```


Tranformed parameters
========================================================


```r
transformed parameters {
  real muDiff;
  real sigmaDiff;
  real<lower=0> nu;
  real effSize;
  muDiff <- mu[1] - mu[2];
  sigmaDiff <- sigma[1] - sigma[2];
  nu <- nuM + 1;
  effSize <- (mu[1] - mu[2])/sqrt((((n[1] - 1) * sigma[1]) + ((n[2] - 1) * sigma[2]))/(N - 2));
}
```


Model
========================================================


```r
model {
  nuM ~ exponential(df);
  for (i in 1:N)
    y[i] ~ student_t(nuM + 1, mu[x[i]], sigma[x[i]]);
  for (j in 1:2) {
    mu[j] ~ normal(muM, muP);
    sigma[j] ~ uniform(sigmaLow, sigmaHigh);
  }
}
```


Passing data to stan
========================================================


```r
test_dat <- list(
  N = length(c(g1, g2)),
  n = c(length(g1), length(g2)),
  lvl = 2,
  y = c(g1, g2),
  x = rep(1:2, c(length(g1), length(g2))),
  muM = mean(c(g1, g2)),
  muP = (1e6 * var(c(g1, g2))),
  sigmaLow = (var(c(g1, g2))/1000),
  sigmaHigh = (var(c(g1, g2)) * 1000),
  df = 1/29)
```


========================================================





```

TRANSLATING MODEL 't_code' FROM Stan CODE TO C++ CODE NOW.
COMPILING THE C++ CODE FOR MODEL 't_code' NOW.
SAMPLING FOR MODEL 't_code' NOW (CHAIN 1).
Iteration:   1 / 1000 [  0%]  (Warmup)Iteration: 100 / 1000 [ 10%]  (Warmup)Iteration: 200 / 1000 [ 20%]  (Warmup)Iteration: 300 / 1000 [ 30%]  (Warmup)Iteration: 400 / 1000 [ 40%]  (Warmup)Iteration: 500 / 1000 [ 50%]  (Warmup)Iteration: 600 / 1000 [ 60%]  (Sampling)Iteration: 700 / 1000 [ 70%]  (Sampling)Iteration: 800 / 1000 [ 80%]  (Sampling)Iteration: 900 / 1000 [ 90%]  (Sampling)Iteration: 1000 / 1000 [100%]  (Sampling)
Elapsed Time: 0.566511 seconds (Warm-up)
              0.506646 seconds (Sampling)
              1.07316 seconds (Total)

SAMPLING FOR MODEL 't_code' NOW (CHAIN 2).
Iteration:   1 / 1000 [  0%]  (Warmup)Iteration: 100 / 1000 [ 10%]  (Warmup)Iteration: 200 / 1000 [ 20%]  (Warmup)Iteration: 300 / 1000 [ 30%]  (Warmup)Iteration: 400 / 1000 [ 40%]  (Warmup)Iteration: 500 / 1000 [ 50%]  (Warmup)Iteration: 600 / 1000 [ 60%]  (Sampling)Iteration: 700 / 1000 [ 70%]  (Sampling)Iteration: 800 / 1000 [ 80%]  (Sampling)Iteration: 900 / 1000 [ 90%]  (Sampling)Iteration: 1000 / 1000 [100%]  (Sampling)
Elapsed Time: 0.546801 seconds (Warm-up)
              0.441533 seconds (Sampling)
              0.988334 seconds (Total)

SAMPLING FOR MODEL 't_code' NOW (CHAIN 3).
Iteration:   1 / 1000 [  0%]  (Warmup)Iteration: 100 / 1000 [ 10%]  (Warmup)Iteration: 200 / 1000 [ 20%]  (Warmup)Iteration: 300 / 1000 [ 30%]  (Warmup)Iteration: 400 / 1000 [ 40%]  (Warmup)Iteration: 500 / 1000 [ 50%]  (Warmup)Iteration: 600 / 1000 [ 60%]  (Sampling)Iteration: 700 / 1000 [ 70%]  (Sampling)Iteration: 800 / 1000 [ 80%]  (Sampling)Iteration: 900 / 1000 [ 90%]  (Sampling)Iteration: 1000 / 1000 [100%]  (Sampling)
Elapsed Time: 0.535217 seconds (Warm-up)
              0.449495 seconds (Sampling)
              0.984712 seconds (Total)
```


Inspecting stan objects
========================================================

There are two main ways to summarize stan output.

* type the object name, use the print function
* use the plot function

None of these display well, but they resulting output is similar to BEST objects.
