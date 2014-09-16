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
	meas <- ilogit(cbind(0, rmnorm(N, desc$rel$mean, desc$rel$cov)) + desc$base)
	colnames(meas) <- treatments
	meas
}

meas <- lapply(outcomes, function(outcome) { gen.meas(dget(paste('data/', outcome, '.meas.txt', sep=''))) })
names(meas) <- outcomes

oc.quantiles <- function(oc.meas) {
    apply(oc.meas, 2, function(y) {
        quantile(y, probs=c(0.025, 0.5, 0.975))
    })
}

calc.quantiles <- function(meas) {
	lapply(meas, oc.quantiles)
}

print.pvf.ranges <- function(meas) {
    lapply(meas, function(x) {
        quantile(x, probs=c(0.025, 0.975))
    })
}

quants <- calc.quantiles(meas)

## Establish partial value functions, compute the partial values
## Note: range defined in 95% confidence interval
part.values <- lapply(meas, function(x) {
    matrix(smaa.pvf(x, cutoffs=quantile(x, probs=c(0.025, 0.975)),
                    values=c(1,0), outOfBounds="interpolate"),
           nrow=nrow(x), ncol=ncol(x))
})

part.values <- array(unlist(part.values), dim=c(N, length(treatments), length(outcomes)), dimnames=list(1:N, treatments, outcomes))
