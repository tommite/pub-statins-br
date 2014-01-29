library(gemtc)
library(mnormt)
library(hitandrun)
library(smaa)

options(digits=3)
N <- 1E4
min.cf.limit <- 0.1

outcomes <- c(
	'mortality', 'coronary', 'cerebrovasc',
	'discontinuation', 'myalgia', 'transaminase', 'ck-elevation'
	)

treatments <- c('control', 'atorva', 'fluva', 'lova', 'prava', 'rosuva', 'simva')

ilogit <- function(x) { exp(x) / (1 + exp(x)) }

gen.meas <- function(desc) {
	meas <- ilogit(cbind(0, rmnorm(N, desc$rel$mean, desc$rel$cov)) + desc$base)
	colnames(meas) <- treatments
	meas
}

meas <- lapply(outcomes, function(outcome) { gen.meas(dget(paste(outcome, 'meas.txt', sep='.'))) })
names(meas) <- outcomes


## Establish partial value functions, compute the partial values
part.values <- lapply(meas, function(x) {
    matrix(smaa.pvf(x, cutoffs=range(x), values=c(0,1)), nrow=nrow(x), ncol=ncol(x))
})

part.values <- array(unlist(part.values), dim=c(N, length(treatments), length(outcomes)), dimnames=list(1:N, treatments, outcomes))

