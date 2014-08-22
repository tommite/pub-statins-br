#!/bin/bash

for i in quantiles-*.pdf; do
    pdfcrop $i "proc-$i"
done
