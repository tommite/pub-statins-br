library(hitandrun)
source('analyses/analysis-smaa.R')

n <- length(outcomes)

## Preferences
constr <- mergeConstraints(simplexConstraints(n),
                           ordinalConstraint(n, 2, 1), # wcer > wcor
                           ordinalConstraint(n, 1, 3), # wcor > wmya
                           ordinalConstraint(n, 3, 4)) # wmya > wtra

w.W <- hitandrun(constr, n.samples=N)

### Ordinal preferences analysis ###
result.ordinal <- smaa(part.values, w.W)

print(result.ordinal$ra)

## Plot rank acceptabilities
pdf('figs/ra-ordinal.pdf')
barplot(t(result.ordinal$ra), main="Ordinal preferences")
dev.off()

