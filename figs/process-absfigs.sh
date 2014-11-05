#!/bin/bash

for i in absmeas-*.pdf; do
    pdfcrop $i "proc-$i"
done
