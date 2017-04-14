#!/bin/bash
traindata='../../data/NLSPARQL.train.data'
cat $traindata |
sed '/^ *$/d' |
sort | uniq -c |
sed 's/^ *//g' |
awk '{OFS="\t"; print $2,$3,$1}'