library(gemtc)

treatments <- c('Control', 'Atorva', 'Fluva', 'Lova', 'Prava', 'Rosuva', 'Simva')

source('code/read.bugs.data.R')
data <- read.bugs.data('data/coronary.data.txt')
colnames(data) <- c('responders', 'sampleSize', 'treatment', 'study')
data$treatment <- treatments[data$treatment]

network <- mtc.network(data)

pdf('figs/network.pdf')
plot(network, edge.color='black', vertex.color='white', vertex.label.color='black',
     vertex.size=30, vertex.label.family='sans')
dev.off()
