source('analyses/analysis-base.R')
source('params.R')

meas <- lapply(outcomes, function(outcome) { gen.meas(dget(paste('data/', outcome, '.meas.txt', sep=''))) })
names(meas) <- outcomes

plotQuantiles <- function(outcome) {
  data <- data.frame(id=colnames(quants[[outcome]]), pe=quants[[outcome]]['50%',],
                     ci.l=quants[[outcome]]['2.5%',], ci.u=quants[[outcome]]['97.5%',], style='normal')
  blobbogram(data, xlim=c(round(min(quants[[outcome]]), 2)-0.01,
                     round(max(quants[[outcome]]), 2)+0.01),
             id.label="Treatment", ci.label="Risk (95% CI)", right.label=outcome)
}

## make quantile figs
for (oc in outcomes) {
    pdf(paste('figs/quantiles-', oc, '.pdf', sep=''))
    plotQuantiles(oc)
    dev.off()
}
