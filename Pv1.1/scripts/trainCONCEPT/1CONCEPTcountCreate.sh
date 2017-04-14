#!/bin/bash
traindata='../../data/NLSPARQL.train.data'
cat $traindata | cut -f 2 |
sed '/^ *$/d' |
sort | uniq -c |
sed 's/^ *//g' |
awk '{OFS="\t"; print $2,$1}'
