
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----logistic_plot,echo=FALSE,fig.height=7,fig.width=10------------------
x <- seq(-10, 10, by = .001)
y <- 1/(1 + exp(-x))
qplot(x, y, geom = "line") + theme_bw(base_size = 24)


## ----juul_example,echo=FALSE---------------------------------------------
library(ISwR)
library(arm)
data(juul)
juul$menarche <- factor(juul$menarche)
juul$tanner <- factor(juul$tanner)
juul.girl <- juul[juul$age > 8 & juul$age < 20 & complete.cases(juul$menarche),]
display(fit <- glm(menarche ~ age, data = juul.girl, family = binomial))


## ----age_calc------------------------------------------------------------
20.01/1.52


## ----juul_graph----------------------------------------------------------
qplot(age, menarche, data = juul.girl) + theme_bw(base_size = 24)


## ----juul_graph2,echo=FALSE,fig.height=9,fig.width=9---------------------
qplot(age, menarche, data = juul.girl, geom = "jitter", position = position_jitter(.1)) + geom_vline(xintercept = 20.01/1.52, size = 1.5, color = "firebrick") + theme_bw(base_size = 24)


## ----interpretation_examples---------------------------------------------
invlogit(1.52)
exp(1.52)


