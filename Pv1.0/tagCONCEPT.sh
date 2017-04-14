#!/bin/bash
#per provare a testare una frase 
#fstcompose test/SPLtest-0084 finalCONCEPTtagger.fst|fstdraw --isymbols=lex.txt --osymbols=lex.txt |xdot -
for file in test/*; do
  fstcompose ${file%.*} finalCONCEPTtagger.fst |
  #fstcompose test/SPLtest-0014 finalCONCEPTtagger.fst|
  fstcompose - CONCEPT.lm|
  fstrmepsilon -|
  fstshortestpath -|
  fsttopsort - |
  fstprint  --isymbols=lex.txt  --osymbols=lex.txt
  awk '$3 {OFS="\t";print $3,$4}'
done