library(hitandrun)
source('analyses/analysis-smaa.R')

## drop insignificant criteria
n <- 4 # length(outcomes)
part.values <- part.values[,,1:4]

## Preferences
constr <- mergeConstraints(simplexConstraints(n),
                           lowerRatioConstraint(n, 3, 2, 3), # wmort / wstroke in [3, 5]
                           upperRatioConstraint(n, 3, 2, 5),
                           lowerRatioConstraint(n, 2, 1, 1.5), # wstroke / wmi in [1.5, 2.5]
                           upperRatioConstraint(n, 2, 1, 2.5),
                           lowerRatioConstraint(n, 1, 4, 20.0), # wmi / wmyalgia in [20, 30]
                           upperRatioConstraint(n, 1, 4, 30.0))

w.W <- hitandrun(constr, n.samples=N)

### Imprecise ratio preference analysis ###
result.ratio <- smaa(part.values, w.W)

print(result.ratio$ra)

## Plot rank acceptabilities
pdf('figs/ra-ratio.pdf')
barplot(t(result.ratio$ra), main="Trade-off intervals")
dev.off()

