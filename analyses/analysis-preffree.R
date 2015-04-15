source('analyses/analysis-smaa.R')

### Preference-free analysis ###
w.W <- simplex.sample(length(outcomes), N)$samples
result.pref.free <- smaa(part.values, w.W)

print(result.pref.free$ra)

## Plot rank acceptabilities
pdf('figs/ra-preffree.pdf', width=8, height=8)
par(mar=c(5.1, 12.1, 4.1, 2.1), xpd=TRUE)
barplot(t(result.pref.free$ra), main="No weight information",
        legend=paste('Rank', 1:ncol(result.pref.free$ra)),
        args.legend=list(x='topleft', inset=c(-0.4,0)))
dev.off()

## Plot central weights for alts >= min.cf.limit
pdf('figs/cw-preffree.pdf')
plot(NA, xlim=c(1, length(outcomes)), ylim=c(0, 0.50), xlab="", ylab="Weight", xaxt='n')
axis(side=1, at=1:length(outcomes), labels=outcomes, las=1)
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
