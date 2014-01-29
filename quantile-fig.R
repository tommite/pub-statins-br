source('analysis-base.R')

calc.quantiles <- function(meas) {
	lapply(meas, function(x) {
		apply(x, 2, function(y) {
			quantile(y, probs=c(0.025, 0.5, 0.975))
		})
	})
}

quants <- calc.quantiles(meas)

plotQuantiles <- function(outcome) {
	data <- data.frame(
		id=colnames(quants[[outcome]]), pe=quants[[outcome]]['50%',], ci.l=quants[[outcome]]['2.5%',], ci.u=quants[[outcome]]['97.5%',], style='normal')
	blobbogram(data, xlim=c(
                             round(min(quants[[outcome]]), 2)-0.01,
                             round(max(quants[[outcome]]), 2)+0.01
                             ),
                   id.label="Treatment", ci.label="Risk (95% CI)", right.label=outcome)
}

## make quantile figs
for (oc in outcomes) {
    pdf(paste('quantiles-', oc, '.pdf', sep=''))
    plotQuantiles(oc)
    dev.off()
}
