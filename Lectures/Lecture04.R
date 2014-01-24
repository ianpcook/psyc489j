
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(arm)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----iq_data-------------------------------------------------------------
library(foreign)
df <- read.dta("data/kidiq.dta")
head(df)


## ----simple_regression,eval=FALSE----------------------------------------
## df$mom_hs <- factor(df$mom_hs)
## qplot(mom_hs, kid_score, data = df, geom = "jitter", position = position_jitter(width = .25))


## ----simple_regression2,echo=FALSE---------------------------------------
df$mom_hs <- factor(df$mom_hs)
qplot(mom_hs, kid_score, data = df, geom = "jitter", position = position_jitter(width = .25)) + theme_bw(base_size = 24)


## ----iq_measles,fig.height=6,fig.width=10--------------------------------
ggplot(df, aes(mom_hs, kid_score)) + geom_boxplot(width = .6) + geom_jitter(color = "firebrick", alpha = .6, position = position_jitter(width = .25)) + theme_bw(base_size = 24)


## ----t_test--------------------------------------------------------------
t.test(kid_score ~ mom_hs, data = df, var.equal = TRUE)


## ----first_lm------------------------------------------------------------
my.lm <- lm(kid_score ~ mom_hs, data = df)


## ----display_lm----------------------------------------------------------
display(my.lm)


## ----summary_lm,echo=FALSE,results="asis"--------------------------------
print(summary(my.lm), signif.stars = FALSE, call = FALSE)


## ----continuous_lm,echo=FALSE--------------------------------------------
display(my.lm1 <- lm(kid_score ~ mom_iq, data = df))


## ----t_test_slope_data,echo=FALSE----------------------------------------
a <- data.frame(x = 0:1, means = c(coef(my.lm)[1], sum(coef(my.lm))), ses = summary(my.lm)$coef[,2])


## ----t_test_plot---------------------------------------------------------
ggplot(a, aes(x, means)) + geom_point() + geom_line(group = 1) + geom_errorbar(aes(ymin = means - ses, ymax = means + ses), width = .2)


## ----marginal_means,echo=FALSE,fig.height=9,fig.width=10-----------------
qplot(mom_iq, kid_score, data = df) + geom_smooth(se = FALSE, method = "lm", size = 1.5) + theme_bw(base_size = 24)


## ----multiple_predictors,echo=FALSE--------------------------------------
my.lm2 <- lm(kid_score ~ mom_hs + mom_iq, data = df)


## ------------------------------------------------------------------------
display(my.lm2)


## ----mult_pred,echo=FALSE,fig.height=8,fig.width=11----------------------
df$intercept <- ifelse(unclass(df$mom_hs) == 1, coef(my.lm2)[1], sum(coef(my.lm2)[1:2]))
df$slope <- coef(my.lm2)[3]
qplot(mom_iq, kid_score, data = df, color = mom_hs, alpha = .6) + geom_abline(aes(intercept = intercept, slope = slope, color = mom_hs)) + scale_color_manual(values = c("firebrick", "steelblue")) + theme_bw(base_size = 24) + guides(alpha = FALSE)


## ----inter_mod,echo=FALSE------------------------------------------------
display(my.lm3 <- lm(kid_score ~ mom_hs * mom_iq, data = df))


## ----int_viz,echo=FALSE,fig.height=9,fig.width=10------------------------
p <- ggplot(df, aes(x = mom_iq, y = kid_score, color = mom_hs)) + geom_point(alpha = .5) + scale_color_manual(values = c("firebrick", "steelblue")) + theme_bw(base_size = 24)
p + geom_smooth(se = FALSE, method = "lm")


## ----int_viz2,echo=FALSE,fig.height=9,fig.width=10-----------------------
p + geom_smooth(se = FALSE, method = "lm", fullrange = TRUE) + xlim(c(0, 140))


## ----resid_graph,echo=FALSE,fig.height=6,fig.width=9---------------------
x <- seq(-80, 80, by = .01)
my.lm4 <- lm(kid_score ~ 1, data = df)
a <- data.frame(x = rep(x, 5), density = c(dnorm(x, sd = sum(df$kid_score^2)/length(df$kid_score - 1)), dnorm(x, mean = 0, sd = sd(residuals(my.lm4))), dnorm(x, mean = 0, sd = sd(residuals(my.lm))), dnorm(x, mean = 0, sd = sd(residuals(my.lm2))), dnorm(x, mean = 0, sd = sd(residuals(my.lm3)))), group = factor(rep(0:4, each = length(x)), labels = c("null", "int", "hs", "iq+hs", "iq*hs")))
qplot(x, density, data = a, geom = "line", color = group, alpha = .5) + theme_bw(base_size = 24) + guides(alpha = FALSE)


## ----predict,echo=FALSE--------------------------------------------------
x.new <- data.frame(mom_hs=1, mom_iq=100)


## ----predict_code--------------------------------------------------------
predict(my.lm1, x.new, interval="confidence", level=0.95)
predict(my.lm1, x.new, interval="prediction", level=0.95)


