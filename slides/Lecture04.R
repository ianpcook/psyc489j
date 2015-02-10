
## ----setup, include=FALSE, echo=FALSE------------------------------------
require(knitr)
require(ggplot2)
opts_chunk$set(include=TRUE,cache=TRUE,fig.align='center')
options(digits = 3)


## ----insect_setup,echo=FALSE---------------------------------------------
data(InsectSprays)
lm1 <- lm(count ~ spray, data = InsectSprays)
InsectSprays$spray <- relevel(InsectSprays$spray, ref = "C")
lm2 <- lm(count ~ spray, data = InsectSprays)


## ----model_1,echo=FALSE,results='asis'-----------------------------------
summary(lm1)


## ----model_2,echo=FALSE,results='asis'-----------------------------------
summary(lm2)


## ----insect_graph--------------------------------------------------------
ggplot(InsectSprays, aes(spray, count)) + geom_boxplot() + theme_grey(base_size = 24)


## ----load_data_1 ,echo=FALSE---------------------------------------------
library(foreign)
library(arm)
df <- read.dta("data/kidiq.dta")
df$c.mom.iq <- scale(df$mom_iq)


## ----no_center,echo=FALSE------------------------------------------------
display(my.lm <- lm(kid_score ~ mom_hs * mom_iq, data = df))


## ----center,echo=FALSE---------------------------------------------------
display(my.lm <- lm(kid_score ~ mom_hs * c.mom.iq, data = df))


## ----reg_pca,echo=FALSE,fig.height=9,fig.width=18------------------------
df <- data.frame(x = rnorm(1000))
df$y <- as.vector(scale(df$x + rnorm(1000)))
lm1 <- lm(y ~ x, data = df)
df.2 <- data.frame(int = c(coef(lm1)[1], 0), slo = c(coef(lm1)[2], 1), met = c("reg", "pca"))
ggplot(df, aes(x,y)) + geom_point() + geom_abline(data = df.2, aes(intercept = int, slope = slo), color = "firebrick", size = 1.5) + facet_wrap(~met) + theme_grey(base_size = 24)


## ----log_func_plot,echo=FALSE--------------------------------------------
df <- data.frame(x = seq(.001, 20, by = .001))
df$y <- log(df$x)
qplot(x, y, data = df, geom = "line", group = 1) + ylab("log(x)") + theme_bw(base_size = 24) + ylim(c(-7, 4))


## ----log_plot,echo=FALSE,fig.width=12------------------------------------
load("~/Dropbox/DAM lab/Math/Tasks/Data/mathreboot4/.RData")
library(gdata)
a <- drop.levels(a[!is.na(a$RT) & !is.na(a$Gain),])
a <- a[a$Correct == 1 & a$Gain == 1 & a$Center > 1000 & a$Center < 10000 & a$RT < 10000,]
df <- data.frame(rt = c(a$RT, log(a$RT)), center = rep(a$Center,2), func = factor(rep(c("identity", "log"), each = length(a$RT))))
qplot(center, rt, data = df, geom = "jitter") + facet_wrap(~func, scales = "free_y") + geom_smooth(method = "lm") + theme_bw(base_size = 24)
# add


## ----log_plot2,fig.width=12,fig.height=8---------------------------------
ggplot(a, aes(Center, RT)) + geom_jitter() + geom_smooth(method = "lm", size = 2, se = FALSE) + scale_y_log10() + theme_bw(base_size = 24)


## ----juul_setup,echo=FALSE-----------------------------------------------
library(ISwR)
data(juul)


## ----juul_model----------------------------------------------------------
juul$post <- factor(ifelse(juul$tanner > 1, 1, 0))
display(lm(igf1 ~ age * post, data = juul))


## ----juul_plot,echo=FALSE,fig.height=9,fig.width=10----------------------
qplot(age, igf1, data = juul, color = post) + geom_smooth(aes(group = post), method = "lm") + theme_bw(base_size = 24)


