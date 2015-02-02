library(plyr)
library(gemtc)
source('params.R')

meas <- llply(outcomes, function(outcome) { dget(paste0('data/', outcome, '.mtc.result.rds')) })
names(meas) <- outcomes

for (oc in outcomes) {
    pdf(paste('figs/odds-', oc, '.pdf', sep=''))
    forest(relative.effect(meas[[oc]], t1='Control', t2=treatments[-1]))
    text(0.4, 0.3, oc)
    dev.off()
}
