<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Basic probability, inference
========================================================
author: Jeffrey Chrabaszcz
date: 6 January 2014
transition: none
width: 1024
height: 760




Outline
========================================================

1. Basics of probability
2. Probability distributions
3. Statistical inference
4. Classic confidence intervals
5. Classical hypothesis testing
6. Problems with *statistical significance*

Basics of probability
========================================================
left: 50%

General
--------------------------------------------------------

1. Definition of probability
  * $P(A) + P(\neg A) = 1$
  * $\sum\limits_{k = 1}^N P(x_k) = 1$
2. Intersection (AND, &)
  * $P(A \cap B) = P(A) \cdot P(B)$
3. Union (OR, |)
  *  $P(A \cup B) = P(A) + P(B) - P(A \cap B)$
4. Conditional probability
  * $P(A | B) = \frac{\displaystyle P(A \cap B)}{\displaystyle P(B)}$

***

Bayes' Rule
--------------------------------------------------------

1. Definition
  * $P(B | A) = \frac{\displaystyle P(A | B) \cdot P (B)}{\displaystyle P(A)}$  
2. Finite alternatives
  * $P(H_i | D) = \frac{\displaystyle P(D | H_i) \cdot P (H_i)}{\displaystyle \sum\limits_{i=1}^N P(D | H_i)}$

AND, OR
========================================================





```r
mean(juul$age[juul$sex == 1 & juul$tanner == 1], na.rm = TRUE)
```

```
[1] 8.05
```

```r
mean(juul$age[juul$sex == 1 | juul$tanner == 1], na.rm = TRUE)
```

```
[1] 13.5
```


Many small random variables
========================================================
left: 45%


```r
points <- rbinom(100, 1, .5)
head(points)
```

```
[1] 0 1 0 1 0 1
```

```r
sum(points)
```

```
[1] 44
```

```r
all.points <- matrix(rbinom(10000, 1, .5), ncol = 100)
```


***


```r
var(points)
```

```
[1] 0.249
```

```r
var(colSums(all.points))
```

```
[1] 26.7
```

```r
mean(colSums(all.points))
```

```
[1] 50
```


Central limit theorem
========================================================

Assuming the variance of the individual components is smaller than the aggregate score, (as in the last example), the **central limit theorem** holds.

$$
\lim_{n\to \infty} P\left(\frac{S_n - n\mu}{\sigma\sqrt{n}} \leq x\right) = \phi(x)
$$

<img src="Lecture03-figure/clt_hist.png" title="plot of chunk clt_hist" alt="plot of chunk clt_hist" style="display: block; margin: auto;" />


Surprise! Calculus.
========================================================

* Derivation, $\frac{dy}{dx}$, is a rate of change. Think of it as the slope of a line.
* Integration, $\int$, is the area under the curve.
* Summation, $\sum$, is integration for discrete things.

<img src="Lecture03-figure/calc_viz.png" title="plot of chunk calc_viz" alt="plot of chunk calc_viz" style="display: block; margin: auto;" />


Probability distributions
========================================================

Probability distributions are special functions that **integrate to 1**.
One example is a **normal distribution**, which has the following function:

$$
f(x) = \frac{1}{\sqrt{2\pi\sigma^2}}e^{-\frac{(x - \mu)^2}{2\sigma^2}}
$$

The **standard normal** is defined as $\mu = 0$ and $\sigma = 1$.

<img src="Lecture03-figure/standard_normal.png" title="plot of chunk standard_normal" alt="plot of chunk standard_normal" style="display: block; margin: auto;" />


Mean and variance
========================================================

Expected value of the normal distribution is the mean:

$$
E[X] = \int_{-\infty}^{\infty} x \cdot f(x) dx
$$

For a sample, we can't integrate:

$$
\bar{X} = \sum\limits_{i = 1}^N \frac{x_i}{N}
$$

Knowing this, we can also get an estimate of spread:

$$
\sigma^{2}_x = \frac{\sum\limits_{i = 1}^N \left(x_i - \bar{x}\right)^2}{N - 1}
$$

Normals in R
========================================================
left: 50%
Most standard probability distributions have a set of functions in R.

* density, d
* distribution, p
* quantile, q
* random deviates, r

Will also work for binomial, poisson, etc.

***


```r
pnorm(0)
```

```
[1] 0.5
```

```r
rnorm(10)
```

```
 [1] -1.058  2.318  0.137  0.179  0.761 -1.840 -0.362  0.761  0.418 -1.039
```


Binomial
========================================================

This distribution represents the number of times some binary event occurs when it has probability $p$ and number of chances $k$.
Two parameters: $n$ and $k$.

$$
P(x = k) = {n \choose k}p^k(1 - p)^{n-k}
$$

<img src="Lecture03-figure/binomial.png" title="plot of chunk binomial" alt="plot of chunk binomial" style="display: block; margin: auto;" />


