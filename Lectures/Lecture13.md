<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Multilevel models
========================================================
author: Jeffrey Chrabaszcz
date: 21 January 2014
transition: none
width: 1024
height: 760




Outline
========================================================

1. Why use multilevel models?
2. Varying intercepts and slopes
3. Partial pooling without predictors
4. Partial pooling with predictors
5. Quickly fitting multilevel models in R
6. Five ways to write the same model

Why use multilevel models?
========================================================

We say that observations are independent if:

$$
P(A \cap B) = P(A) \cdot P(B)
$$

All of our statistical tests assume independence of our data, you can tell by looking at the likelihood formula!

$$
\hat{\ell}(\theta|x) = \frac{1}{n}\sum_{i = 1}^n \ln f(x_i|\theta)
$$

When we violate independence, our tests are necessarily overconfident, (error bars are too narrow).
This happens when there is structure in the data not reflected in our tests.

Varying intercepts and slopes
========================================================

With MLM, we introduce information into the model relevant to known sources of dependence.
We can then allow outcomes levels, or relationships between the outcome and our predictors, to vary as a function of these sources.

<img src="Lecture13-figure/intercept_slope_plot.png" title="plot of chunk intercept_slope_plot" alt="plot of chunk intercept_slope_plot" style="display: block; margin: auto;" />


Critically, we do this in a way that still informs our predictors across all groups.

Partial pooling
========================================================

We say multilevel estimates are partially pooled because they represent a compromise between full pooling and no pooling.

* Full pooling - assume each group is independent of the others.
* No pooling - assume the groups do not differ in any meaningful way.
* Partial pooling - assume groups are drawn from a shared distribution.

No pooling and full pooling both be implemented in **lm()**.
Partial pooling requires some extra machinery.

Partial pooling
========================================================

To get partial pooling estimates, we have to add to the linear model.
We know the linear model as

$$
y_i = \beta_0 + \beta_1 \cdot x_{1i} + \epsilon_i
$$

We can now add one subscript and a second equation to describe random intercepts.

$$
\begin{align}
y_i &= \beta_{0[j]} + \beta_1 \cdot x_{1i} + \epsilon_i \\
\beta_{0[j]} &= \gamma_0 \cdot u_1 + \epsilon_j
\end{align}
$$

Partial pooling
========================================================

We've already looked at stan, so the following more general equations might make more sense.

$$
\begin{align}
y_i &\sim \mathcal{N}(X_i\beta_{j}, \sigma_i^2) \\
\beta_j &\sim \mathcal{N}(U_j\gamma, \sigma_j^2)
\end{align}
$$

This should look something like code we've already encountered:


```r
model {
  y[i] ~ normal(inprod(x[i], b), sigma);
  b ~ normal(0, 1);
}
```


Now we're just going to add observed information into that hierarchical level.

Partial pooling without predictors
========================================================

We've looked at the sleep data before, we can use it to examine how partial pooling works.
First, let's Look at full pooling and no pooling estimates.


```r
data(sleep)
pool <- lm(extra ~ 1, data = sleep)
no.pool <- lm(extra ~ ID, data = sleep)
library(lme4)
part.pool <- lmer(extra ~ 1 + (1|ID), data = sleep)
```


Full pooling
========================================================


```r
display(pool)
```

```
lm(formula = extra ~ 1, data = sleep)
            coef.est coef.se
(Intercept) 1.54     0.45   
---
n = 20, k = 1
residual sd = 2.02, R-Squared = 0.00
```


No pooling
========================================================


```r
display(no.pool)
```

```
lm(formula = extra ~ ID, data = sleep)
            coef.est coef.se
(Intercept)  1.30     0.98  
ID2         -1.70     1.39  
ID3         -0.85     1.39  
ID4         -1.85     1.39  
ID5         -1.40     1.39  
ID6          2.60     1.39  
ID7          3.30     1.39  
ID8         -0.10     1.39  
ID9          1.00     1.39  
ID10         1.40     1.39  
---
n = 20, k = 10
residual sd = 1.39, R-Squared = 0.75
```


Partial pooling
========================================================


```r
display(part.pool)
```

```
lmer(formula = extra ~ 1 + (1 | ID), data = sleep)
coef.est  coef.se 
    1.54     0.57 

Error terms:
 Groups   Name        Std.Dev.
 ID       (Intercept) 1.50    
 Residual             1.39    
---
number of obs: 20, groups: ID, 10
AIC = 86.3, DIC = 81.6
deviance = 80.9 
```


Graphical comparison
========================================================

<img src="Lecture13-figure/pool_boxes.png" title="plot of chunk pool_boxes" alt="plot of chunk pool_boxes" style="display: block; margin: auto;" />


