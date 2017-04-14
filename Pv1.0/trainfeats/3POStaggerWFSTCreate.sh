#!/bin/bash
while read token POS count
do
POS1=$(echo POS|sed 's/\$/\\$/g')
POScount=$(grep -P "^$POS1\t" POS.counts | cut -f 2)
prob=$(echo "-l($count / $POScount)" | bc -l)
#echo  $prob
echo -e "0\t0\t$token\t$POS\t$prob"
done < TOK_POS.counts
echo '0'
