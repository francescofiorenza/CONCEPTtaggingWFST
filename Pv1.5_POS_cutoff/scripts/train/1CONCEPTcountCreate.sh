#!/bin/bash
trainFileName=NLSPARQL.train.data
trainFeatFileName=NLSPARQL.train.feats.txt
testFileName=NLSPARQL.test.data
testFeatFileName=NLSPARQL.test.feats.txt
outputFolder=../output
LMfolder=$outputFolder/LM
FSTsentenceTESTfolder=$outputFolder/temp/test
TaggedOutpuFolder=$outputFolder/TaggedOutput
OUTtoConllevalFolder=$outputFolder/OUTtoConlleval
conllevalOutFolder=$outputFolder/conllevalOUT
plotFolder=$outputFolder/PLOT
dataFolder=../data
orderMin=$(cat classification.conf|grep ^orderMin|awk '{print $2}'|tr -sc [0-9] ' ') 
orderMax=$(cat classification.conf|grep ^orderMax|awk '{print $2}'|tr -sc [0-9] ' ') 
methodType=($(cat classification.conf|grep ^smoothing|awk '{print $2}'))
cutoffFreq=$(cat classification.conf|grep ^cutoffFreq|awk '{print $2}'|tr -sc [0-9] ' ') 
tokenconf=$(cat classification.conf|grep ^token|awk '{print $2}'|tr -sc [0-9] ' ') 

cat $dataFolder/original/$trainFileName|cut -f 2 >$dataFolder/original/tempConceptTrain
cat $dataFolder/original/$testFileName|cut -f 2 >$dataFolder/original/tempConceptTest
cat $dataFolder/original/$trainFeatFileName|cut -f $tokenconf > $dataFolder/original/tempTokenTrain
cat $dataFolder/original/$testFeatFileName|cut -f $tokenconf >$dataFolder/original/tempTokenTest
paste $dataFolder/original/tempTokenTrain $dataFolder/original/tempConceptTrain |sed $'s/^\t*$//g'  > $dataFolder/$trainFileName
paste $dataFolder/original/tempTokenTest $dataFolder/original/tempConceptTest |sed $'s/^\t*$//g' >  $dataFolder/$testFileName

cat $dataFolder/$trainFileName | cut -f 2 |
sed '/^ *$/d' |
sort | uniq -c |
sed 's/^ *//g' |
awk '$1 {OFS="\t";  print $2,$1}'
#eval $commandAWK

