source('analyses/analysis-smaa.R')

## Preferences
wcer <- 1.0
wcor <- 0.9 * wcer
wmya <- wcor / 40.0
wtra <- wmya / 5

w <- c(wcor, wcer, wmya, wtra)
w <- w / sum(w) # normalize

w.W <- matrix(rep(w, N), ncol=length(w), byrow=TRUE)

### Exact preferences analysis ###
result.exact <- smaa(part.values, w.W)

print(result.exact$ra)

## Plot rank acceptabilities
pdf('figs/ra-exact.pdf')
barplot(t(result.exact$ra), main="Exact weight ratios")
dev.off()