<img src="Lecture13-figure/model_coefs.png" title="plot of chunk model_coefs" alt="plot of chunk model_coefs" style="display: block; margin: auto;" />


Partial pooling with predictors
========================================================





```r
display(pool)
```

```
lm(formula = extra ~ group, data = sleep)
            coef.est coef.se
(Intercept) 0.75     0.60   
group2      1.58     0.85   
---
n = 20, k = 2
residual sd = 1.90, R-Squared = 0.16
```


Partial pooling with predictors
========================================================


```r
display(no.pool)
```

```
lm(formula = extra ~ group + ID, data = sleep)
            coef.est coef.se
(Intercept)  0.51     0.65  
group2       1.58     0.39  
ID2         -1.70     0.87  
ID3         -0.85     0.87  
ID4         -1.85     0.87  
ID5         -1.40     0.87  
ID6          2.60     0.87  
ID7          3.30     0.87  
ID8         -0.10     0.87  
ID9          1.00     0.87  
ID10         1.40     0.87  
---
n = 20, k = 11
residual sd = 0.87, R-Squared = 0.91
```


Partial pooling with predictors
========================================================


```r
display(part.pool)
```

```
lmer(formula = extra ~ group + (1 | ID), data = sleep)
            coef.est coef.se
(Intercept) 0.75     0.60   
group2      1.58     0.39   

Error terms:
 Groups   Name        Std.Dev.
 ID       (Intercept) 1.69    
 Residual             0.87    
---
number of obs: 20, groups: ID, 10
AIC = 78, DIC = 71.1
deviance = 70.5 
```


Graphical analogue
========================================================


```r
ggplot(sleep, aes(group, extra)) + geom_boxplot(group = 1) + geom_jitter(size = 5, position = position_jitter(.25), aes(color = ID)) + theme_bw(base_size = 24)
```

<img src="Lecture13-figure/unnamed-chunk-8.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" style="display: block; margin: auto;" />


Multilevel model syntax in lme4
========================================================

**lme4** is by major package used to fit multilevel models in R.
The syntax is very similar to the **lm** function.

```
lmer(outcome ~ predictor + (random intercept and/or slope | group), data = df, ...)
```

For exampe, imagine we had multiple measurements from each person for both groups and wanted to see if the difference varied by person.
We could fit:


```r
fit <- lmer(extra ~ group + (1 + group|ID), data = sleep)
```


Five ways to write the same model
========================================================

There are at least five equivalent ways to think of a multilevel model.

1. Allowing regression coefficients to vary across groups
2. Combining separate local regressions
3. Modeling the coefficients of a large regression model
4. Regression with multiple error terms
5. Large regression with correlated errors

We'll use a simple version of the linear model as a base:

$$
y_i = \alpha + \beta \cdot x_i + \epsilon_i
$$

Allowing regression coefficients to vary across groups
========================================================

$$
\begin{align}
  y_i &= \alpha_{j[i]} + \beta \cdot x_i + \epsilon_i \\
  \alpha_j &= \mu_{\alpha} + \eta_{j}
\end{align}
$$

In this case we have two "hidden" distributional assumptions.

$$
\begin{align}
  y_i &\sim \mathcal{N}(\alpha_j + \beta x_i, \sigma_y^2) \\
  \alpha_i &\sim \mathcal{N}(\mu_\alpha, \sigma^2_{\alpha})
\end{align}
$$

Combining separate local regressions
========================================================

Within each group:

$$
y_i \sim \mathcal{N}(\alpha_j + \beta x_i, \sigma^2_y)
$$

While the intercept term, the thing that varies by group, is:

$$
\alpha_j \sim \mathcal{N}(\gamma_0 + \gamma_1 u_j, \sigma^2_{\alpha})
$$

Modeling the coefficients of a large regression model
========================================================

Here we that the coefficients are drawn from a distribution 

$$
\begin{align}
  y_i &\sim \mathcal{N}(X_i \beta, \sigma^2_y) \\
  \beta_j &\sim \mathcal{N}(0, \sigma^2_{\alpha})
\end{align}
$$

Remember that we have an intercept coded in our X matrix.
The coefficients are centered at zero, but the y-intercept emerges when all other X values are zeroed.

Regression with multiple error terms
========================================================

Here we specify a shift in the mean based on a second error distribution.

$$
\begin{align}
  y_i &\sim \mathcal{N}(X_i \beta + \eta_{j[i]}, \sigma^2_y) \\
  \eta_j &\sim{N}(0, \sigma^2_{\alpha})
\end{align}
$$

Large regression with correlated errors
========================================================

Here we say that the variance parameter for the error distribution varies by group membership.

$$
\begin{align}
  y_i &= X_i \beta + \epsilon^{all} \\
  \epsilon^{all} &\sim \mathcal{N}(0, \Sigma)
\end{align}
$$
