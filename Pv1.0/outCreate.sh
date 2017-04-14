#!/bin/bash
#while read token concept
#do
#  #Quando sarà finito anche il POStagger si deve sostituire la seguinte riga con la successiva
#  pos=$(cat data/NLSPARQL.test.feats.txt|grep -P "\t$token\t\b"|cut -f 2)
#  #pos=$(cat taggedPOS.txt|grep -P "\t$token\b"|cut -f 2)
#  trueconcept=$(cat data/NLSPARQL.test.data|grep -P "\t$token\b"|cut -f 2)
#  echo $pos
#  #echo -e "$token\t$pos\t$concept\t$trueconcept"
#done < taggedCONCEPT.txt

cat taggedCONCEPT.txt|awk '$1 {print $1}' > token
cat data/NLSPARQL.test.feats.txt|awk '$1 {print $2}' > pos
paste token pos
#paste token pos >temptp
#paste temptp concept >temptpc
#paste temptpc trueconcept >temptpcc