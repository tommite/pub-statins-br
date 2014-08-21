### Run in GeMTC

library(gemtc)

run.mtc <- function(data) {
	colnames(data) <- c('responders', 'sampleSize', 'treatment', 'study')
	data$treatment <- paste('t', data$treatment, sep='')

	network <- mtc.network(data)
	model <- mtc.model(network)
	result <- mtc.run(model)
}
