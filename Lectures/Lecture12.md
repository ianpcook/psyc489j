<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Stan applied
========================================================
author: Jeffrey Chrabaszcz
date: 17 January 2014
transition: none
width: 1024
height: 760




References
========================================================

<center>
![BDA](http://www.stat.columbia.edu/~gelman/book/bda_cover.png)
</center>

Outline
========================================================

1. LASSO
2. Ridge regression
3. Elastic net
4. Multiple predictors in stan
5. Applied example

LASSO
========================================================

The *least absolute shrinkage and selection operator* tends to improve prediction, (and protect against Type S errors), by shrinking parameter estimates.

$$
\beta_j \sim Laplace(0, b_\epsilon)
$$

$$
Laplace(x) = \frac{1}{2b}e^{-\frac{|x - \mu|}{b}}
$$

<img src="Lecture12-figure/viz_laplace.png" title="plot of chunk viz_laplace" alt="plot of chunk viz_laplace" style="display: block; margin: auto;" />


Ridge regression & elastic net
========================================================

At least two other shrinkage methods exist.
**Ridge regression**, which shrinks $\beta$ coefficients toward one another, and **elastic net**, which shrinks coefficients toward one another and toward zero at the same time.

This ends up being very easy to implement in MCMC.


```r
mu_b ~ double_exponential(0.0, 1.0);
b ~ normal(mu_b,1.0);
```


We say that our betas are all drawn from a normal distribution with some mean, $\mu_b$, and a variance, (which we specify).
$\mu_b$ is in turn sampled from from $\mathcal{N}(0, 1)$.
The inclusion of such small variance terms is conditioned on normalized coefficients and would otherwise be inappropriate.

========================================================


```r
parameters {
  real b0;
  vector[P] b;
  real mu_b;
  real<lower=0> tau;
  real<lower=0> nu;
}
transformed parameters {
  real<lower=0> sigma;
  sigma <- pow(tau, -0.5);
}
model {
  b0 ~ normal(0.0, 1.0);
  mu_b ~ double_exponential(0.0, 1.0);
  b ~ normal(mu_b,1.0);
  nu ~ exponential(df);
  tau ~ exponential(1);
  for (i in 1:N)
    y[i] ~ student_t(nu + 1, b0 + dot_product(x[i], b), sigma);
}
```


Applied example
========================================================

In cognitive and I/O psychology, we care a lot about predicting intelligence.
We got a community sample with 247 individuals, all of whom completed the following tasks:

* Raven's advanced progressive matrices
* Shapebuilder
* Reading span
* Need for cognition

We use these three latter variables to predict RAPM scores.

Exploratory data analysis
========================================================


```
     ravens           nfc            shape     
 Min.   : 0.00   Min.   :-29.0   Min.   : 135  
 1st Qu.: 7.00   1st Qu.: 13.5   1st Qu.: 972  
 Median :10.00   Median : 26.0   Median :1225  
 Mean   : 9.37   Mean   : 26.2   Mean   :1334  
 3rd Qu.:12.00   3rd Qu.: 40.0   3rd Qu.:1638  
 Max.   :17.00   Max.   : 72.0   Max.   :3065  
```

<img src="Lecture12-figure/viz_data.png" title="plot of chunk viz_data" alt="plot of chunk viz_data" style="display: block; margin: auto;" />


Priors
========================================================

Based on our goals and visualization, we can assume some things:

* Our outcome isn't normal!
* The goal is prediction, so we want to shrink our betas
* Motivation might compensate for WM in predicting IQ

Now we just have to specify these things.

Stan model
========================================================


```r
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
  mu_b ~ normal(0.0, 1.0);
  b ~ normal(mu_b, K/4.0);
  for (n in 1:N)
    y[n] ~ ordered_logistic(x[n] * b, c);
}
'
```


Stan data
========================================================


```r
s.data <- b.data
s.data$ravens <- s.data$ravens + 1
s.data[,-1] <- as.data.frame(scale(s.data[,-1]))
s.data$shape.by.nfc <- s.data$nfc * s.data$shape

logit_dat <- list(y = s.data[,1],
                 x = s.data[,-1],
                 N = nrow(s.data),
                 P = ncol(s.data) - 1,
                 K = length(unique(s.data[,1]))
)

l.posterior <- stan(model_code = logit_code, data = logit_dat, iter = 1000, chains = 3)
```


Ordered logistic results
========================================================

<img src="Lecture12-figure/cater_plot1.png" title="plot of chunk cater_plot" alt="plot of chunk cater_plot" style="display: block; margin: auto;" /><img src="Lecture12-figure/cater_plot2.png" title="plot of chunk cater_plot" alt="plot of chunk cater_plot" style="display: block; margin: auto;" />


Diagnostics (betas)
========================================================

<img src="Lecture12-figure/conv_plot_b.png" title="plot of chunk conv_plot_b" alt="plot of chunk conv_plot_b" style="display: block; margin: auto;" />


Diagnostics (cuts)
========================================================

<img src="Lecture12-figure/conv_plot_c.png" title="plot of chunk conv_plot_c" alt="plot of chunk conv_plot_c" style="display: block; margin: auto;" />

