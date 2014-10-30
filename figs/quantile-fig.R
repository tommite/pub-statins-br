library(plyr)
source('analyses/analysis-base.R')
source('params.R')

meas <- lapply(outcomes, function(outcome) { gen.meas(dget(paste('data/', outcome, '.p.meas.txt', sep=''))) })
names(meas) <- outcomes

meas.rel <- lapply(outcomes, function(outcome) { gen.meas(dget(paste('data/', outcome, '.p.meas.txt', sep='')), baseline.uncertainty=FALSE) })
names(meas.rel) <- outcomes

calc.quantiles <- function(meas) {
	lapply(meas, oc.quantiles)
}

quants <- calc.quantiles(meas)

quants.rel <- calc.quantiles(meas.rel)

plotQuantiles <- function(q.oc, outcome, xlim=c(0, round(max(quants[[outcome]]), 2)+0.01)) {
  data <- data.frame(id=colnames(q.oc), pe=q.oc['50%',],
                     ci.l=q.oc['2.5%',], ci.u=q.oc['97.5%',], style='normal')
  blobbogram(data, xlim=xlim,
             id.label="Treatment", ci.label="Risk (95% CI)", right.label=outcome)
}

## make quantile figs
for (oc in outcomes) {
    pdf(paste('figs/quantiles-', oc, '.pdf', sep=''))
    plotQuantiles(quants[[oc]], oc)
    dev.off()
}
