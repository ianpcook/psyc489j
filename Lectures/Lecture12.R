
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----viz_laplace,echo=FALSE,fig.height=4,fig.width=10--------------------
library(VGAM)
x <- seq(-3, 3, by = .01)
y <- dlaplace(x)
qplot(x, y, geom = "line", group = 1) + theme_bw(base_size = 24)


## ----enet_ex,eval=FALSE--------------------------------------------------
## mu_b ~ double_exponential(0.0, 1.0);
## b ~ normal(mu_b,1.0);


## ----mr_mod,eval=FALSE---------------------------------------------------
## parameters {
##   real b0;
##   vector[P] b;
##   real mu_b;
##   real<lower=0> tau;
##   real<lower=0> nu;
## }
## transformed parameters {
##   real<lower=0> sigma;
##   sigma <- pow(tau, -0.5);
## }
## model {
##   b0 ~ normal(0.0, 1.0);
##   mu_b ~ double_exponential(0.0, 1.0);
##   b ~ normal(mu_b,1.0);
##   nu ~ exponential(df);
##   tau ~ exponential(1);
##   for (i in 1:N)
##     y[i] ~ student_t(nu + 1, b0 + dot_product(x[i], b), sigma);
## }


## ----viz_data,echo=FALSE,message=FALSE,warning=FALSE,fig.height=5,fig.width=11----
library(rstan)
library(reshape2)
load("~/Dropbox/Data/dli/.RData")
summary(b.data[1:3])
qplot(value, data = melt(b.data[1:3])) + facet_wrap(~variable, scale = "free_x") + theme_bw(base_size = 24)


## ----logit_code----------------------------------------------------------
logit_code <- '
data {
  int<lower=0> N;
  int<lower=1> P;
  int<lower=2> K;
  int<lower=1,upper=K> y[N];
  row_vector[P] x[N];
}
parameters {
  vector[P] b;
  real mu_b;
  ordered[K-1] c;
}
model {
  mu_b ~ normal(0.0, 1.0);
  b ~ normal(mu_b, K/4.0);
  for (n in 1:N)
    y[n] ~ ordered_logistic(x[n] * b, c);
}
'


## ----data_fit,results='hide',warning=FALSE,message=FALSE-----------------
s.data <- b.data
s.data$ravens <- s.data$ravens + 1
s.data[,-1] <- as.data.frame(scale(s.data[,-1]))
s.data$shape.by.nfc <- s.data$nfc * s.data$shape

logit_dat <- list(y = s.data[,1],
                 x = s.data[,-1],
                 N = nrow(s.data),
                 P = ncol(s.data) - 1,
                 K = length(unique(s.data[,1]))
)

l.posterior <- stan(model_code = logit_code, data = logit_dat, iter = 1000, chains = 3)


## ----cater_plot,echo=FALSE,fig.width=12,fig.height=4.5-------------------
library(plyr)
a <- as.matrix(l.posterior)
b <- melt(as.data.frame(a[,1:4]))
b$group <- "betas"
d <- melt(as.data.frame(a[,5:21]))
d$group <- "cuts"
a <- rbind(b, d)
a$group <- factor(a$group)
df <- ddply(a, .(variable, group), summarize, lower = quantile(value, probs = .025), upper = quantile(value, probs = .975), mid = quantile(value, probs = .5))
qplot(variable, mid, data = df[as.character(df$group) == "betas",]) + geom_errorbar(aes(ymin = lower, ymax = upper), width = 0) + theme_bw(base_size = 24)
qplot(variable, mid, data = df[as.character(df$group) == "cuts",]) + geom_errorbar(aes(ymin = lower, ymax = upper), width = 0) + theme_bw(base_size = 24)


## ----conv_plot_b,echo=FALSE,message=FALSE,warning=FALSE,fig.height=9,fig.width=14----
library(gdata)
a <- as.array(l.posterior)
a <- melt(a)
ggplot(drop.levels(subset(a, parameters %in% c("b[1]", "b[2]", "b[3]", "mu_b"))), aes(x = iterations, y = value, color = chains, group = chains)) + geom_line(alpha = .5) + facet_grid(parameters~., scale = "free_y") + theme_bw(base_size = 24)


## ----conv_plot_c,echo=FALSE,message=FALSE,warning=FALSE,fig.height=9,fig.width=14----
ggplot(drop.levels(subset(a, parameters %in% c("c[1]", "c[2]", "c[3]", "c[4]", "c[5]", "c[6]", "c[7]", "c[8]", "c[9]", "c[10]", "c[11]", "c[12]", "c[13]", "c[14]", "c[15]", "c[16]", "c[17]"))), aes(x = iterations, y = value, color = chains, group = chains)) + geom_line(alpha = .5) + facet_wrap(~parameters, scale = "free_y") + theme_bw(base_size = 24)


