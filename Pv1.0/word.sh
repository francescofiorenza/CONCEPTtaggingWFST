#!/bin/bash
cat data/NLSPARQL.train.data |cut -f 1|tr '\n' ''| uniq -c|sed "s/^[ ]*//"|sort -nr|tr ' ' "\t"