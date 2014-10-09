library(xlsx)
source('params.R')

fname <- 'data/studies-with-filtering-info.xlsx'

for (oc in outcomes) {
    data <- read.xlsx(fname, sheetName=oc, );
    data <- data[,c(2:3, 5:ncol(data))]; # take what we need

    cols <- colnames(data)
    cols <- sub('..', '[,', cols, fixed=TRUE)
    cols <- sub('.', ']', cols, fixed=TRUE)
    cols <- sub(',$', ']', cols)
    colnames(data) <- cols
    
    out.fname <- paste('data/', oc, '.data.txt', sep='');
        
    write.table(data, out.fname, quote=FALSE, sep="\t");
}
