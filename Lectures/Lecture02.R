
## ----setup,echo=FALSE----------------------------------------------------
require(knitr)
opts_chunk$set(cache=TRUE, fig.align='center')
options(digits = 2)


## ----anscombe,echo=FALSE,message=FALSE,warning=FALSE---------------------
invisible(lapply(c("reshape2", "ggplot2", "psych", "plyr"), require, character.only = TRUE))
data(anscombe)
a <- data.frame(x = melt(anscombe[1:4], value.name = "x")[2], y = melt(anscombe[5:8], value.name = "y")[2], id = factor(rep(1:4, each = nrow(anscombe))))
with(a, tapply(x, id, mean))
with(a, tapply(y, id, mean))
with(a, tapply(x, id, sd))
with(a, tapply(y, id, sd))
daply(a, .(id), function(val) cor(val$x, val$y))


## ----anscombe_plot,echo=FALSE,results='hide',message=FALSE,warning=FALSE,fig.align="center",fig.height=12,fig.width=12----
qplot(x, y, data = a, geom = "smooth", method = "lm", fullrange = TRUE, se = FALSE) + geom_point(size = 4) + facet_wrap(~id) + theme_bw(base_size = 24)


## ----bees,echo=FALSE,fig.width=18,fig.height=10,fig.align="center"-------
year <- c(2008, 2009, 2010, 2011)
bees <- c(20,19,5,4)
sunflower <- c(200, 199, 190, 189)
a <- data.frame(year = rep(year, 2), population = c(bees, sunflower), type = rep(c("bees", "flowers"), each = 4))
qplot(year, population, data = a, geom = "line", group = 1) + geom_point(size = 3) + facet_wrap(~type, scale = "free_y") + ggtitle("Population by year") + theme_bw(base_size = 24)


## ----bees_better,echo=FALSE,fig.height=9,fig.width=10,fig.align="center"----
qplot(year, population, data = a, geom = "line", group = type, color = type) + geom_point(size = 3) + ggtitle("Population by year") + theme_bw(base_size = 20)


## ----bees_better2,echo=FALSE,fig.height=9,fig.width=10,fig.align="center"----
b <- data.frame(year = rep(year, 2), population = c(bees/max(bees), sunflower/max(sunflower)), type = rep(c("bees", "flowers"), each = 4))
qplot(year, population, data = b, geom = "line", group = type, color = type) + geom_point(size = 3) + ggtitle("Percent of initial population by year") + theme_bw(base_size = 20)


## ----gog,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"--------
y <- rnorm(100)
x1 <- scale(y + rnorm(100))
x2 <- scale(y + 2 * rnorm(100, sd = 2))
a <- data.frame(y = c(y,y), x = c(x1,x2), group = rep(c(0,1), each = 100))
a$group <- factor(a$group)
qplot(x,y,data = a) + theme_bw(base_size = 24) + xlab("") + ylab("")


## ----gog_2,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
data(mpg)
qplot(displ, hwy, data = mpg, color = factor(cyl)) + theme_gray(base_size = 24)


## ----gog_3,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = cyl) + theme_gray(base_size = 24)


## ----gog_4,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = factor(cyl), geom = "line") + theme_gray(base_size = 24)


## ----gog_5,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = factor(cyl), geom = "bar", position = "dodge", stat = "identity") + theme_gray(base_size = 24)


## ----gog_6,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = factor(cyl), geom = c("point", "smooth"), method = "lm") + theme_gray(base_size = 24)


## ----full_spec-----------------------------------------------------------
p <- ggplot(diamonds, aes(x = carat))
p <- p + layer(
  geom = "bar",
  geom_params = list(fill = "steelblue"),
  stat = "bin",
  stat_params = list(binwidth = .01)
)


## ----full_spec_viz,fig.align="center",fig.height=5,fig.width=8,echo=FALSE----
p


## ----full_spec_full,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"----
p + theme_grey(base_size = 28)


## ----measles_setup,echo=FALSE,include=FALSE------------------------------
load("~/Dropbox/DAM lab/Math/Tasks/Data/mathreboot4/.RData")
library(gdata)
library(scales)
a <- drop.levels(a[!is.na(a$RT) & !is.na(a$Gain),])
a$center <- factor(a$Center)


## ----measles,fig.width=16------------------------------------------------
p <- ggplot(a, aes(center, RT))
p + geom_boxplot(outlier.size = 0) + geom_jitter(color = "firebrick", alpha = .05) +
  theme_bw(base_size = 28) + facet_wrap(~gain) + xlab("center (digits)") + ylab("rt (ms)") + ylim(c(0,6000))


## ----,cont_plot----------------------------------------------------------
p <- ggplot(a[a$Gain == 1,], aes(Center, RT))
p <- p + geom_jitter(alpha = .05) + geom_smooth(formula = y ~ log(x), method = "lm", se = FALSE, aes(group = Subj), color = alpha("blue", .3)) + ylim(c(0, 6000)) + geom_smooth(formula = y ~ log(x), method = "lm", color = "firebrick", se = FALSE, size = 1.2) + theme_bw(base_size = 24)


## ----print_cont,echo=FALSE,fig.height = 8--------------------------------
p


