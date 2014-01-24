<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Logistic regression
========================================================
author: Jeffrey Chrabaszcz
date: 9 January 2014
transition: none
width: 1024
height: 760




Modeling competition
========================================================

1. Some number of teams.
2. Use any combination or transformation of the data in **ravensdata.csv** to predict "ravens".
3. Best AIC for an interpretable and graphable model wins.

Outline
========================================================

1. Logistic regression functions
2. Fitting a logistic regression
3. Graphing logistic regressions
4. Interpretting logistic regression coefficients

Logistic regression
========================================================

To handle dichotomous outcome variables, we need the logistic, (and logit), functions.

$$
P(y_i = 1) = logit^{-1}(X_i\beta)
$$

$$
logit(p) = log\left(\frac{p}{(1 - p)}\right)
$$

Logistic function
========================================================

$$
logit^{-1}(x) = \frac{1}{(1 + e^{-x})}, logit^{-1}(x) = \frac{e^x}{(1 + e^{x})}
$$

<img src="Lecture06-figure/logistic_plot.png" title="plot of chunk logistic_plot" alt="plot of chunk logistic_plot" style="display: block; margin: auto;" />


Alternate formulation
========================================================

You can think of this as a two-step process.
First:

$$
logit(p_i) = X_i\beta
$$

This rescales our predictions to range form 0 to 1.
Then:

$$
P(y_i = 1) = p_i
$$

Even if this doesn't help you understand logistic regression, put a pin in it.

Fitting a logistic regression
========================================================


```
glm(formula = menarche ~ age, family = binomial, data = juul.girl)
            coef.est coef.se
(Intercept) -20.01     2.03 
age           1.52     0.15 
---
  n = 519, k = 2
  residual deviance = 200.7, null deviance = 719.4 (difference = 518.7)
```


How can we determine the median matricarcheal age?
Set $logit(p)$ equal to 0, which returns the value of age corresponding to a 50% prediction.


```r
20.01/1.52
```

```
[1] 13.2
```


Quick graph for one predictor
========================================================


```r
qplot(age, menarche, data = juul.girl) + theme_bw(base_size = 24)
```

<img src="Lecture06-figure/juul_graph.png" title="plot of chunk juul_graph" alt="plot of chunk juul_graph" style="display: block; margin: auto;" />


Better graph
========================================================

<img src="Lecture06-figure/juul_graph2.png" title="plot of chunk juul_graph2" alt="plot of chunk juul_graph2" style="display: block; margin: auto;" />


Interpreting logistic regression coefficients
========================================================

Logistic regression coefficients change across the range of the function.
A few things can help interpretation:

1. Gelman's "divide by 4" rule.
2. Exponentiate the coefficient


```r
invlogit(1.52)
```

```
[1] 0.821
```

```r
exp(1.52)
```

```
[1] 4.57
```

