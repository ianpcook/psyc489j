
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----runif_block---------------------------------------------------------
set.seed(42)
runif(10)


## ----plotting_runif,fig.height=6,fig.width=12----------------------------
set.seed(42)
a <- runif(10000)
qplot(a, binwidth = .01) + theme_bw(base_size = 24) + xlim(c(-.5, 1.5)) + ylim(c(0, 200))


## ----ar_code-------------------------------------------------------------
acceptReject <- function(lb, ub, fx) {
  x <- runif(1) * (ub - lb) + lb
  y <- runif(1)
  out <- ifelse(y > fx(x), NA, y)
  return(c(x, out))
}


## ------------------------------------------------------------------------
n <- 10000
loop.df <- data.frame(x = rep(NA, n), y = rep(NA, n))
for (i in 1:n) {
  temp <- acceptReject(-5, 5, dnorm)
  loop.df$x[i] <- temp[1]
  loop.df$y[i] <- temp[2]
}


## ------------------------------------------------------------------------
b <- replicate(10000, acceptReject(-5, 5, dnorm))
df <- as.data.frame(t(b))
names(df) <- c("x", "y")


## ----ar_results,fig.height=8,fig.width=10--------------------------------
qplot(x, y, data = df) + theme_bw(base_size = 24)


## ----sample_ex-----------------------------------------------------------
sample(c("heads", "tails"), 10, replace = TRUE)


## ------------------------------------------------------------------------
data(sleep)
permTest <- function(df) {
  df$x <- sample(df$x, length(df$x))
  return(t.test(y ~ x, data = df)$statistic)
}

n <- 1000
t.real <- t.test(sleep$extra ~ sleep$group)$statistic
ts <- replicate(n, permTest(data.frame(x = sleep$group, y = sleep$extra)))
sum(abs(ts) > abs(t.real))/n


## ----cross_val_code------------------------------------------------------
data(diamonds)
select.data <- sample(1:nrow(diamonds), nrow(diamonds)/2)
my.lm <- lm(price ~ carat * clarity * x * y * z, data = diamonds[select.data,])
cross.val <- predict(my.lm, diamonds[-select.data,], type = "response")


## ----cross_val_output----------------------------------------------------
c(sd(diamonds$price[select.data]), sd(residuals(my.lm)))
c(sd(diamonds$price[-select.data]), sd(diamonds$price[-select.data] - cross.val))


## ----boot_setup----------------------------------------------------------
bootS <- function(model.formula, df) {
  new.df <- df[sample(nrow(df), nrow(df), replace = TRUE),]
  mod <- lm(model.formula, data = new.df)
  return(coef(mod))
}

df <- read.csv("students/labs/ravensdata.csv")
b <- t(replicate(1000, bootS(ravens ~ shape * nfc, df)))


## ----boot_out------------------------------------------------------------
apply(b, 2, FUN = quantile, probs = c(.025, .975))


## ----boot_graph,echo=FALSE,fig.height=6,fig.width=16---------------------
library(reshape2)
qplot(value, data = melt(as.data.frame(b))) + facet_grid(~variable, scale = "free_x") + geom_vline(xintercept = 0, color = "firebrick")+ theme_bw(base_size = 24)


## ----sim_block-----------------------------------------------------------
library(arm)
my.lm <- lm(ravens ~ nfc, data = df)
my.sim <- sim(my.lm, n.sims = 50)
str(my.sim)


## ----sim_graph,fig.height=6,fig.width=10---------------------------------
ggplot(df, aes(nfc, ravens)) + geom_abline(data = as.data.frame(my.sim@coef), aes(intercept = V1, slope = V2), color = "grey") + geom_point() + theme_bw(base_size = 24)


