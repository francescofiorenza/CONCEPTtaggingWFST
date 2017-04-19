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

while read token tag count
do
  tag1=$(echo $tag|sed 's/\$/\\$/g')
  tagcount=$(grep -P "^$tag1\t" $outputFolder/LEMMA.counts | cut -f 2)
  prob=$(echo "-l($count / $tagcount)" | bc -l)
  echo -e "0\t0\t$token\t$tag\t$prob"
done < $outputFolder/TOK_LEMMA.counts
echo '0'
