#!/bin/bash
trainFileName=NLSPARQL.train.data
trainFeatFileName=NLSPARQL.train.feats.txt
testFileName=NLSPARQL.test.data
testFeatFileName=NLSPARQL.test.feats.txt
outputFolder=../output
tempFolder=$outputFolder/temp
trainFolder=train
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

#Prendiamo in input il nostro file di training con tutte le parole classificate nella loro classe sintattica
#Estraiamo solo la classe sintattica per poi andare a calcola la probabilità che una appaia prima di un`altra dato che prima ne è apparsa un`altra ancora
cat $dataFolder/$testFileName | cut -f 1 |
#sostituiamo le righe vuote con un carattere speciale che poi sostituiremo con un accapo
sed 's/^ *$/#/g' |
#sostituiamo gli acapo con uno spazio
tr '\n' ' ' |
#ripristiniamo la righa vuota con un acapo per identificare che la frase è finita
tr '#' '\n' |
#eliminiamo tutte le possibili riche vuote causate da possibili doppi asterischi
sed 's/^ *//g;s/ *$//g'
