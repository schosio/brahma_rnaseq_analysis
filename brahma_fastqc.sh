#!/bin/bash
date
echo "find . -name "*.fastq.gz" | parallel -j 30 -v -I% --max-args 1 fastqc --extract"
find . -name "*.fastq.gz" | parallel -j 30 -v -I% --max-args 1 fastqc --extract

