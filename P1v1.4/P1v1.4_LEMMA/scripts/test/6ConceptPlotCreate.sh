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
cp $toolsTestFolder/PLOTconf/* $ConceptPlotFolder/

########################Accuracy##############################
echo -en "Smooth\order"'\t' > $ConceptPlotFolder/accuracy.dat
for order in $(seq $orderMin $orderMax)
do
    echo -en "order-$order"'\t' >> $ConceptPlotFolder/accuracy.dat
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
########################precision##############################
echo -en "Smooth\order"'\t' > $ConceptPlotFolder/precision.dat
for order in $(seq $orderMin $orderMax)
do
    echo -en "order-$order"'\t' >> $ConceptPlotFolder/precision.dat
done
echo "" >> $ConceptPlotFolder/precision.dat
for method in ${methodType[*]}
do
  echo -n "\"$method\"" >> $ConceptPlotFolder/precision.dat
  for order in $(seq $orderMin $orderMax)
  do
    echo -en '\t'"$(cat $ConceptConllevalOutFolder/accuracyLMorderSmooth$order$method.txt|grep 'accuracy: '|awk '{print $4}'|tr -d ['%;'])" >> $ConceptPlotFolder/precision.dat
  done
  echo "" >>$ConceptPlotFolder/precision.dat
done
########################recall##############################
echo -en "Smooth\order"'\t' > $ConceptPlotFolder/recall.dat
for order in $(seq $orderMin $orderMax)
do
    echo -en "order-$order"'\t' >> $ConceptPlotFolder/recall.dat
done
echo "" >> $ConceptPlotFolder/recall.dat
for method in ${methodType[*]}
do
  echo -n "\"$method\"" >> $ConceptPlotFolder/recall.dat
  for order in $(seq $orderMin $orderMax)
  do
    echo -en '\t'"$(cat $ConceptConllevalOutFolder/accuracyLMorderSmooth$order$method.txt|grep 'accuracy: '|awk '{print $6}'|tr -d ['%;'])" >> $ConceptPlotFolder/recall.dat
  done
  echo "" >>$ConceptPlotFolder/recall.dat
done
########################FB1########################
echo -en "Smooth\order"'\t' > $ConceptPlotFolder/FB1.dat
for order in $(seq $orderMin $orderMax)
do
    echo -en "order-$order"'\t' >> $ConceptPlotFolder/FB1.dat
done
echo "" >> $ConceptPlotFolder/FB1.dat
for method in ${methodType[*]}
do
  echo -n "\"$method\"" >> $ConceptPlotFolder/FB1.dat
  for order in $(seq $orderMin $orderMax)
  do
    echo -en '\t'"$(cat $ConceptConllevalOutFolder/accuracyLMorderSmooth$order$method.txt|grep 'accuracy: '|awk '{print $8}'|tr -d ['%;'])" >> $ConceptPlotFolder/FB1.dat
  done
  echo "" >>$ConceptPlotFolder/FB1.dat
done

gnuplot $ConceptPlotFolder/ComparationMethodAccuracy.plt
gnuplot $ConceptPlotFolder/ComparationMethodPrecision.plt
gnuplot $ConceptPlotFolder/ComparationMethodRecall.plt
gnuplot $ConceptPlotFolder/ComparationMethodFB1.plt

cat $ConceptPlotFolder/accuracy.dat|rs -c$'\t' -C$'\t' -T >$ConceptPlotFolder/TrasposeAccuracy.dat
cat $ConceptPlotFolder/precision.dat|rs -c$'\t' -C$'\t' -T >$ConceptPlotFolder/TrasposePrecision.dat
cat $ConceptPlotFolder/recall.dat|rs -c$'\t' -C$'\t' -T >$ConceptPlotFolder/TrasposeRecall.dat
cat $ConceptPlotFolder/FB1.dat|rs -c$'\t' -C$'\t' -T >$ConceptPlotFolder/TrasposeFB1.dat

gnuplot $ConceptPlotFolder/ComparationOrderAccuracy.plt
gnuplot $ConceptPlotFolder/ComparationOrderPrecision.plt
gnuplot $ConceptPlotFolder/ComparationOrderRecall.plt
gnuplot $ConceptPlotFolder/ComparationOrderFB1.plt