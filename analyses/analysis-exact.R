source('analyses/analysis-smaa.R')

## Preferences
wmor <- 1.0
wstr <- (1/4) * wmor
wmi <- (1/2) * wstr
wmya <- (1/25) * wmi
wck <- (1/2) * wmya
wtra <- (1/1.1) * wck

w <- c(wmi, wstr, wmor, wmya, wtra, wck)
w <- w / sum(w) # normalize

## drop insignificant criteria
w <- w[1:4]
part.values <- part.values[,,1:4]

w.W <- matrix(rep(w, N), ncol=length(w), byrow=TRUE)

### Exact preferences analysis ###
result.exact <- smaa(part.values, w.W)

print(result.exact$ra)

## Plot rank acceptabilities
pdf('figs/ra-exact.pdf')
barplot(t(result.exact$ra), main="Exact trade-offs (weights)")
dev.off()

