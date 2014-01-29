#!/bin/bash

for i in quantiles-*.pdf; do
    pdftk $i cat 2 output - | pdfcrop - "proc-$i"
done
