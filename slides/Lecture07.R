
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


## ----,include=FALSE------------------------------------------------------
library(rstan)

sdat <- list(
  y = unclass(juul.girl$menarche) - 1,
  x = juul.girl$age,
  N = nrow(juul.girl)
)

smod <- "
  data {
    int<lower=1> N;
    int<lower=0> y[N];
    vector[N] x;
  }
  parameters {
    real alpha;
    real beta;
  }
  transformed parameters {
    vector[N] yhat;
    yhat <- alpha + x * beta;
  }
  model {
    alpha ~ normal(0,10);
    beta ~ normal(0,10);
    y ~ bernoulli_logit(yhat);
  }
"

fit2 <- stan(model_code = smod, data = sdat, refresh = -1)


## ------------------------------------------------------------------------
# print(fit2, pars = c("alpha", "beta", "lp__"), probs = c(.025, .975))


## ----juul_graph----------------------------------------------------------
qplot(age, menarche, data = juul.girl) + theme_bw(base_size = 24)


## ----juul_graph2,echo=FALSE,fig.height=9,fig.width=9---------------------
qplot(age, menarche, data = juul.girl, geom = "jitter", position = position_jitter(width = 0, height = .1)) + geom_vline(xintercept = 20.01/1.52, size = 1.5, color = "firebrick") + theme_bw(base_size = 24)


## ----interpretation_examples---------------------------------------------
invlogit(-20 + 13 * 1.52)
exp(1.52)


## ----,echo=FALSE---------------------------------------------------------
library(ggplot2)
library(gdata)
library(arm)
library(dplyr)
library(tidyr)
library(xtable)
library(gridExtra)

# load data and clean
dat <- read.xls("~/Dropbox/consulting/msi/class_lowgrade_nov2014/qABCDs_PivotalTrial.xlsx")
old.names <- names(dat)
names(dat) <- tolower(names(dat))

# new variables to define classifier output based on email
dat$classify <- as.factor(ifelse(dat$classifier.score >= 0, "pos", "neg"))
dat$mm <- as.factor(ifelse(dat$final.dx.cat == "MM", "MM", "non-MM"))
dat$mm <- relevel(dat$mm, ref = "non-MM")
dat$combined <- as.factor(ifelse(dat$final.dx.cat == "OTHR", "other", "combined"))
dat$combined <- relevel(dat$combined, ref = "other")
dat$z <- (dat$classifier.score - 4) * ifelse(dat$classifier.score > 4, 1, 0)
dat$mm.raw <- unclass(dat$mm) - 1
dat$combined.raw <- unclass(dat$combined) - 1

# replicate earlier analyses
# table(dat$final.dx.cat)
# with(dat, xtabs(~ classify + final.dx.cat))

rep.plot1 <- dat %>%
  select(classifier.score, mm, combined) %>%
  gather(comparison, group, -classifier.score) %>%
  ggplot(aes(classifier.score, color = group)) +
    geom_density() +
    facet_wrap(~comparison) +
    scale_color_manual(values = rep(c("black", "blue"), each = 2)) +
    theme_classic()

rep.mod1 <- glm(mm ~ classifier.score, data = dat, family = binomial)

rep.mod2 <- glm(mm ~ classifier.score + z, data = dat, family = binomial)

rep.mod3 <- glm(combined ~ classifier.score, data = dat, family = binomial)

rep.mod4 <- glm(combined ~ classifier.score + z, data = dat, family = binomial)

pred.dat4 <- data.frame(classifier.score = -5:9)
pred.dat4$z <- (pred.dat4$classifier.score - 4) * ifelse(pred.dat4$classifier.score > 4, 1, 0)

pred.dat4 <- cbind(pred.dat4, as.data.frame(predict(rep.mod4, pred.dat4, se.fit = TRUE, type = "response")))
pred.dat4$se.fit <- pred.dat4$se.fit * 1.96

rep.plot4 <- dat %>%
  ggplot(aes(classifier.score, combined.raw)) +
    geom_jitter(position = position_jitter(height = .005, width = 0), alpha = .25) +
    geom_smooth(se = FALSE, method = "loess", color = "firebrick") +
    geom_point(data = pred.dat4, aes(x = classifier.score, y = fit), color = "steelblue") +
    geom_line(data = pred.dat4, aes(x = classifier.score, y = fit, group = 1), color = "steelblue") +
    geom_errorbar(data = pred.dat4, aes(x = classifier.score, y = fit, ymin = fit - se.fit, ymax = fit + se.fit), color = "steelblue", width = .2) +
    theme_classic() +
    xlab("Score") +
    ylab("P(MM|Score)")


