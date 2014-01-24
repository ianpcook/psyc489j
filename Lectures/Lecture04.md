<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Linear regression: the basics
========================================================
author: Jeffrey Chrabaszcz
date: 7 January 2014
transition: none
width: 1024
height: 760




Data science
========================================================

<center>![data_science](https://lh3.googleusercontent.com/2fSoP_UUWS6okE7JDI-bWa6xQJ3-ylcd7WGrxGU8UQjNykD_2wLKOB-sgt_LYq2ZZB9xlBMj30il4rSmUyqEyqy4uoFy4iDTly09CnRrB2PbEcIDGZ3d)</center>

Outline
========================================================

1. Linear model
2. Multiple predictors
3. Interactions
4. Statistical inference
5. Graphical displays of data and fitted model
6. Assumptions and diagnostics
7. Prediction and validation

Linear model
========================================================

Recall that the linear model is:

$$
y_i = \beta_0 + \beta_1x_{1i} + \beta_2x_{2i} + ... + \epsilon_i\\
\hat{y} = \beta_0 + \beta_1x_{1i} + ... + \beta_kx_{ki}
$$

This means that, for some sample, our best prediction of each value of $y$ is:

* $\beta_0$, the intercept term; plus,
* the weighted value of each predictor, $x$, multiplied by some weight, $\beta$.
* $\epsilon$ also gives us an idea of how for off we expect to be with each prediction.

Quick aside
========================================================

The data for this next bit were originally formatted for Stata, (another statistical analysis software).
This is what it took to get those data into R.


```r
library(foreign)
df <- read.dta("data/kidiq.dta")
head(df)
```

```
  kid_score mom_hs mom_iq mom_work mom_age
1        65      1  121.1        4      27
2        98      1   89.4        4      25
3        85      1  115.4        4      27
4        83      1   99.4        3      25
5       115      1   92.7        4      27
6        98      0  107.9        1      18
```


Simple linear regression
========================================================
left: 50%

Let's say we want to predict a child's IQ based on whether or not the mother completed highschool.
We can look at this relationship graphically.


```r
df$mom_hs <- factor(df$mom_hs)
qplot(mom_hs, kid_score, data = df, geom = "jitter", position = position_jitter(width = .25))
```


***

<img src="Lecture04-figure/simple_regression2.png" title="plot of chunk simple_regression2" alt="plot of chunk simple_regression2" style="display: block; margin: auto;" />


Alternately, boxplots for a single categorical predictor
========================================================


```r
ggplot(df, aes(mom_hs, kid_score)) + geom_boxplot(width = .6) + geom_jitter(color = "firebrick", alpha = .6, position = position_jitter(width = .25)) + theme_bw(base_size = 24)
```

<img src="Lecture04-figure/iq_measles.png" title="plot of chunk iq_measles" alt="plot of chunk iq_measles" style="display: block; margin: auto;" />


t test
========================================================


```r
t.test(kid_score ~ mom_hs, data = df, var.equal = TRUE)
```

```

	Two Sample t-test

data:  kid_score by mom_hs
t = -5.07, df = 432, p-value = 5.957e-07
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -16.34  -7.21
sample estimates:
mean in group 0 mean in group 1 
           77.5            89.3 
```


Code you will use a million times
========================================================

This is the code we'll use to predict kid's IQ based on mom's HS completion.
We assigned our data to the data.frame named **df**, so that's also specified.


```r
my.lm <- lm(kid_score ~ mom_hs, data = df)
```


This is just here for reference, you'll use this code many times in the next 2 weeks.

Display a linear model
========================================================

$$
\widehat{kid\,score} = 78 + 12 \cdot mom\,hs
$$


```r
display(my.lm)
```

```
lm(formula = kid_score ~ mom_hs, data = df)
            coef.est coef.se
(Intercept) 77.55     2.06  
mom_hs1     11.77     2.32  
---
n = 434, k = 2
residual sd = 19.85, R-Squared = 0.06
```


Summary of a linear model
========================================================

<pre><code style="font-size:20pt">

Call:
lm(formula = kid_score ~ mom_hs, data = df)

Residuals:
   Min     1Q Median     3Q    Max 
-57.55 -13.32   2.68  14.68  58.45 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)    77.55       2.06   37.67   <2e-16
mom_hs1        11.77       2.32    5.07    6e-07

Residual standard error: 19.9 on 432 degrees of freedom
Multiple R-squared:  0.0561,	Adjusted R-squared:  0.0539 
F-statistic: 25.7 on 1 and 432 DF,  p-value: 5.96e-07

</code></pre>

Continuous predictor
========================================================

$$
\widehat{kid\,score} = 26 + 0.6 \cdot mom\,IQ
$$


```
lm(formula = kid_score ~ mom_iq, data = df)
            coef.est coef.se
(Intercept) 25.80     5.92  
mom_iq       0.61     0.06  
---
n = 434, k = 2
residual sd = 18.27, R-Squared = 0.20
```


Connecting marginal means
========================================================





```r
ggplot(a, aes(x, means)) + geom_point() + geom_line(group = 1) + geom_errorbar(aes(ymin = means - ses, ymax = means + ses), width = .2)
```

<img src="Lecture04-figure/t_test_plot.png" title="plot of chunk t_test_plot" alt="plot of chunk t_test_plot" style="display: block; margin: auto;" />


