#!/bin/bash

for i in odds-*.pdf; do
    pdfcrop $i "proc-$i"
done
