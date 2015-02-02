library(plyr)
source('analyses/analysis-base.R')

meas <- lapply(outcomes, function(outcome) { gen.meas(readRDS(paste('data/', outcome, '.meas.rds', sep=''))) })
names(meas) <- outcomes

quants <- calc.quantiles(meas)
ranges <- llply(quants, function(t) {c(min(t[1,]), max(t[3,]))})

## Establish partial value functions, compute the partial values
## Note: range defined in 95% confidence interval
part.values <- lapply(meas, function(x) {
    q <- oc.quantiles(x)
    rng <- c(min(q[1,]), max(q[3,]))
    
    matrix(smaa.pvf(x, cutoffs=rng, values=c(1,0), outOfBounds="interpolate"),
           nrow=nrow(x), ncol=ncol(x))
})

part.values <- array(unlist(part.values), dim=c(N, length(treatments), length(outcomes)), dimnames=list(1:N, treatments, outcomes))
