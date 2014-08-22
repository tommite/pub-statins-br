source('params.R')
library(gemtc)

plot.pooled <- function(oc) {
  result <- dget(paste0('data/', oc, '.mtc.result.txt'))
  rel.eff <- relative.effect(result, t1=treatments[1], t2=treatments[-1], preserve.extra=FALSE)
  forest(rel.eff)
}

par(mfrow=c(ceiling(length(outcomes)/2), 2))
llply(outcomes, plot.pooled)
