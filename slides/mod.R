source("~/Dropbox/psyc489j_2015/reading/stan_lm.R")
dat <- read.csv("data/ravensdata.csv")

temp <- stanLM(ravens ~ shape * nfc * educ, dat, copy.lm = FALSE)

save(temp, "mod.rbind.data.frame")