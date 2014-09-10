
### Convert data to one-row-per-arm format
read.bugs.data <- function(file) {
	data <- read.table(file, header=T)
        pops <- data$population

	n <- length(grep('^r\\.\\.', colnames(data)))
	cols <- c('r', 'n', 't')
	data <- do.call(rbind, lapply(1:n, function(i) {
		df <- do.call(data.frame,
			c(lapply(cols, function(colname) {
				data[[paste(colname, '..', i, '.', sep='')]]
			}), list(1:length(data$na)))
		)
		colnames(df) <- c(cols, 's')
		df
	}))
	data$r <- as.integer(data$r)
	data$n <- as.integer(data$n)
	data <- data[!is.na(data$t),]
        data$pop <- pops[data$s] # add population identifier
	data
}
