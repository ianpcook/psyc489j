<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Simulation methods
========================================================
author: Jeffrey Chrabaszcz
date: 10 January 2014
transition: none
width: 1024
height: 760




Outline
========================================================

1. Pseudo-random numbers
2. Permutation tests
3. Cross-validation
4. Bootstrapping
5. Modeling parameter uncertainty

Pseudo-random numbers
========================================================

We can get nearly random numbers with [atmospheric noise](http://www.random.org) and [cesium atomic decay](http://www.fourmilab.ch/hotbits/).

We can get pseudo-random numbers from computers. Pseudorandom algorithms are excellent at drawing uniform numbers.


```r
set.seed(42)
runif(10)
```

```
 [1] 0.915 0.937 0.286 0.830 0.642 0.519 0.737 0.135 0.657 0.705
```


Random is defined by context
========================================================


```r
set.seed(42)
a <- runif(10000)
qplot(a, binwidth = .01) + theme_bw(base_size = 24) + xlim(c(-.5, 1.5)) + ylim(c(0, 200))
```

<img src="Lecture07-figure/plotting_runif.png" title="plot of chunk plotting_runif" alt="plot of chunk plotting_runif" style="display: block; margin: auto;" />


Accept-reject methods
========================================================

One old and slow method for generating desirable distributions is the accept-reject method. This is not what your computer is doing, but it's a reasonable approximation that we can use for demonstration.

We require only a way of determining relative heights of a function,[f(x)], and a method of drawin uniformly-distributed numbers.

1. Generate a candidate x value.
2. Generate a corresponding y value.
3. Reject if y > f(x), otherwise keep.
4. Repeat many times.

Accept-reject code
========================================================

This code runs an accept-reject algorithm to determine a unit normal over a specified range.


```r
acceptReject <- function(lb, ub, fx) {
  x <- runif(1) * (ub - lb) + lb
  y <- runif(1)
  out <- ifelse(y > fx(x), NA, y)
  return(c(x, out))
}
```


Using  the function
========================================================

We have some options for iterating in R. We need to run that accept-reject function a large number of times to get a good idea of our target distribution. One way involves explicit loops:


```r
n <- 10000
loop.df <- data.frame(x = rep(NA, n), y = rep(NA, n))
for (i in 1:n) {
  temp <- acceptReject(-5, 5, dnorm)
  loop.df$x[i] <- temp[1]
  loop.df$y[i] <- temp[2]
}
```


Using the function
========================================================

Alternately, we could use the faster/more convenient **replicate**.


```r
b <- replicate(10000, acceptReject(-5, 5, dnorm))
df <- as.data.frame(t(b))
names(df) <- c("x", "y")
```


Plotted results
========================================================


```r
qplot(x, y, data = df) + theme_bw(base_size = 24)
```

<img src="Lecture07-figure/ar_results.png" title="plot of chunk ar_results" alt="plot of chunk ar_results" style="display: block; margin: auto;" />


Sample function
========================================================

The **sample** function in R is a useful way to randomly sample objects in a finite set.


```r
sample(c("heads", "tails"), 10, replace = TRUE)
```

```
 [1] "tails" "tails" "tails" "heads" "tails" "tails" "heads" "tails"
 [9] "heads" "heads"
```


There are many uses of sample, (not just sampling coin flips), but this is one application.

Permutation tests
========================================================

We can use simulations to side-step some of the assumptions of NHST and multiple regression. Permutation tests do not assume normality of errors. As a result, they are robust to **skewness** and **outliers**, two plagues of traditional statistics.

1. Choose test
2. Perform test as norm to derive test statistic, (ignore p value)
3. Randomly order predictor, perform test using re-ordered predictor
4. Repeat 3 many times
5. Determine probability of obtaining test as large or larger than result of step 2.

Permutation example
========================================================


```r
data(sleep)
permTest <- function(df) {
  df$x <- sample(df$x, length(df$x))
  return(t.test(y ~ x, data = df)$statistic)
}

n <- 1000
t.real <- t.test(sleep$extra ~ sleep$group)$statistic
ts <- replicate(n, permTest(data.frame(x = sleep$group, y = sleep$extra)))
sum(abs(ts) > abs(t.real))/n
```

```
[1] 0.073
```


Split-half cross-validation
========================================================

A cheap alternative to some problems otherwise solved by external validation, superseded by bootstrapping in most cases.


```r
data(diamonds)
select.data <- sample(1:nrow(diamonds), nrow(diamonds)/2)
my.lm <- lm(price ~ carat * clarity * x * y * z, data = diamonds[select.data,])
cross.val <- predict(my.lm, diamonds[-select.data,], type = "response")
```


Using cross-validation
========================================================


```r
c(sd(diamonds$price[select.data]), sd(residuals(my.lm)))
```

```
[1] 4008 1011
```

```r
c(sd(diamonds$price[-select.data]), sd(diamonds$price[-select.data] - cross.val))
```

```
[1]  3971 12010
```


Bootstrap
========================================================

Treat the sample as a "population," repeatedly sample cases with replacement and fit models.
Creates an empirical 95% CI.


```r
bootS <- function(model.formula, df) {
  new.df <- df[sample(nrow(df), nrow(df), replace = TRUE),]
  mod <- lm(model.formula, data = new.df)
  return(coef(mod))
}

df <- read.csv("students/labs/ravensdata.csv")
b <- t(replicate(1000, bootS(ravens ~ shape * nfc, df)))
```


Bootstrap output
========================================================


```r
apply(b, 2, FUN = quantile, probs = c(.025, .975))
```

```
      (Intercept)   shape    nfc shape:nfc
2.5%        0.418 0.00347 0.0656 -7.91e-05
97.5%       3.706 0.00583 0.1562 -1.75e-05
```


<img src="Lecture07-figure/boot_graph.png" title="plot of chunk boot_graph" alt="plot of chunk boot_graph" style="display: block; margin: auto;" />


Modeling parameter uncertainty
========================================================

A subtly different approach is to simulate random draws from the distributions defined by your coefficients and coefficent standard errors while correcting for multicollinearity.


```r
library(arm)
my.lm <- lm(ravens ~ nfc, data = df)
my.sim <- sim(my.lm, n.sims = 50)
str(my.sim)
```

```
Formal class 'sim' [package "arm"] with 2 slots
  ..@ coef : num [1:50, 1:2] 8.07 7.75 7.93 8.22 7.11 ...
  .. ..- attr(*, "dimnames")=List of 2
  .. .. ..$ : NULL
  .. .. ..$ : NULL
  ..@ sigma: num [1:50] 3.01 3.16 3.17 3.1 3.03 ...
```


Graphing sim output
========================================================


```r
ggplot(df, aes(nfc, ravens)) + geom_abline(data = as.data.frame(my.sim@coef), aes(intercept = V1, slope = V2), color = "grey") + geom_point() + theme_bw(base_size = 24)
```

<img src="Lecture07-figure/sim_graph.png" title="plot of chunk sim_graph" alt="plot of chunk sim_graph" style="display: block; margin: auto;" />

