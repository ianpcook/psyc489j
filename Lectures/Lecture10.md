<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Bayesian estimation supercedes the t test
========================================================
author: Jeffrey Chrabaszcz
date: 14 January 2014
transition: none
width: 1024
height: 760




Work/time relationship
========================================================

<center>
![programming](http://cdn.oreilly.com/radar/images/posts/data-jujitsu/2-work-vs-time-580.png)
</center>

Outline
========================================================

1. Thinking about distributions
2. Exponential distribution
3. Hyperparameters
4. Beyond means
5. Priors for practical purposes
6. BEST

Exponential distribution
========================================================

The exponential distribution is only defined for $x \ge 0$.

$$
f(x) = \lambda e^{-\lambda x}
$$

<img src="Lecture10-figure/exp_plot.png" title="plot of chunk exp_plot" alt="plot of chunk exp_plot" style="display: block; margin: auto;" />


Thinking about distributions
========================================================

When using MCMC methods, you start to focus on different properties of distributions.

* Boundedness - single bound, double-bound, or unbound?
* Flexibility - beta can look like anything, uniform is nearly invariant
* Generation speed - generating draws from $\mathcal{N}(0, 1)$ is trivial, Dirichlet and Cauchy draws are not

Priors for practical purposes
========================================================

Priors are included for two reasons:

1. Encode information relevant to a problem
2. Speed model convergence

When N becomes large, most things are approximated with a normal distribution.
Before that, it often makes sense to pick a more appropriate likelihood distribution, especially when scores are bounded or priors are highly informed.

Hyperparameters
========================================================

We're going to abuse the word **prior** in a short few slides.

$$
y_i \sim \mathcal{N}(\beta_0 + \beta_k X_{ki}, \epsilon_i^2)
$$

By default, we assume that our coefficients are drawn from a uniform without bounds.

$$
\beta_k \sim \mathcal{U}(-\infty, \infty)
$$

We can commonly improve prediction by instead using LASSO.

$$
\beta_k \sim \mathcal{N}(0, \sigma_y^2)
$$

Beyond means
========================================================
left: 50%

Other parameters
---

What happens when we want to test the difference between the means of groups that have different variances?
How about testing the difference between variances?
The F test and Barlett's test both accomplish this, but are sensitive to violations of normality.

***

Other distributions
---

What we don't want to assume a normal distribution and don't have a link function, or don't know the link function?

MCMC sampling offers a way to estimate distributions are parameters of any specified distribution.

BEST
========================================================

We can run a Bayesian t-test with BEST.


```r
library(BEST)
library(ISwR)
data(juul)
juul <- juul[complete.cases(juul$sex, juul$igf1),]
mod <- BESTmcmc(juul$igf1[juul$sex == 1], juul$igf1[juul$sex == 2], verbose = FALSE)
```


BEST object
========================================================

<pre><code style="font-size:18pt">
Classes 'BEST' and 'data.frame':	100002 obs. of  5 variables:
 $ mu1   : num  305 306 307 315 315 ...
 $ mu2   : num  378 374 372 377 372 ...
 $ nu    : num  53.5 59.4 31.1 57.9 63.1 ...
 $ sigma1: num  171 164 166 164 171 ...
 $ sigma2: num  164 154 159 160 155 ...
 - attr(*, "Rhat")= Named num  1 1 1 1 1
  ..- attr(*, "names")= chr  "mu[1]" "mu[2]" "nu" "sigma[1]" ...
 - attr(*, "n.eff")= Named num  58873 60603 23027 49505 51076
  ..- attr(*, "names")= chr  "mu[1]" "mu[2]" "nu" "sigma[1]" ...
 - attr(*, "data")=List of 2
  ..$ y1: num  101 97 106 111 79 43 64 90 141 42 ...
  ..$ y2: num  682 51 25 250 179 163 191 106 218 151 ...

</code></pre>

BEST output
========================================================

<pre><code style="font-size:18pt">
             mean  median    mode HDI%   HDIlo   HDIup compVal %>compVal
mu1       308.525 308.553 308.869   95 292.962 323.994                  
mu2       366.175 366.166 365.680   95 351.840 380.476                  
muDiff    -57.650 -57.654 -57.938   95 -78.639 -36.760       0         0
sigma1    166.566 166.473 166.249   95 155.345 178.296                  
sigma2    164.593 164.500 164.365   95 154.160 175.264                  
sigmaDiff   1.973   1.953   2.206   95 -13.136  16.705       0        60
nu         59.775  51.813  37.567   95  15.040 125.132                  
log10nu     1.719   1.714   1.708   95   1.300   2.154                  
effSz      -0.348  -0.348  -0.346   95  -0.479  -0.224       0         0

</code></pre>
