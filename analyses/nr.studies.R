library(xlsx)
library(plyr)
source('params.R')

fname <- 'data/studies-with-filtering-info.xlsx'

for (oc in outcomes) {
    res <- llply(outcomes, function(oc) { levels(read.xlsx(fname, sheetName=oc)$Study.Name) })
    studies <- sort(unique(unlist(res)))
    cat(oc, " - ", length(studies), "studies:", studies, "\n")
}
