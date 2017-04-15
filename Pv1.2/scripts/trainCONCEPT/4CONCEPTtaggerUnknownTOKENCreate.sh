#!/bin/bash
traindata='../../data/NLSPARQL.train.data'
N=$(cat $traindata | cut -f 2 |sed '/^ *$/d' |sort | uniq|wc -l)
prob=$(echo "-l(1/$N)" | bc -l)
while read concept count
do
echo -e "0\t0\t<unk>\t$concept\t$prob"
done < ../../CONCEPT.counts
echo "0"
