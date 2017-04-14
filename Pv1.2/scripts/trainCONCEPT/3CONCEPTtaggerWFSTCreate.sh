#!/bin/bash
while read token concept count
do
  concept1=$(echo $concept|sed 's/\$/\\$/g')
  conceptcount=$(grep -P "^$concept1\t" ../output/CONCEPT.counts | cut -f 2)
  prob=$(echo "-l($count / $conceptcount)" | bc -l)
  echo -e "0\t0\t$token\t$concept\t$prob"
done < ../output/TOK_CONCEPT.counts
echo '0'
