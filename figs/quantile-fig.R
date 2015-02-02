library(plyr)
source('analyses/analysis-base.R')
source('params.R')

meas <- lapply(outcomes, function(outcome) { gen.meas(dget(paste('data/', outcome, '.meas.rds', sep=''))) })
names(meas) <- outcomes

calc.quantiles <- function(meas) {
	lapply(meas, oc.quantiles)
}

quants <- calc.quantiles(meas)

meas.rel <- lapply(meas, function(x) {
  x[, colnames(x) != "Control"] - x[, "Control"]
})
quants.rel <- calc.quantiles(meas.rel)

plotQuantiles <- function(q.oc, outcome, scale, xlim=c(0, round(max(quants[[outcome]]), 2)+0.01)) {
  data <- data.frame(id=colnames(q.oc), pe=q.oc['50%',],
                     ci.l=q.oc['2.5%',], ci.u=q.oc['97.5%',], style='pooled')
  blobbogram(data, xlim=xlim,
             id.label="Treatment", ci.label=paste(scale, "(95% CI)"), right.label=outcome)
}

## make quantile figs
for (oc in outcomes) {
    pdf(paste('figs/quantiles-', oc, '.pdf', sep=''))
    plotQuantiles(quants.rel[[oc]], oc, scale="Risk difference", xlim=c(-0.1,0.1))
    dev.off()
}
