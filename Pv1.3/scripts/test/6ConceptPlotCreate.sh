#!/bin/bash

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
ConceptOUTtoConllevalFolder=$OUTtoConllevalFolder/CONCEPT
PosOUTtoConllevalFolder=$OUTtoConllevalFolder/POS
LemmaOUTtoConllevalFolder=$OUTtoConllevalFolder/LEMMA
ConllevalOutFolder=$outputFolder/conllevalOUT
ConceptConllevalOutFolder=$ConllevalOutFolder/CONCEPT
PosConllevalOutFolder=$ConllevalOutFolder/POS
LemmaConllevalOutFolder=$ConllevalOutFolder/LEMMA
plotFolder=$outputFolder/PLOT
ConceptPlotFolder=$plotFolder/CONCEPT
PosPlotFolder=$plotFolder/POS
LemmaPlotFolder=$plotFolder/LEMMA
dataFolder=../data
orderMin=$(cat classification.conf|grep ^orderMin|awk '{print $2}'|tr -sc [0-9] ' ') 
orderMax=$(cat classification.conf|grep ^orderMax|awk '{print $2}'|tr -sc [0-9] ' ') 
methodType=($(cat classification.conf|grep ^smoothing|awk '{print $2}'))
cutoffFreq=$(cat classification.conf|grep ^cutoffFreq|awk '{print $2}'|tr -sc [0-9] ' ') 

mkdir -p $ConceptPlotFolder

echo -en "Smooth\order"'\t' > $ConceptPlotFolder/accuracy.dat
for order in $(seq $orderMin $orderMax)
do
    echo -en "$order"'\t' >> $ConceptPlotFolder/accuracy.dat
done
echo "" >> $ConceptPlotFolder/accuracy.dat
for method in ${methodType[*]}
do
  echo -n "\"$method\"" >> $ConceptPlotFolder/accuracy.dat
  for order in $(seq $orderMin $orderMax)
  do
    echo -en '\t'"$(cat $ConceptConllevalOutFolder/accuracyLMorderSmooth$order$method.txt|grep 'accuracy: '|awk '{print $2}'|tr -d ['%;'])" >> $ConceptPlotFolder/accuracy.dat
  done
  echo "" >>$ConceptPlotFolder/accuracy.dat
done
#gnuplot $ConceptPlotFolder/accuracy.plt