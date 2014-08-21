source('analysis-base.R')
library(plyr)
library(R.utils)

pdf('histogram.pdf')

outcome <- 'discontinuation'
treat.rng <- 2:7

densities <- alply(meas[[outcome]], 2, density)

xrngs <- laply(densities[treat.rng], function(d) {c(min(d$x), max(d$x))})
xrng <- c(min(xrngs), max(xrngs))
yrngs <- laply(densities[treat.rng], function(d) {c(min(d$y), max(d$y))})
yrng <- c(min(yrngs), max(yrngs))

plot(c(), xlim=xrng, ylim=yrng, xlab='Probability', ylab='Density')
for(i in treat.rng) {
    lines(densities[[i]], lty=i)
}
legend('topright', capitalize.default(treatments[treat.rng]), lty=treat.rng)
abline(v=meas[[outcome]][1,1], lty=1, col='darkgray')

dev.off()
