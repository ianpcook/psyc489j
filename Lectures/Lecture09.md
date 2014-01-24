<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Markov chains
========================================================
author: Jeffrey Chrabaszcz
date: 14 January 2014
transition: none
width: 1024
height: 760




Outline
========================================================

1. Fixing a mistake
2. Likelihood calculation for continuous variables
3. Maximizing likelihood
4. Markov chains

Fixing a mistake
========================================================

Yesterday I listed the objective function as:

$$
\hat{\ell}(\theta|x) = \frac{1}{n}\sum_{i = 1}^n \ln f(x_i|\theta)
$$

But had you calculate a likelihood using:


```r
sum(dpois(obs, rate))
```


This code is wrong! Fixing it might yield some insight into how likelihood calculation works.

Unions
========================================================

We need two pieces of information to make this work.
The first is:

$$
P(A \cup B) = P(A) \cdot P(B)
$$

The second is that:

$$
log(A \cdot B) = log(A) + log(B)
$$

We can think of the objective function as the joint probability of each piece of data having been observed, given the parameter/hypothesis.

Correcting our code
========================================================

This means that our code should have read:


```r
prod(dpois(obs, rate))
```


Unfortunately, this can lead to values so small that it's hard for computers to easily keep track of them, (I'm not kidding).
Instead, we use the form:


```r
exp(sum(log(dpois(obs, rate))))
```


We take a natural logarithm so we can add values together, then exponentiate so we can view the result on a standard scale.

Likelihood calculation for continuous variable
========================================================

The normal distribution is defined for all possible values of X.
Say we sample five values from a standard normal distribution.


```
[1]  0.540 -0.503 -0.620  0.070  0.157
```


We can visualize the probability density associated with each of these samples assuming $\mu = 0$ and $\sigma = 1$ on the following graph.

<img src="Lecture09-figure/lik_plot.png" title="plot of chunk lik_plot" alt="plot of chunk lik_plot" style="display: block; margin: auto;" />


Heights of lines
========================================================

The heights of those lines are dictated by the parameters of the normal distribution.
That means we can change the heights by changing the parameters!

<img src="Lecture09-figure/lik_plot2.png" title="plot of chunk lik_plot2" alt="plot of chunk lik_plot2" style="display: block; margin: auto;" />


Maximizing likelihood
========================================================


```r
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
```


Outputs for ML (lm vs. bootstrap)
========================================================





```r
data(women)
fit <- lm(weight ~ height, data = women)
fit.ll <- logL(coef(fit), women$weight, women$height, sd(residuals(fit)))
b <- t(replicate(100, bootS(weight ~ height, women)))
rsds <- apply(b, 1, function(x) getRSD(x, women$weight, women$height))
a <- cbind(b, rsds)
all.lls <- apply(a, 1, function(x) logL(x[1:2], women$weight, women$height, x[3]))
c(fit.ll, max(all.lls))
```

```
[1] -26.558 -26.564
```





Random search
========================================================

A class of optimization methods that can be used with problems that are not continuous or differentiable.
Encompasses two general approaches.

Point estimation
---

Find a maximum/minimum point for some outcome.
A lot of you probably think of information criteria in this way.

Distribution estimation
---

A sampling procedure that converges to a distribution rather than a single point.
This is what we'll be doing.

Quick point-estimation example
========================================================

Say we have a normal distribution and need to find the x value for which f(x) is maximized.
We'll set up a toy example for which the true maximized value is 0.


```r
xs <- runif(10000, -3, 10)
xs[dnorm(xs) == max(dnorm(xs))]
```

```
[1] 2.51e-05
```


I can't honest recommend this method, but it's a very simple demonstration of how random search could work.

Markov chains
========================================================

Kruschke's island-hopping example is the clearest explanation I've ever heard for this.

========================================================


```r
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
```


Island example output
========================================================


```r
mcmc.approx <- table(visits)/length(visits)
true.props <- islands/sum(islands)
names(true.props) <- names(mcmc.approx)

mcmc.approx
```

```
visits
     1      2      3      4      5      6 
0.0465 0.0940 0.1435 0.1924 0.2394 0.2842 
```

```r
true.props
```

```
     1      2      3      4      5      6 
0.0476 0.0952 0.1429 0.1905 0.2381 0.2857 
```

