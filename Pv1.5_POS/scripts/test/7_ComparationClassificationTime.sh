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
tokenconf=$(cat classification.conf|grep ^token|awk '{print $2}'|tr -sc [0-9] ' ') 

mkdir -p $ConceptPlotFolder
cp $toolsTestFolder/PLOTconf/* $ConceptPlotFolder/

########################Classification Tiome##############################
echo -en "Smooth\order-classificationTime"'\t' > $ConceptPlotFolder/classificationTime.dat
for order in $(seq $orderMin $orderMax)
do
    echo -en "order-$order"'\t' >> $ConceptPlotFolder/classificationTime.dat
done
echo "" >> $ConceptPlotFolder/classificationTime.dat
for method in ${methodType[*]}
do
  echo -n "\"$method\"" >> $ConceptPlotFolder/classificationTime.dat
  for order in $(seq $orderMin $orderMax)
  do
    echo -en '\t'"$(cat $ConceptPlotFolder/ClassificationTime.log|grep -P "$method\t"|grep -P "order$order\t"|cut -f 3|tr -d ['%;'])" >> $ConceptPlotFolder/classificationTime.dat
  done
  echo "" >>$ConceptPlotFolder/classificationTime.dat
done
##########################################################################

gnuplot $ConceptPlotFolder/ComparationMethodClassificationTime.plt

cat $ConceptPlotFolder/classificationTime.dat|rs -c$'\t' -C$'\t' -T >$ConceptPlotFolder/TrasposeClassificationTime.dat

gnuplot $ConceptPlotFolder/ComparationOrderClassificationTime.plt