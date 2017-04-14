#!/bin/bash
traindata='../data/NLSPARQL.train.feats.txt'
N=$(cat $traindata | cut -f 2 |sed '/^ *$/d' |sort | uniq|wc -l)
prob=$(echo "-l(1/$N)" | bc -l)
while read POS count
do
echo -e "0\t0\t<unk>\t$POS\t$prob"
done < POS.counts
echo "0"
