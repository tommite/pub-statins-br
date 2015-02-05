library(plyr)
source('analyses/analysis-base.R')
source('params.R')

meas <- lapply(outcomes, function(outcome) { gen.meas(readRDS(paste('data/', outcome, '.p.meas.rds', sep=''))) })
names(meas) <- outcomes

calc.quantiles <- function(meas) {
	lapply(meas, oc.quantiles)
}

quants <- calc.quantiles(meas)

meas.rel <- lapply(meas, function(x) {
  x[, colnames(x) != "Control"] - x[, "Control"]
})
quants.rel <- calc.quantiles(meas.rel)

plotQuantiles <- function(q.oc, outcome, scale) {
    xlim <- c(round(min(quants[[outcome]]), 2)-0.01,
              round(max(quants[[outcome]]), 2)+0.01)
    if (xlim[1] < 0) xlim[1] <- 0
    print(xlim)
    data <- data.frame(id=colnames(q.oc),
                       pe=q.oc['50%',],
                       ci.l=q.oc['2.5%',],
                       ci.u=q.oc['97.5%',],
                       style='pooled')
    blobbogram(data, xlim=xlim,
               id.label="Treatment", ci.label=paste(scale, "(95% CI)"),
               right.label=oc.names[outcome])
}

## make quantile figs
for (oc in outcomes) {
    pdf(paste('figs/absmeas-', oc, '.pdf', sep=''))
    plotQuantiles(quants[[oc]], oc, scale="Absolute risk")
    dev.off()
}
