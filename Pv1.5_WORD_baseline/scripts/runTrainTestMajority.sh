#!/bin/bash
trainFileName=NLSPARQL.train.data
trainFeatFileName=NLSPARQL.train.feats.txt
testFileName=NLSPARQL.test.data
testFeatFileName=NLSPARQL.test.feats.txt
SPLTokenTxtName=SPLtokenTest
testTokenFarName=SPLtokenTest.far
toolsTestFolder=$testFolder/tools
toolsEval=../evalTools
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

mkdir -p $outputFolder
mkdir -p $ConceptPlotFolder
mkdir -p $ConceptOUTtoConllevalFolder
mkdir -p $ConceptConllevalOutFolder

cat $dataFolder/original/$trainFileName|cut -f 2 >$dataFolder/original/tempConceptTrain
cat $dataFolder/original/$testFileName|cut -f 2 >$dataFolder/original/tempConceptTest
cat $dataFolder/original/$trainFeatFileName|cut -f $tokenconf > $dataFolder/original/tempTokenTrain
cat $dataFolder/original/$testFeatFileName|cut -f $tokenconf >$dataFolder/original/tempTokenTest
paste $dataFolder/original/tempTokenTrain $dataFolder/original/tempConceptTrain |sed $'s/^\t*$//g'  > $dataFolder/$trainFileName
paste $dataFolder/original/tempTokenTest $dataFolder/original/tempConceptTest |sed $'s/^\t*$//g' >  $dataFolder/$testFileName
cp $dataFolder/original/$trainFeatFileName $dataFolder/$trainFeatFileName
cp $dataFolder/original/$testFeatFileName $dataFolder/$testFeatFileName

cat $dataFolder/$testFileName|awk '$1 {print $1}' > $outputFolder/token
cat $dataFolder/$testFeatFileName|awk '$1 {print $2}' > $outputFolder/pos
cat $dataFolder/$testFileName|awk '$1 {print $2}' > $outputFolder/CONCEPTtag

echo -n "" > $outputFolder/predictedCONCEPTtag
for i in `seq $(cat $dataFolder/$testFileName|wc -l)`; do echo "O" >> $outputFolder/predictedCONCEPTtag;done
paste $outputFolder/token $outputFolder/pos $outputFolder/CONCEPTtag $outputFolder/predictedCONCEPTtag > $ConceptOUTtoConllevalFolder/OUTmajority.txt

perl $toolsEval/conlleval.pl -d '\t' < $ConceptOUTtoConllevalFolder/OUTmajority.txt > $ConceptConllevalOutFolder/accuracyMajority.txt
echo 'accuracy & precision & recall & FB1 \\'  > $ConceptPlotFolder/Majority.dat
echo -en 'Majority & '"$(cat $ConceptConllevalOutFolder/accuracyMajority.txt|grep 'accuracy: '|awk '{print $2}'|tr -d ['%;'])" >> $ConceptPlotFolder/Majority.dat
echo -en ' & '"$(cat $ConceptConllevalOutFolder/accuracyMajority.txt|grep 'accuracy: '|awk '{print $4}'|tr -d ['%;'])" >> $ConceptPlotFolder/Majority.dat
echo -en ' & '"$(cat $ConceptConllevalOutFolder/accuracyMajority.txt|grep 'accuracy: '|awk '{print $6}'|tr -d ['%;'])" >> $ConceptPlotFolder/Majority.dat
echo -en ' & '"$(cat $ConceptConllevalOutFolder/accuracyMajority.txt|grep 'accuracy: '|awk '{print $8}'|tr -d ['%;'])" >> $ConceptPlotFolder/Majority.dat
echo -en ' \\\\ ' >> $ConceptPlotFolder/Majority.dat