Connecting marginal means
========================================================

<img src="Lecture04-figure/marginal_means.png" title="plot of chunk marginal_means" alt="plot of chunk marginal_means" style="display: block; margin: auto;" />


Naming conventions
========================================================

I will not be using any of the following names in this class, but early statisticians did not have the benefit of hindsight.

Name                |   Outcome   | Predictor(s)
--------------------|-------------|-----------------------------------
t-test              | continuous  | one, dichotomous
one-way ANOVA       | continuous  | one, categorical
2x2 ANOVA           | continuous  | three! categorical
ANCOVA              | continuous  | one categorical and one continuous
correlation         | continuous  | one, continuous
multiple regression | continuous  | one or more, any kind
logistic regression | dichotomous | one or more, any kind
poisson regression  | categorical | one or more, any kind

Multiple predictors
========================================================

$$
\widehat{kid\,score} = 26 + 6 \cdot mom\,hs + 0.6 \cdot mom\,IQ
$$





```r
display(my.lm2)
```

```
lm(formula = kid_score ~ mom_hs + mom_iq, data = df)
            coef.est coef.se
(Intercept) 25.73     5.88  
mom_hs1      5.95     2.21  
mom_iq       0.56     0.06  
---
n = 434, k = 3
residual sd = 18.14, R-Squared = 0.21
```


Visualizing multiple predictors
========================================================

Heavily dependent on the nature of your predictors!

<img src="Lecture04-figure/mult_pred.png" title="plot of chunk mult_pred" alt="plot of chunk mult_pred" style="display: block; margin: auto;" />


Interactions
========================================================

$$
\begin{align}
    \widehat{kid\,score} = 11 &+ 51 \cdot mom\,hs \\
    & +\;1.1 \cdot mom\,IQ \\
    & -\;0.5 \cdot mom\,hs \cdot mom\,IQ
\end{align}
$$


```
lm(formula = kid_score ~ mom_hs * mom_iq, data = df)
               coef.est coef.se
(Intercept)    -11.48    13.76 
mom_hs1         51.27    15.34 
mom_iq           0.97     0.15 
mom_hs1:mom_iq  -0.48     0.16 
---
n = 434, k = 4
residual sd = 17.97, R-Squared = 0.23
```


Plotting interactions
========================================================

<img src="Lecture04-figure/int_viz.png" title="plot of chunk int_viz" alt="plot of chunk int_viz" style="display: block; margin: auto;" />


Plotting interactions, cont.
========================================================

<img src="Lecture04-figure/int_viz2.png" title="plot of chunk int_viz2" alt="plot of chunk int_viz2" style="display: block; margin: auto;" />


Interpretting interactions
========================================================

You could interpret the interaction as two regression equations:

$$
\begin{align}
  no &h.s.: \widehat{kid score} &= -11 + 51 \cdot 0 + 1.1 \cdot mom\,IQ\\
  & & -\;0.5 \cdot 0 \cdot mom\,IQ\\
  &h.s.: \widehat{kid score} &= -11 + 51 \cdot 1 + 1.1 \cdot mom\,IQ\\
  & & -\;0.5 \cdot 1 \cdot mom\,IQ
\end{align}
$$

Other things:
* interaction interpretability is improved by pre-processing (tomorrow)
* interactions help data models fit different subsets of data well (last few classes)

Statistical inference
========================================================

Units
---

People or schools, not pounds or inches, (the "other" units matter, though!)

Outcome and predictors
---

The thing we're predicting.
We don't talk about independent and dependent variables, those words are already used for other things.
Same goes for predictors instead of independent variables.

Inputs
========================================================

That last regression has:

* four predictors
  * intercept
  * mom HS
  * mom IQ
  * mom HS $\cdot$ mom IQ
* two inputs
  * mom's IQ
  * mom's high school status

Residuals
========================================================

Residuals represent the uncertainty left after removing predicted variance.

$$
r_i = y_i - \hat{y}_i
$$

<img src="Lecture04-figure/resid_graph.png" title="plot of chunk resid_graph" alt="plot of chunk resid_graph" style="display: block; margin: auto;" />


Two kinds of uncertainty
========================================================

coefficient SE
-----

This expresses uncertainty for each coefficient. This is independent of residual variability!

residual variance
-----

* remaining variance is uncertainty in your outcome
* original variance - error variance is your explained error as a proportion
* use this to know how far off our estimates should be
* Adjusted $R^2$ is generally the same as explained error with a penalty for the number of parameters

Prediction and validation
========================================================
left: 50%

**"prediction" standard errors**





```r
predict(my.lm1, x.new, interval="confidence", level=0.95)
```

```
   fit  lwr  upr
1 86.8 85.1 88.5
```

```r
predict(my.lm1, x.new, interval="prediction", level=0.95)
```

```
   fit  lwr upr
1 86.8 50.9 123
```


***

**split-half cross-validation**

* Fit model to a random half of the dataset, check fit to remaining half.
* related to bootstrapping and simulation.

**external validation**

Fitting the same model to a new set of data.

**bootstrap/simulation**

We'll be covering this Friday.

Assumptions and diagnostics
========================================================

In order of importance:

1. Validity
2. Additivity & Linearity
3. Independence of errors
4. Equal variance of errors
5. Normality of errors
