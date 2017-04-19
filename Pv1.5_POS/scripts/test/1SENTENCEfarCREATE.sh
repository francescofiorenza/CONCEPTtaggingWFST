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

#Converte le parole per ogni linea in frasi per linea (TokenPerLine2SentencePerLine)
./$toolsTestFolder/convTPL2SPLtest.sh >$outputFolder/$SPLTokenTxtName
farfile=$testTokenFarName
#farcompilestrings --symbols=lex.txt --unknown_symbol='<unk>' -keep_symbols=1 "$SPL" > $farfile
farcompilestrings --symbols=$outputFolder/lex.txt --unknown_symbol='<unk>' --fst_error_fatal=1 $outputFolder/$SPLTokenTxtName > $outputFolder/$farfile
