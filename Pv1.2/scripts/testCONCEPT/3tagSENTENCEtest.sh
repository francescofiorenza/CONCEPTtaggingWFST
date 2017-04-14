#!/bin/bash
mkdir -p ../output/TaggedOutput
orderMin=1
orderMax=6
methodType=(witten_bell absolute katz kneser_ney presmoothed unsmoothed)
for method in ${methodType[*]}
do
  for order in $(seq $orderMin $orderMax)
  do
    for file in ../output/temp/test/*; do
      fstcompose $file ../output/finalCONCEPTtaggerC.fst |
      fstcompose - ../output/LM/lmCONCEPT$order$method.lm|
      fstrmepsilon -|
      fstshortestpath -|
      fsttopsort - |
      fstprint  --isymbols=../output/lex.txt  --osymbols=../output/lex.txt -|
      awk '$3 {OFS="\t";print $3,$4}'>>../output/TaggedOutput/orderSmooth$order$method.txt
    done
    echo "Finished test with order$order and method $method, ../output/TaggedOutput/orderSmooth$order$method.txt"
  done
done
