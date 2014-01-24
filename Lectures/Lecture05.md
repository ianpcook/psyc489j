<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Linear regression: before and after fitting
========================================================
author: Jeffrey Chrabaszcz
date: 8 January 2014
transition: none
width: 1024
height: 760




Outline
========================================================

1. Dummy coding
2. Linear transformations
3. Centering and standardizing
4. Correlation & "regression to the mean"
5. Logarithmic transformations
6. Discretizing continuous data
7. Building models for prediction
8. A quick note on time-series analyses

Dummy coding
========================================================

Using categorical predictors in linear models can be confusing.
This is because for each categorical input, we actually add the number of levels - 1 new parameters to the model.

x1 | x11 | x12 | x13
---|-----|-----|-----
1  | 0   | 0   | 0
2  | 1   | 0   | 0
3  | 0   | 1   | 0
4  | 0   | 0   | 1

This particular scheme, treatment coding, is the R default and only one we'll be discussing.

========================================================




<pre><code style="font-size:20pt">

Call:
lm(formula = count ~ spray, data = InsectSprays)

Residuals:
   Min     1Q Median     3Q    Max 
 -8.33  -1.96  -0.50   1.67   9.33 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   14.500      1.132   12.81  < 2e-16 ***
sprayB         0.833      1.601    0.52     0.60    
sprayC       -12.417      1.601   -7.76  7.3e-11 ***
sprayD        -9.583      1.601   -5.99  9.8e-08 ***
sprayE       -11.000      1.601   -6.87  2.8e-09 ***
sprayF         2.167      1.601    1.35     0.18    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3.92 on 66 degrees of freedom
Multiple R-squared:  0.724,	Adjusted R-squared:  0.704 
F-statistic: 34.7 on 5 and 66 DF,  p-value: <2e-16

</code></pre>

========================================================

<pre><code style="font-size:20pt">

Call:
lm(formula = count ~ spray, data = InsectSprays)

Residuals:
   Min     1Q Median     3Q    Max 
 -8.33  -1.96  -0.50   1.67   9.33 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)     2.08       1.13    1.84    0.070 .  
sprayA         12.42       1.60    7.76  7.3e-11 ***
sprayB         13.25       1.60    8.28  8.5e-12 ***
sprayD          2.83       1.60    1.77    0.081 .  
sprayE          1.42       1.60    0.88    0.379    
sprayF         14.58       1.60    9.11  2.8e-13 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3.92 on 66 degrees of freedom
Multiple R-squared:  0.724,	Adjusted R-squared:  0.704 
F-statistic: 34.7 on 5 and 66 DF,  p-value: <2e-16

</code></pre>

Insect graph
========================================================


```r
ggplot(InsectSprays, aes(spray, count)) + geom_boxplot() + theme_grey(base_size = 24)
```

<img src="Lecture05-figure/insect_graph.png" title="plot of chunk insect_graph" alt="plot of chunk insect_graph" style="display: block; margin: auto;" />


Linear transformation
========================================================

Linear transformations have no effect on model fit, but can improve interpretability of the model.

* add a constant
* multiply by a constant
* both!

This is because Any of these operations maintain the ratio between points.

Levels of measurement (Stevens, 1946)
========================================================

1. Nominal
2. Ordinal
3. Interval
4. Ratio

Everything we do relies heavily on the ratio scale, if not the interval.
Cliff (1994) and Dougherty & Thomas (2012) are good references for people working on ordinal things.

Common transformations
========================================================
left: 50%

mean centering
-----

* subtract mean(x) from each value of x
* intercept term now meaningful
* use when the units of your outcome are meaningful


***

z transformation
-----

$$
z_x = \frac{x_i - \bar{x}}{\sigma_x}
$$

* 0 point is now the mean of x
* unit change corresponds to a one standard deviation change

========================================================





```
lm(formula = kid_score ~ mom_hs * mom_iq, data = df)
              coef.est coef.se
(Intercept)   -11.48    13.76 
mom_hs         51.27    15.34 
mom_iq          0.97     0.15 
mom_hs:mom_iq  -0.48     0.16 
---
n = 434, k = 4
residual sd = 17.97, R-Squared = 0.23
```



```
lm(formula = kid_score ~ mom_hs * c.mom.iq, data = df)
                coef.est coef.se
(Intercept)     85.41     2.22  
mom_hs           2.84     2.43  
c.mom.iq        14.53     2.23  
mom_hs:c.mom.iq -7.26     2.43  
---
n = 434, k = 4
residual sd = 17.97, R-Squared = 0.23
```


Correlation and "regression to the mean"
========================================================

<img src="Lecture05-figure/reg_pca.png" title="plot of chunk reg_pca" alt="plot of chunk reg_pca" style="display: block; margin: auto;" />


Logarithmic function
========================================================

$$
log(a \cdot b) = log(a) + log(b)
$$

<img src="Lecture05-figure/log_func_plot.png" title="plot of chunk log_func_plot" alt="plot of chunk log_func_plot" style="display: block; margin: auto;" />


Logarithmic tranformations
========================================================

* Proportional change
* only works for all values > 0

<img src="Lecture05-figure/log_plot.png" title="plot of chunk log_plot" alt="plot of chunk log_plot" style="display: block; margin: auto;" />


========================================================


```r
ggplot(a, aes(Center, RT)) + geom_jitter() + geom_smooth(method = "lm", size = 2, se = FALSE) + scale_y_log10() + theme_bw(base_size = 24)
```

<img src="Lecture05-figure/log_plot2.png" title="plot of chunk log_plot2" alt="plot of chunk log_plot2" style="display: block; margin: auto;" />


Discretizing continuous data
========================================================

In general, don't do this unless you have an obvious, justifiable non-linearity or you need to visualize and interaction.





```r
juul$post <- factor(ifelse(juul$age > 25, 1, 0))
display(lm(igf1 ~ age * post, data = juul))
```

```
lm(formula = igf1 ~ age * post, data = juul)
            coef.est coef.se
(Intercept)  89.84    12.88 
age          21.19     0.95 
post1       242.18    39.92 
age:post1   -24.11     1.25 
---
n = 1013, k = 4
residual sd = 133.01, R-Squared = 0.40
```


Visual analogue
========================================================

<img src="Lecture05-figure/juul_plot.png" title="plot of chunk juul_plot" alt="plot of chunk juul_plot" style="display: block; margin: auto;" />


Building models for prediction
========================================================

Gelman's rules for including predictors:

* expected sign and "significant"
* unexpected sign and "significant"
* expected sign and not-significant
* remove a predictor IFF unexpected sign and n.s.

Why? Because Gelman like to discuss Type-M and Type-S errors rather than Type-I and Type-II errors.

Model comparison
========================================================

Similar to adjusted $R^2$, there are other ways to calculate penalized fit.

* Deviance
  * $-2(log(p(y|\hat{\theta_0})) - log(p(y|\hat{\theta_s})))$
* BIC
  * $n \cdot log(1 - R^2) + k\cdot log(n)$
* AIC
  * $n \cdot log(1 - R^2) + 2 \cdot k$
* Many, many others

A quick note on time-series analysis
========================================================

Times-series data can provide incredibly rich analyses. However:

* errors are generally not independent
* linearity is often violated
* in a linear modeling context, number of parameters can quickly become intractable

Consider a dataset with two years worth of data with measures taken every month.
Unless you expect a perfectly linear trend for your outcome with no change in predictors over time, you likely have to add a minimum of 24 new parameters.
This number immediately jumps to 48 if you investigate a single continuous interaction.
