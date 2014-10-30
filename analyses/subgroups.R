library(plyr)
source('analyses/analysis-base.R')

groups <- list('p')

message("---\nQuantiles using filtered primary prevention studies for the baseline estimation.\n---")

oc.stat <- function(oc, group) {
    meas <- gen.meas(dget(paste('data/', oc, '.', paste(group, collapse='.'), '.meas.txt', sep='')))
    q <- oc.quantiles(meas)
    c(min(meas), min(q[1,]), max(q[3,]), max(meas))
}

all.res <- llply(groups, function(gr) {
    res <- laply(outcomes, oc.stat, gr)
    rownames(res) <- outcomes
    colnames(res) <- c('0%', '2.5%', '97.5%', '100%')
    res
})

names(all.res) <- c('primary')

options(digits=1)

print(all.res)
