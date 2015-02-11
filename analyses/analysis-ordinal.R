library(hitandrun)
source('analyses/analysis-smaa.R')

n <- length(outcomes)

## Preferences
constr <- mergeConstraints(simplexConstraints(n),
                           ordinalConstraint(n, 3, 2), # wmort > wstroke
                           ordinalConstraint(n, 2, 1), # wstroke > wmi
                           ordinalConstraint(n, 1, 4), # wmi > wmyalgia
                           ordinalConstraint(n, 4, 6), # wmyalgia > wck
                           ordinalConstraint(n, 6, 5)) # wck > wtrans

w.W <- hitandrun(constr, n.samples=N)

### Ordinal preferences analysis ###
result.ordinal <- smaa(part.values, w.W)

print(result.ordinal$ra)

## Plot rank acceptabilities
pdf('figs/ra-ordinal.pdf')
barplot(t(result.ordinal$ra), main="Ordinal preferences")
dev.off()

