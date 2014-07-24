source('analysis-base.R')

### Preference-free analysis ###
w.W <- simplex.sample(length(outcomes), N)$samples
result.pref.free <- smaa(part.values, w.W)

## Plot rank acceptabilities
pdf('ra-preffree.pdf')
plot(result.pref.free$ra, main='')
dev.off()

## Plot central weights for alts >= min.cf.limit
pdf('cw-preffree.pdf')
plot(NA, xlim=c(1, length(outcomes)), ylim=c(0, 0.30), xlab="", ylab="Weight", xaxt='n', main='')
axis(side=1, at=1:7, labels=outcomes, las=2)
result.pref.free.cw <- smaa.cf(part.values, result.pref.free$cw)
pfree.to.plot <- result.pref.free.cw$cf >= min.cf.limit
for (t in treatments) {
    if (result.pref.free.cw$cf[t] >= min.cf.limit) {
        lines(result.pref.free.cw$cw[t,], type='o', pch=which(treatments == t))
    }
}
legend("bottomright", legend=treatments[pfree.to.plot],
       pch=(1:length(treatments))[pfree.to.plot])
dev.off()
