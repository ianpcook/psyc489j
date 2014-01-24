<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Simple Bayesian methods
========================================================
author: Jeffrey Chrabaszcz
date: 10 January 2014
transition: none
width: 1024
height: 760




Outline
========================================================

1. Statistical philosophy
2. Shannon's Information theory
3. Bayesian inference
4. Prior
5. Likelihood
6. Posterior
7. Data!
8. Examples

Statistical philosophy
========================================================
left: 50%

Frequentist
---

* Pros
  * intuitive to run
  * influential
  * objective
* Cons
  * limited application
  * abused
  * strange to interpret

***

Bayesian
---

* Pros
  * flexible
  * easy interpretation
  * anwers the right question!
* Cons
  * complex computation
  * slow adoption
  * subjective


Shannon's Information theory
========================================================

We can think of gaining knowledge as reducing uncertainty.
Consider the following examples:

* learning the gender of a child
* discovering the outcome of a coin flip
* measure the average test score in a school

Observing the outcome in each of these cases can be considered a decrease in uncertainty.

Bayesian inference
========================================================

Bayesian inference in general can be thought of as isomorphic to information theory.
We generall consider:

* what we already know (priors)
* what we learn from our current observation (likelihood)
* how much our beliefs should change as a result of our observation (posterior)

Prior
========================================================

This should represent everything we know about our problem before we start.

* scale boundaries
* previous research
* related observations

Often a range or priors are appropriate.
Rarely is a uniform prior appropriate.

Likelihood
========================================================

We maximize likelihood by maximizing the objective function.

$$
\hat{\ell}(\theta|x) = \frac{1}{n}\sum_{i = 1}^n \ln f(x_i|\theta)
$$

The mean of the object function yields maximized likelihood.
This is what we've already been doing!

Posterior
========================================================

The hard part about Bayesian statistics is combining the prior and likelihood functions to determine the posterior distribution.
Done correctly, this yield an intuitive interpretation: what is the probability of a specific parameter value.

<img src="Lecture08-figure/pre_bayes.png" title="plot of chunk pre_bayes" alt="plot of chunk pre_bayes" style="display: block; margin: auto;" />


Data!
========================================================

How can you have a probability of something happen if you know it's happened?

$$
P(D|H1) + P(D|\neg H1)
$$

$$
\sum_{i=1}^{k} P(D|H_i)
$$

This is only letting us interpret things in direct probabilities rather than unnormalized ratios.

Bayesian cancer updating
========================================================

* 1% of women have breast cancer
* 80% of mammograms detect breast cancer given that it is present
* 90.4% of mammograms correctly return a negative result given that breast cancer is not present

Question
---

How should we react to a negative test?

========================================================

We know that the probability of a union is just the product of both probabilities, so:

.        | C        | ~C        
---------|----------|-----------
Positive | .01 * .8 | .99 * .096
Negative | .01 * .2 | .99 * .904

So we can solve this:

$$
P(C|Pos) = \frac{P(C \cap Pos)}{P(Pos)} = \frac{.01 \cdot .8}{(.01 \cdot .8 + .99 \cdot .096)}
$$


```r
.01 * .8/(.01 * .8 + .99 * .096)
```

```
[1] 0.0776
```


Poisson likelihood function
========================================================

Say you wait tables in a restaurant and want to calculate your income ahead of time.
You have a pretty good idea of tip rates and things, but you're not sure how many customers you serve per hour of work and want a single estimate of that so you can simplify your income calculation.
You have a strong suspicion that you serve 5 tables per hour, it certainly feels like it, but it could be as low as 3 or as high as 6.

You then work a 4 hour shift and observe the following rates:


```
[1] 1 1 2 5
```


Do we know anything new about our rate of customer service?

Formalize priors
========================================================

We first list our prior beliefs.
As long as we get proper ratios, we can then divide by the sum over all beliefs to get probabilities.

Rate | Probability
-----|------------
3    | .2         
4    | .2         
5    | .4         
6    | .2         


```r
priors <- c(.2, .2, .4, .2)
```


Likelihood calculation
========================================================

We can easily calculate the likelihood for each hypothesis:


```r
rates <- 3:6
lik <- sapply(rates, function(x) prod(dpois(obs, x)))
lik
```

```
[1] 5.04e-04 1.23e-04 1.68e-05 1.59e-06
```


Ignoring P(data)
========================================================

We can stop here and get proportional odds, if we want.


```r
priors * lik
```

```
[1] 0.1247 0.0899 0.0654 0.0470
```


But we can't read those as probabilities, which would be more convenient.

P(Data)
========================================================

$$
P(D) = \sum_{i=1}^{k} P(D|H_i)
$$


```r
pd <- sum(lik)
lik * priors/pd
```

```
[1] 0.0763 0.0550 0.0400 0.0287
```


Notice that the last line strongly resembles Bayes theorem.

$$
P(A|B) = \frac{P(B|A) \cdot P(A)}{P(B)}
$$
