#!/bin/bash
trainFileName=NLSPARQL.train.data
trainFeatFileName=NLSPARQL.train.feats.txt
testFileName=NLSPARQL.test.data
testFeatFileName=NLSPARQL.test.feats.txt
SPLConceptTxtName=SPLconcept
ConceptFarName=SPLconcept.far
SPLTokenTxtName=SPLtokenTest
testTokenFarName=SPLtokenTest.far
outputFolder=../output
tempFolder=$outputFolder/temp
trainFolder=train
testFolder=test
toolsTrainFolder=$trainFolder/tools
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

start=`date +%s`
./$testFolder/1SENTENCEfarCREATE.sh 
echo -n "--- 1 Generated the archive of finite state machine of all the token sentences."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
./$testFolder/2EXTRACTfstSENTENCE.sh
echo -n "--- 2 Finished to extract all the finite state machine of all the sentences."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
echo -n "--- start tagging with concept..."
./$testFolder/3CONCEPTtaggingSENTENCEtest.sh
echo -n "--- 3 Finished to tag with the concept the entire database of test."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
./$testFolder/4ConceptOutConllevalCreate.sh
echo -n "--- 4 Finished to generate the file for the evaluation tools."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
./$testFolder/5ConceptEvalCreate.sh
echo -n "--- 5 Finished to generate accuracy file of the classification."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
./$testFolder/6ConceptPlotCreate.sh
echo -n "--- 6 Finished to generate all the graph."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
