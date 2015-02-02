source('params.R')
source('analyses/analysis-mtc.R')
library(gemtc)

plot.pooled <- function(oc) {
  result <- dget(paste0('data/', oc, '.mtc.result.rds'))
  rel.eff <- relative.effect(result, t1=treatments[1], t2=treatments[-1], preserve.extra=FALSE)
  forest(rel.eff)
}

