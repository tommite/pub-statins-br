library(gemtc)
source('params.R')
source('code/read.bugs.data.R')

data <- read.bugs.data('data/All-causeMortality.data.txt')
colnames(data) <- c('responders', 'sampleSize', 'treatment', 'study')
data$treatment <- treatments[data$treatment]

network <- mtc.network(data)
print(summary(network))

pdf('figs/network.pdf')
plot(network, edge.color='black', vertex.color='white', vertex.label.color='black',
     vertex.size=30, vertex.label.family='sans')
dev.off()
