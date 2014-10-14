#!/bin/bash

-rm proc-ra-*

for i in ra-*.pdf; do
    pdfcrop $i "proc-$i"
done
