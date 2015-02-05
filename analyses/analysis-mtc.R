library(xlsx)
source('code/read.bugs.data.R')
source('code/run.mtc.R')
source('params.R')

### Estimates the predictive distribution
abs.pooled <- function(data, trt) {
  library(rjags)
  data1 <- data[data$t == trt,]
  model <- jags.model('analyses/baseline.jags', data=list(n=data1$n, r=data1$r))
  samples <- coda.samples(model, variable.names=c('pred'), n.iter=5E3)
  s <- summary(samples)
  list(mean=unname(s$statistics[1]), se=unname(s$statistics[2]))
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

single.trial.baseline <- function(outcome, primary=TRUE) {
    fname <- 'data/studies-revised.xlsx'
    xlsdata <- read.xlsx(fname, sheetName=outcome)
    study <- if (primary) 'ALLHAT-LTT' else 'MRC/BHF Heart Protection Study'
    study.data <- xlsdata[which(xlsdata[,1] == study),]
    pl.r <- as.numeric(study.data[2])
    pl.n <- as.numeric(study.data[3])
    stopifnot(!(is.na(pl.r)) && !(is.na(pl.n))) # sanity check
    list(a=(pl.r+1), b=(pl.n-pl.r+1))
}

write.measurement <- function(outcome, primary=TRUE) {
    result <- readRDS(paste('data/', outcome, '.mtc.result.rds', sep=''))
    result <- relative.effect(result, t1=treatments[1], t2=treatments[-1], preserve.extra=FALSE)
    
    if (outcome %in% outcomes.use.single.trial) {
        alo <- single.trial.baseline(outcome, primary)
    } else { # use all trials
        data <- read.bugs.data(paste('data/', outcome, '.data.txt', sep=''))
        alo <- abs.pooled(data, 1)
    }
    rel <- rel.pooled(result)

    add.char <- if (primary) 'p' else 's'
    saveRDS(list(base=alo, rel=rel), paste('data/', outcome, '.', add.char, '.meas.rds', sep=''))
}
