source('code/read.bugs.data.R')
source('code/run.mtc.R')
source('params.R')

### Naive pooling of placebo arms for rough incidence
abs.pooled <- function(data, trt) {
	data1 <- data[data$t == trt,]
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

write.measurement <- function(outcome, basel.filter='p') {
	result <- dget(paste('data/', outcome, '.mtc.result.txt', sep=''))
	result <- relative.effect(result, t1=treatments[1], t2=treatments[-1], preserve.extra=FALSE)

	data <- read.bugs.data(paste('data/', outcome, '.data.txt', sep=''),
                               basel.filter, only.included='p' %in% basel.filter)
	alo <- abs.pooled(data, 1)
	rel <- rel.pooled(result)

	dput(list(base=alo, rel=rel), paste('data/', outcome, '.', paste(basel.filter, collapse='.'), '.meas.txt', sep=''))
}
