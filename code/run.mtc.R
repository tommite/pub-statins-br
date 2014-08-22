source('params.R')
library(gemtc)

run.mtc <- function(data) {
	colnames(data) <- c('responders', 'sampleSize', 'treatment', 'study')
        tr.app <- treatments
        if (length(unique(data$treatment) == 8)) {
          tr.app <- c(tr.app, 't8')
        }
        data$treatment <- tr.app[data$treatment]
	network <- mtc.network(data)
	model <- mtc.model(network)
	result <- mtc.run(model)
}
