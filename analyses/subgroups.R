library(plyr)
source('analyses/analysis-base.R')

groups <- list('p', 's')

message("---\nQuantiles for primary and secondary prevention\n---")

oc.stat <- function(oc, group) {
    meas <- gen.meas(readRDS(paste('data/', oc, '.', group, '.meas.rds', sep='')))
    q <- oc.quantiles(meas)
    round(c(min(meas), min(q[1,]), max(q[3,]), max(meas)), 2)
}

all.res <- llply(groups, function(gr) {
    res <- laply(outcomes, oc.stat, gr)
    rownames(res) <- outcomes
    colnames(res) <- c('0%', '2.5%', '97.5%', '100%')
    res
})

names(all.res) <- c('primary', 'secondary')

options(scipen=100, digits=3)

print(all.res)
