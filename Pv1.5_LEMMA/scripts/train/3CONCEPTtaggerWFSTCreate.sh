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

cat ../data/original/NLSPARQL.train.data|cut -f 2 >../data/original/tempConceptTrain
cat ../data/original/NLSPARQL.test.data|cut -f 2 >../data/original/tempConceptTest
cat ../data/original/NLSPARQL.train.feats.txt|cut -f $tokenconf > ../data/original/tempTokenTrain
cat ../data/original/NLSPARQL.test.feats.txt|cut -f $tokenconf >../data/original/tempTokenTest
paste ../data/original/tempTokenTrain ../data/original/tempConceptTrain |sed $'s/^\t*$//g'  > ../data/NLSPARQL.train.data
paste ../data/original/tempTokenTest ../data/original/tempConceptTest |sed $'s/^\t*$//g' >  ../data/NLSPARQL.test.data

while read token tag count
do
  tag1=$(echo $tag|sed 's/\$/\\$/g')
  tagcount=$(grep -P "^$tag1\t" $outputFolder/CONCEPT.counts | cut -f 2)
  prob=$(echo "-l($count / $tagcount)" | bc -l)
  if [ $tagcount -gt $cutoffFreq ]
  then
    echo -e "0\t0\t$token\t$tag\t$prob"
  fi
  #else
    #echo -e "0\t0\t<unk>\t$tag\t$prob"
    #sed -i "s/$token/<unk>/g" $dataFolder/$trainFileName    
  #fi
done < $outputFolder/TOK_CONCEPT.counts
echo '0'
