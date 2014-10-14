library(hitandrun)
source('analyses/analysis-smaa.R')

n <- length(outcomes)

## Preferences
constr <- mergeConstraints(simplexConstraints(n),
                           lowerRatioConstraint(n, 1, 2, 0.85), # wcer / wcor in [0.85, 0.95]
                           upperRatioConstraint(n, 1, 2, 0.95),
                           lowerRatioConstraint(n, 1, 3, 30.0), # wcor / wmya in [30, 50]
                           upperRatioConstraint(n, 1, 3, 50.0),
                           lowerRatioConstraint(n, 3, 4, 4.0), # wmya / wtra in [4, 6]
                           upperRatioConstraint(n, 3, 4, 6.0))
                           
w.W <- hitandrun(constr, n.samples=N)

### Imprecise ratio preference analysis ###
result.ratio <- smaa(part.values, w.W)

print(result.ratio$ra)

## Plot rank acceptabilities
pdf('figs/ra-ratio.pdf')
barplot(t(result.ratio$ra), main="Imprecise weight ratios")
dev.off()

