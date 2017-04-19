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
conllevalOutFolder=$outputFolder/conllevalOUT
plotFolder=$outputFolder/PLOT
dataFolder=../data
orderMin=$(cat classification.conf|grep ^orderMin|awk '{print $2}'|tr -sc [0-9] ' ') 
orderMax=$(cat classification.conf|grep ^orderMax|awk '{print $2}'|tr -sc [0-9] ' ') 
methodType=($(cat classification.conf|grep ^smoothing|awk '{print $2}'))
cutoffFreq=$(cat classification.conf|grep ^cutoffFreq|awk '{print $2}'|tr -sc [0-9] ' ') 

rm -Rf $LemmaOUTtoConllevalFolder
mkdir -p $LemmaOUTtoConllevalFolder
for method in ${methodType[*]}
do
  for order in $(seq $orderMin $orderMax)
  do
    cat $dataFolder/$testFileName|awk '$1 {print $1}' > $outputFolder/token
    cat $dataFolder/$testFeatFileName|awk '$1 {print $2}' > $outputFolder/pos
    cat $dataFolder/$testFeatFileName|awk '$1 {print $3}' > $outputFolder/LEMMAtag
    cat $ConceptTaggedOutpuFolder/orderSmooth$order$method.txt|awk '$1 {print $2}' > $outputFolder/predictedPOStag
    paste $outputFolder/token $outputFolder/pos $outputFolder/LEMMAtag $outputFolder/predictedLEMMAtag > $LemmaOUTtoConllevalFolder/OUTorderSmooth$order$method.txt
  done
done
    
