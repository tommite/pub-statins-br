library(gemtc)
library(mnormt)
library(hitandrun)
library(smaa)
source('params.R')

options(digits=3)
N <- 1E5
min.cf.limit <- 0.1

ilogit <- function(x) { exp(x) / (1 + exp(x)) }

gen.meas <- function(desc) {
  base <- rnorm(N, desc$base$mean, desc$base$se)
  rel <- cbind(0, rmnorm(N, desc$rel$mean, desc$rel$cov))
  abs <- rel + base
	meas <- ilogit(abs)
	colnames(meas) <- treatments
	meas
}

oc.quantiles <- function(oc.meas) {
    apply(oc.meas, 2, function(y) {
        quantile(y, probs=c(0.025, 0.5, 0.975))
    })
}

calc.quantiles <- function(meas) {
	lapply(meas, oc.quantiles)
}