Poisson
========================================================

The probability of a number of events occuring in a given time period. Only one parameter, $\lambda$.

$$
P(x = k) = \frac{\lambda^k e^{-k}}{k!}
$$

<img src="Lecture03-figure/poisson.png" title="plot of chunk poisson" alt="plot of chunk poisson" style="display: block; margin: auto;" />


Estimated regression coefficients
========================================================

We'll get to the linear model tomorrow, but regression coefficients are ultimately normally distributed.
This happens because regression weights are a linear combination of data. Formally:

$$
\beta = (X^tX)^{-1}X^ty
$$

$$
y_i = \beta_0 + \beta_1 \cdot x_{1i} + \beta_2 \cdot x_{2i} + ... + \epsilon_i
$$

This is important for later in the class! Parameters, just like data, can be subject to distributions.

Statistical modeling
========================================================
left: 50%

sampling model
-----

* data represent perfect observations of a small sample
* sample is representative of a population of interest
* goal is to learn about the population
* generally combined with measurement model

***

measurement model
-----

* data represent imperfect observations of a sample of interest
* sample is itself interesting, regardless of any superpopulation
* goal is to learn about sample despite measurement error

Parameters and estimation
========================================================
left: 50%

Statistical tests have a common goal: quantify uncertainty.
Before we gather any data, we have some ideas about our outcome variable.
Then we gather some data and we make some decisions:

* what did we know before we started?
* what did we learn from our experiment?
* how much have our beliefs changed and what do we know now?

***

<img src="Lecture03-figure/pre_bayes.png" title="plot of chunk pre_bayes" alt="plot of chunk pre_bayes" style="display: block; margin: auto;" />


Standard errors
========================================================

Both the mean and standard deviation are independent of sample size.
With each sample of the mean, our estimate of the population value increases.
This is because the **standard error** decreases.

$$
SEM = \sqrt{\frac{\sigma^2}{N}}
$$

<img src="Lecture03-figure/std_error.png" title="plot of chunk std_error" alt="plot of chunk std_error" style="display: block; margin: auto;" />


Classical confidence intervals
========================================================


```r
y <- c(35, 34, 38, 35, 37)
n <- length(y)
estimate <- mean(y)
se <- sd(y)/sqrt(n)
int.50 <- estimate + qt(c(.25, .75), n-1) * se
int.95 <- estimate + qt(c(.025, .975), n-1) * se
int.50
```

```
[1] 35.3 36.3
```

```r
int.95
```

```
[1] 33.8 37.8
```


Confidence intervals for proportions
========================================================


```r
y <- 700
n <- 1000
estimate <- y/n
se <- sqrt(estimate * (1 - estimate)/n)
int.95 <- estimate + qnorm(c(.025, .975)) * se
int.95
```

```
[1] 0.672 0.728
```


Discrete data
========================================================


```r
y <- rep(0:4, c(600, 300, 50, 30, 20))
n <- length(y)
estimate <- mean(y)
se <- sd(y)/sqrt(n)
int.50 <- estimate + qt(c(.25, .75), n-1) * se
int.50
```

```
[1] 0.551 0.589
```


Numerical comparisons
========================================================

Assume we have proportion of people improved by some treatment for two groups.

$$
\begin{array}{rcl}
80\% &\pm& 1.4\% \\
74\% &\pm& 1.3\%
\end{array}
$$

Rather than explicitly comparing the groups, we can recast these quantities and examine the difference.

$$
\begin{array}{rcl}
80\% - 74\% &=& 6\% \\
\sqrt{(1.4\%)^2 + (1.3\%)^2} &=& 1.9\%
\end{array}
$$

Visual comparisons
========================================================





```r
qplot(year, support, data = a, geom = "errorbar", ymin = support - se, ymax = support + se) + geom_point(size = 2) + theme_bw(base_size = 24)
```

<img src="Lecture03-figure/viz_comp_plot.png" title="plot of chunk viz_comp_plot" alt="plot of chunk viz_comp_plot" style="display: block; margin: auto;" />


Classical hypothesis testing
========================================================

All NHST involves setting up a point null and testing the probability of observing your data given that the null is true.

$$
H_0: \mu_1 - \mu_2 = 0
$$

You can think of this like confidence intervals: if we say the difference is zero, we can then look at the observed difference and the 95% CI around the difference. If 0 is not in the CI, reject the null with (at least) a 5% false alarm rate.

Problems with statistical significance
========================================================
left: 50%

statistical significance does not equal practical significance
------

SEM decreases with $N$, so even very small effects can become *significant* with a large effect size.

$$
t = \frac{\bar{x}}{\sqrt{\frac{\sigma^2}{N}}}
$$

***

changes in significance are not themselves significant
-----

<img src="Lecture03-figure/problems_with.png" title="plot of chunk problems_with" alt="plot of chunk problems_with" style="display: block; margin: auto;" />

