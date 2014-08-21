source('code/read.bugs.data.R')
source('code/run.mtc.R')

### Naive pooling of placebo arms for rough incidence

abs.pooled <- function(data, trt) {
	data1 <- data[data$t == 1,]
	data1$r <- data1$r + 0.5
	data1$n <- data1$n + 1
	alo <- log(data1$r / (data1$n - data1$r))
	alo.se <- sqrt(1/data1$r + 1 / (data1$n - data1$r))
	alo.prec <- 1 / alo.se
	weighted.mean(alo, alo.prec)
}

### Normal summaries of relative effects (MTC results)

rel.pooled <- function(result) {
	samples <- as.matrix(result$samples)
	list(mean=apply(samples, 2, mean), cov=cov(samples))
}


### 95% CrIs for absolute risk
ilogit <- function(x) { exp(x) / (1 + exp(x)) }

risk.range <- function(alo, rel) {
	mu <- alo + c(0, rel$mean)
	sigma <- c(0, rel$cov[as.logical(diag(length(rel$mean)))])
	lower <- mu - 1.96 * sigma
	upper <- mu + 1.96 * sigma
	ilogit(cbind(mu, lower, upper))
}

to.risk.samples <- function(result, alo) {
	as.mcmc.list(lapply(result$samples, function(chain) {
		mcmc(
			data=apply(chain, 2, function(x) { ilogit(x + alo) }),
			start=start(chain), end=end(chain), thin=thin(chain)
		)
	}))
}

write.measurement <- function(outcome) {
	result <- dget(paste(outcome, 'mtc.result.txt', sep='.'))
	result <- relative.effect(result, t1='t1', t2=c('t2', 't3', 't4', 't5', 't6', 't7'), preserve.extra=FALSE)

	data <- read.bugs.data(paste(outcome, 'data.txt', sep='.'))
	alo <- abs.pooled(data, 1)
	rel <- rel.pooled(result)

	dput(list(base=alo, rel=rel), paste(outcome, 'meas.txt', sep='.'))
}

#> exp(alo.pooled) / (1 + exp(alo.pooled))
#[1] 0.07591115


outcomes <- c('cerebrovasc', 'ck-elevation', 'coronary',
	'discontinuation', 'mortality', 'myalgia',
	'transaminase')
#files <- paste(outcomes, 'txt', sep='.')
#
#distr <- lapply(files, function(file) { 
#	data <- read.bugs.data(file)
#	list(
#		alo=abs.pooled(data, 1),
#		rel=rel.pooled(data, 1)
#	)
#})

#stuff <- lapply(distr, function(x) { risk.range(x$alo, x$rel) })
#ranges <- lapply(stuff, range)

# low   high  diff
# 0.015 0.035 0.020 # cerebrovasc
# 0.000 0.139 0.139 # ck-elevation
# 0.037 0.071 0.034 # coronary
# 0.047 0.085 0.039 # discontinuation
# 0.048 0.081 0.032 # mortality
# 0.018 0.088 0.070 # myalgia
# 0.011 0.148 0.137 # transaminase
