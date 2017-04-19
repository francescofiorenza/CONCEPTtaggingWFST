#!/bin/bash
#per provare a testare una frase 
#fstdraw --isymbols=../../lex.txt --osymbols=../../lex.txt SPLtokenTest-0005|xdot - 2>/dev/null
#fstcompose SPLtokenTest-0813 finalCONCEPTtagger.fst|fstdraw --isymbols=lex.txt --osymbols=lex.txt |xdot -
trainFileName=NLSPARQL.train.data
trainFeatFileName=NLSPARQL.train.feats.txt
testFileName=NLSPARQL.test.data
testFeatFileName=NLSPARQL.test.feats.txt
SPLTokenTxtName=SPLtokenTest
testTokenFarName=SPLtokenTest.far
outputFolder=../output
tempFolder=$outputFolder/temp
trainFolder=train
testFolder=test
toolsTestFolder=$testFolder/tools
LMfolder=$outputFolder/LM
LMconceptFolder=$LMfolder/CONCEPT
LMposFolder=$LMfolder/POS
LMlemmaFolder=$LMfolder/LEMMA
FSTsentenceTESTfolder=$tempFolder/test
TaggedOutpuFolder=$outputFolder/TaggedOutput
ConceptTaggedOutpuFolder=$TaggedOutpuFolder/CONCEPT
PosTaggedOutpuFolder=$TaggedOutpuFolder/POS
LemmaTaggedOutpuFolde=$TaggedOutpuFolder/LEMMA
OUTtoConllevalFolder=$outputFolder/OUTtoConlleval
conllevalOutFolder=$outputFolder/conllevalOUT
plotFolder=$outputFolder/PLOT
dataFolder=../data
orderMin=$(cat classification.conf|grep ^orderMin|awk '{print $2}'|tr -sc [0-9] ' ') 
orderMax=$(cat classification.conf|grep ^orderMax|awk '{print $2}'|tr -sc [0-9] ' ') 
methodType=($(cat classification.conf|grep ^smoothing|awk '{print $2}'))
cutoffFreq=$(cat classification.conf|grep ^cutoffFreq|awk '{print $2}'|tr -sc [0-9] ' ') 

rm -Rf $ConceptTaggedOutpuFolder
mkdir -p $ConceptTaggedOutpuFolder
for method in ${methodType[*]}
do
  for order in $(seq $orderMin $orderMax)
  do
    echo " "
    echo "  - Start test order$order method $method - "
    echo " "
    start=`date +%s`
    for file in $FSTsentenceTESTfolder/*; do
      fstcompose $file $outputFolder/finalCONCEPTtaggerC.fst |
      fstcompose - $LMconceptFolder/lmCONCEPT$order$method.lm|
      fstrmepsilon -|
      fstshortestpath -|
      fsttopsort - |
      fstprint  --isymbols=$outputFolder/lex.txt  --osymbols=$outputFolder/lex.txt -|
      awk '$3 {OFS="\t";print $3,$4}'>>$ConceptTaggedOutpuFolder/orderSmooth$order$method.txt
      echo -n .
    done
    end=`date +%s`
    runtime=$((end-start))
    echo " "
    echo "  - Finished test in $runtime sec order$order method $method - "
  done
done
