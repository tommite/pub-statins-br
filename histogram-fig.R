source('analysis-base.R')

pdf('histogram.pdf')

par(mfrow=c(4, 2))
for (o in outcomes) {
    name <- paste('p(', o, ')', sep='')
    hist(meas[[o]][,2:7], ylab='', xlab=name,main='', breaks=100)
}

dev.off()
