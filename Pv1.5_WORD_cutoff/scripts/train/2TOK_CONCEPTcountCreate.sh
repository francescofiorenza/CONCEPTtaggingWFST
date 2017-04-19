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

#commandAWK="awk '\$1>$cutoffFreq {OFS=\"\\t\";  print \$2,\$1}'"
cat $dataFolder/$trainFileName |
sed '/^ *$/d' |
sort | uniq -c |
sed 's/^ *//g' |
awk '{OFS="\t"; print $2,$3,$1}'