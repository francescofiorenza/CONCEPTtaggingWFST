#!/bin/bash
#per provare a testare una frase 
#fstcompose test/SPLtest-0084 finalCONCEPTtagger.fst|fstdraw --isymbols=lex.txt --osymbols=lex.txt |xdot -
for file in ../output/temp/test/*; do
  fstcompose $file ../output/finalCONCEPTtaggerC.fst |
  fstcompose - ../output/CONCEPT.lm|
  fstrmepsilon -|
  fstshortestpath -|
  fsttopsort - |
  fstprint  --isymbols=../output/lex.txt  --osymbols=../output/lex.txt -|
  awk '$3 {OFS="\t";print $3,$4}'
  #echo $file 
  #echo -e "\t"$(echo $file|tr -sc [0-9] ' ')\\r
done
#fstprint  --isymbols=../../lex.txt  --osymbols=../../lex.txt -