## ----,echo=FALSE,results="hide",fig.width=10,fig.height=8----------------
dat$add.ndlg <- as.character(dat$final.dx.cat)
dat$add.ndlg[dat$final.dx...revised.dgk.ja.mr.ayt == "NO-NDLG"] <- "NDLG"
dat$add.ndlg <- as.factor(dat$add.ndlg)

dat$ndlg <- as.factor(ifelse(dat$add.ndlg == "OTHR", "other", "combined"))
dat$ndlg <- relevel(dat$ndlg, ref = "other")
dat$ndlg.raw <- unclass(dat$ndlg) - 1

# creating report output
ndlg.tab <- table(dat$add.ndlg)

ndlg.dens <- dat %>%
  select(classifier.score, ndlg) %>%
  ggplot(aes(classifier.score, color = ndlg)) +
    geom_density() +
    scale_color_manual(values = rep(c("black", "blue"))) +
    theme_classic() +
    xlab("Classifier Score") +
    ylab("Density")

mod1 <- glm(ndlg ~ classifier.score, data = dat, family = binomial)

mod2 <- glm(ndlg ~ classifier.score + z, data = dat, family = binomial)

pred1 <- data.frame(classifier.score = -5:9)
pred1 <- cbind(pred1, predict(mod1, pred1, type = "link", se.fit = TRUE))
pred1$lwr <- pred1$fit - 1.96 * pred1$se.fit
pred1$upr <- pred1$fit + 1.96 * pred1$se.fit
pred1$fit <- mod1$family$linkinv(pred1$fit)
pred1$lwr <- mod1$family$linkinv(pred1$lwr)
pred1$upr <- mod1$family$linkinv(pred1$upr)

ndlg.plot1 <- dat %>%
  ggplot(aes(classifier.score, ndlg.raw)) +
    geom_jitter(position = position_jitter(height = .005, width = 0), alpha = .25) +
    geom_smooth(se = FALSE, method = "loess", color = "firebrick") +
    geom_point(data = pred1, aes(x = classifier.score, y = fit), color = "steelblue") +
    geom_line(data = pred1, aes(x = classifier.score, y = fit, group = 1), color = "steelblue") +
    geom_errorbar(data = pred1, aes(x = classifier.score, y = fit, ymin = lwr, ymax = upr), color = "steelblue", width = .2) +
    theme_classic() +
    xlab("Score") +
    ylab("P(MM/HGDN/AMH/NDLG|Score)")

pred2 <- data.frame(classifier.score = -5:9)
pred2$z <- (pred2$classifier.score - 4) * ifelse(pred2$classifier.score > 4, 1, 0)
pred2 <- cbind(pred2, predict(mod2, pred2, type = "link", se.fit = TRUE))
pred2$lwr <- pred2$fit - 1.96 * pred2$se.fit
pred2$upr <- pred2$fit + 1.96 * pred2$se.fit
pred2$fit <- mod2$family$linkinv(pred2$fit)
pred2$lwr <- mod2$family$linkinv(pred2$lwr)
pred2$upr <- mod2$family$linkinv(pred2$upr)

ndlg.plot2 <- dat %>%
  ggplot(aes(classifier.score, ndlg.raw)) +
    geom_jitter(position = position_jitter(height = .005, width = 0), alpha = .25) +
    geom_smooth(se = FALSE, method = "loess", color = "firebrick") +
    geom_point(data = pred2, aes(x = classifier.score, y = fit), color = "steelblue") +
    geom_line(data = pred2, aes(x = classifier.score, y = fit, group = 1), color = "steelblue") +
    geom_errorbar(data = pred2, aes(x = classifier.score, y = fit, ymin = lwr, ymax = upr), color = "steelblue", width = .2) +
    theme_classic() +
    xlab("Score") +
    ylab("P(MM/HGDN/AMH/NDLG|Score)")

rep.plot4 + theme_classic(base_size = 24)


## ----,echo=FALSE---------------------------------------------------------
print(fit2, pars = c("alpha", "beta", "lp__"), probs = c(.025, .975))


