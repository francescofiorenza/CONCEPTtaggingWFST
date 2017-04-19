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

cat $dataFolder/original/$trainFileName|cut -f 3 >$dataFolder/original/tempConceptTrain
cat $dataFolder/original/$testFileName|cut -f 3 >$dataFolder/original/tempConceptTest
cat $dataFolder/original/$trainFeatFileName|cut -f 1 > $dataFolder/original/tempTokenTrain
cat $dataFolder/original/$testFeatFileName|cut -f 1 >$dataFolder/original/tempTokenTest
paste $dataFolder/original/tempTokenTrain $dataFolder/original/tempConceptTrain |sed $'s/^\t*$//g'  > $dataFolder/$trainFileName
paste $dataFolder/original/tempTokenTest $dataFolder/original/tempConceptTest |sed $'s/^\t*$//g' >  $dataFolder/$testFileName

commandAWK="awk '\$1>$cutoffJointFreq {OFS=\"\\t\";  print \$2,\$3,\$1}'"
cat $dataFolder/$trainFeatFileName |
sed '/^ *$/d' |awk '{OFS="\t"; print $1,$3}'|
sort | uniq -c |
sed 's/^ *//g' |
awk '{OFS="\t"; print $2,$3,$1}'