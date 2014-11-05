library(hitandrun)
source('analyses/analysis-smaa.R')

n <- length(outcomes)

## Preferences
constr <- mergeConstraints(simplexConstraints(n),
                           lowerRatioConstraint(n, 1, 2, 0.5), # wcer / wcor in [0.5, 0.8]
                           upperRatioConstraint(n, 1, 2, 0.8),
                           lowerRatioConstraint(n, 1, 3, 25.0), # wcor / wmya in [25, 55]
                           upperRatioConstraint(n, 1, 3, 55.0),
                           lowerRatioConstraint(n, 1, 4, 50.0), # wcor / wmya in [50, 90]
                           upperRatioConstraint(n, 1, 4, 90.0))
                           
w.W <- hitandrun(constr, n.samples=N)

### Imprecise ratio preference analysis ###
result.ratio <- smaa(part.values, w.W)

print(result.ratio$ra)

## Plot rank acceptabilities
pdf('figs/ra-ratio.pdf')
barplot(t(result.ratio$ra), main="Imprecise trade-off ratios")
dev.off()

