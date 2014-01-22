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

## Establish partial value functions, compute the partial values
part.values <- lapply(meas, function(x) {
    matrix(smaa.pvf(x, cutoffs=range(x), values=c(0,1)), nrow=nrow(x), ncol=ncol(x))
})
calc.quantiles(part.values)
part.values <- array(unlist(part.values), dim=c(N, length(treatments), length(outcomes)), dimnames=list(1:N, treatments, outcomes))

### Preference-free analysis ###
w.W <- simplex.sample(length(outcomes), N)$samples
result.pref.free <- smaa(part.values, w.W)

## Plot rank acceptabilities
plot(result.pref.free$ra)

## Plot central weights for alts >= min.cf.limit
plot(NA, xlim=c(1, length(outcomes)), ylim=c(0, 0.26), xlab="", ylab="Weight", xaxt='n')
axis(side=1, at=1:7, labels=outcomes, las=2)
result.pref.free.cw <- smaa.cf(part.values, result.pref.free$cw)
pfree.to.plot <- result.pref.free.cw$cf >= min.cf.limit
for (t in treatments) {
    if (result.pref.free.cw$cf[t] >= min.cf.limit) {
        lines(result.pref.free.cw$cw[t,], type='o', pch=i)
    }
}
legend("bottomright", legend=treatments[pfree.to.plot],
       pch=(1:length(treatments))[pfree.to.plot])
