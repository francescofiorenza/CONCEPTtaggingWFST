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
FSTsentenceTESTfolder=$tempFolder/test
TaggedOutpuFolder=$outputFolder/TaggedOutput
OUTtoConllevalFolder=$outputFolder/OUTtoConlleval
conllevalOutFolder=$outputFolder/conllevalOUT
plotFolder=$outputFolder/PLOT
dataFolder=../data
orderMin=$(cat classification.conf|grep ^orderMin|awk '{print $2}'|tr -sc [0-9] ' ') 
orderMax=$(cat classification.conf|grep ^orderMax|awk '{print $2}'|tr -sc [0-9] ' ') 
methodType=($(cat classification.conf|grep ^smoothing|awk '{print $2}'))
cutoffFreq=$(cat classification.conf|grep ^cutoffFreq|awk '{print $2}'|tr -sc [0-9] ' ') 

temppath=$(pwd)
rm -Rf $FSTsentenceTESTfolder
mkdir -p $FSTsentenceTESTfolder
cd $FSTsentenceTESTfolder
#farextract --filename_prefix='test_sentence_number_' --fst_error_fatal=1 ../../SPLtokenTest.far
farextract --fst_error_fatal=1 ../../SPLtokenTest.far
cd $temppath