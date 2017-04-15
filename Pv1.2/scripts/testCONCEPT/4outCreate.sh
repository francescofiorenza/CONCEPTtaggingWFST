#!/bin/bash
mkdir -p ../output/OUTtoConlleval
orderMin=1
orderMax=6
methodType=(witten_bell absolute katz kneser_ney presmoothed unsmoothed)
for method in ${methodType[*]}
do
  for order in $(seq $orderMin $orderMax)
  do
    cat ../data/NLSPARQL.test.data|awk '$1 {print $1}' > ../output/token
    cat ../data/NLSPARQL.test.feats.txt|awk '$1 {print $2}' > ../output/pos
    cat ../data/NLSPARQL.test.data|awk '$1 {print $2}' > ../output/CONCEPTtag
    cat ../output/TaggedOutput/orderSmooth$order$method.txt|awk '$1 {print $2}' > ../output/predictedCONCEPTtag
    paste ../output/token ../output/pos ../output/CONCEPTtag ../output/predictedCONCEPTtag > ../output/OUTtoConlleval/OUTorderSmooth$order$method.txt
  done
done
    
