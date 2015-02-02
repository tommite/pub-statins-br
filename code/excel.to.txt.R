library(xlsx)
source('params.R')

fname <- 'data/studies-revised.xlsx'

args <- commandArgs(trailingOnly = TRUE)
oc <- args[[1]]
out.fname <- args[[2]]

data <- read.xlsx(fname, sheetName=oc)
data <- data[,-1]; # take what we need

cols <- colnames(data)
cols <- sub('..', '[,', cols, fixed=TRUE)
cols <- sub('.', ']', cols, fixed=TRUE)
cols <- sub(',$', ']', cols)
colnames(data) <- cols

write.table(data, out.fname, quote=FALSE, sep="\t");
