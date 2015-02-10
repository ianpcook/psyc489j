
## ----setup,include=FALSE,echo=FALSE--------------------------------------
require(knitr)
require(ggplot2)
library(arm)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----intercept_slope_plot,echo=FALSE,fig.height=4,fig.width=12-----------
df <- data.frame(intercept = c(1, 1, 1, 1, 1, 1.5, 2, .5, 1, 1.5, 2, .5), slope = c(1, 2, .5, 1.5, 1, 1, 1, 1, 1, 2, .5, 1.5), subject = factor(rep(1:4, times = 3)), example = factor(rep(c("varying slopes", "varying intercepts", "varying intercepts and slopes"), each = 4), ordered = TRUE))
df.points <- data.frame(x = rep(-1:2, times = 3), y = rep(0:3, times = 3), example = factor(rep(c("varying slopes", "varying intercepts", "varying intercepts and slopes"), each = 4), ordered = TRUE))
df$mean.intercept <- rep(c(1, 1.25, 1.25), each = 4)
df$mean.slope <- rep(c(1.25, 1, 1.25), each = 4)
p <- ggplot(df.points, aes(x = x, y = y)) + geom_point(size = 0) + facet_wrap(~example)
p + geom_abline(data = df, aes(intercept = intercept, slope = slope), color = "black", size = 1.5, alpha = 1/2) + geom_abline(data = df, aes(intercept = mean.intercept, slope = mean.slope), color = "firebrick", size = 2) + facet_wrap(~example) + theme_bw(base_size = 24)


## ----,eval=FALSE---------------------------------------------------------
## model {
##   y[i] ~ normal(inprod(x[i], b), sigma);
##   b ~ normal(0, 1);
## }


## ----pool_comp-----------------------------------------------------------
data(sleep)
pool <- lm(extra ~ 1, data = sleep)
no.pool <- lm(extra ~ ID, data = sleep)
library(lme4)
part.pool <- lmer(extra ~ 1 + (1|ID), data = sleep)


## ------------------------------------------------------------------------
display(pool)


## ------------------------------------------------------------------------
display(no.pool)


## ------------------------------------------------------------------------
display(part.pool)


## ----pool_boxes,echo=FALSE,fig.height=4,fig.width=10---------------------
df <- data.frame(x = factor(c(rep(1, length(sleep$extra)), sleep$ID)), y = rep(sleep$extra, times = 2), pool = factor(rep(c("full", "none"), each = length(sleep$extra))))
ggplot(df, aes(x, y)) + geom_boxplot() + facet_wrap(~pool, drop = TRUE, scales = "free_x") + theme_bw(base_size = 24)


## ----model_coefs,echo=FALSE,fig.height=4,fig.width=10--------------------
df <- data.frame(x = factor(c(1, rep(unique(sleep$ID), times = 2))), y = c(coef(pool), c(coef(no.pool)[1], coef(no.pool)[-1] + coef(no.pool)[1]), coef(part.pool)$ID[,1]), pool = factor(rep(c("full", "none", "partial"), c(1, 10, 10))), se = c(summary(pool)$coef[,2], coef(summary(no.pool))[,2], se.ranef(part.pool)$ID))
ggplot(df, aes(x, y, ymin = y - 2 * se, ymax = y + 2 * se)) + geom_point() + geom_errorbar(width = 0) + facet_wrap(~pool, drop = TRUE, scales = "free_x") + theme_bw(base_size = 24)


## ----pred_setup,echo=FALSE-----------------------------------------------
pool <- lm(extra ~ group, data = sleep)
no.pool <- lm(extra ~ group + ID, data = sleep)
part.pool <- lmer(extra ~ group + (1|ID), data = sleep)


## ------------------------------------------------------------------------
display(pool)


## ------------------------------------------------------------------------
display(no.pool)


## ------------------------------------------------------------------------
display(part.pool)


## ------------------------------------------------------------------------
ggplot(sleep, aes(group, extra)) + geom_boxplot(group = 1) + geom_jitter(size = 5, position = position_jitter(.25), aes(color = ID)) + theme_bw(base_size = 24)


## ----,eval=FALSE---------------------------------------------------------
## fit <- lmer(extra ~ group + (1 + group|ID), data = sleep)


