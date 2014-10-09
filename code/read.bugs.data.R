
### Convert data to one-row-per-arm format
read.bugs.data <- function(file, filter=c('m', 'p', 's'), only.included=FALSE) {
	data <- read.table(file, header=T)
        pops <- data$popind
	incs <- data$include

	n <- length(grep('^r\\.\\.', colnames(data)))
	cols <- c('r', 'n', 't')
	data <- do.call(rbind, lapply(1:n, function(i) {
		df <- do.call(data.frame,
			c(lapply(cols, function(colname) {
				data[[paste(colname, 
					'..', i, '.', sep='')]]
			}), list(1:length(data$na)))
		)
		colnames(df) <- c(cols, 's')
		df
	}))
	data$r <- as.integer(data$r)
	data$n <- as.integer(data$n)
	data <- data[!is.na(data$t),]
        data$pop <- pops[data$s] # add population identifier
        data$inc <- incs[data$s] # add inclusion identifier
        # filter out studies not matching the filter
	pop.filtered <- data[data$pop %in% filter,]
	# if only.included, filter those
	if (only.included) {
	   pop.filtered <- pop.filtered[pop.filtered$inc == 'y',]
	}
	pop.filtered[,colnames(pop.filtered) != 'inc']
}
