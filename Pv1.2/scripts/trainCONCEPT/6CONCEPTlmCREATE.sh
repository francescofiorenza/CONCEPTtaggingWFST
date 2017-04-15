#!/bin/bash
mkdir -p ../output/LM
orderMin=1
orderMax=6
methodType=(witten_bell absolute katz kneser_ney presmoothed unsmoothed)
for method in ${methodType[*]}
do
  for order in $(seq $orderMin $orderMax)
  do
    ngramcount --order=$order --require_symbols=false ../output/CONCEPTtrain.far |
    ngrammake --method=$method - > ../output/LM/lmCONCEPT$order$method.lm
  done
done