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

mkdir -p $outputFolder

start=`date +%s`
#Conto le occorrenze dei campioni appartenenti alle diverse classi(Concetti)
./$trainFolder/1CONCEPTcountCreate.sh > $outputFolder/CONCEPT.counts
echo -n "--- 1 Computed the occurrances of the CONCEPT." 
echo " $((`date +%s`-start)) sec"
start=`date +%s`
#Conto le occorrenze del valore del campione dato che appartiene alla classe t_i (POS)
./$trainFolder/2TOK_CONCEPTcountCreate.sh > $outputFolder/TOK_CONCEPT.counts
echo -n "--- 2 Computed the joint occurrances of the CONCEPT and the TOKENS."
echo " $((`date +%s`-start)) sec"
#Descrivo la macchina a stati finiti che passa dallo stato 0 allo stato 0 ad un ingresso di TOK e un uscita di CONCEPT 
#con peso della transizione pari al -log(probabilità di TOK w_i appartenente alla classe t_i POS)
./$trainFolder/3CONCEPTtaggerWFSTCreate.sh >$outputFolder/CONCEPTtaggerFST.txt
echo -n "--- 3 Defined the weighted finite state trasducer with weights computed as -log of joint occurrances token,tag over the occurances of the CONCEPT tag."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
#Generiamo il lessico tramite ngramsymbols (appartiene al pacchetto openfst)
ngramsymbols < $dataFolder/$trainFileName >$outputFolder/lex.txt
echo "4 Created the lexicon in the output folder of the training set."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
#Compiliamo il nostro trasduttore a stati finiti tramite il lessico e che ci permetterà di convertire la frase in 
#input in una sequenza di Concetti (insomma ci permette di taggare ogni parola)
fstcompile --isymbols=$outputFolder/lex.txt  --osymbols=$outputFolder/lex.txt $outputFolder/CONCEPTtaggerFST.txt > $outputFolder/CONCEPTtagger.fst
echo " $((`date +%s`-start)) sec"
start=`date +%s`
echo -n "--- 5 Compiled WFST that brings in input the words and gives in output the tag."
./$trainFolder/4CONCEPTtaggerUnknownTOKENCreate.sh >$outputFolder/CONCEPTtaggerUnknownTokenFST.txt
echo " $((`date +%s`-start)) sec"
start=`date +%s`
echo -n "--- 6 Defined the weighted finite state trasducer that brings in input the unknown words and gives in output the tag with equal weights: -log likelihood probabilities."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
fstcompile --isymbols=$outputFolder/lex.txt --osymbols=$outputFolder/lex.txt $outputFolder/CONCEPTtaggerUnknownTokenFST.txt>$outputFolder/CONCEPTtaggerUnknownToken.fst
echo -n "--- 7 Compiled WFST that brings in input the words and gives in output the tag."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
#A questo punto uniamo i due trasduttori cosicchè la macchina finale cerchi di tradurre anche i caratteri non noti
fstunion $outputFolder/CONCEPTtaggerUnknownToken.fst $outputFolder/CONCEPTtagger.fst>$outputFolder/finalCONCEPTtagger.fst
echo -n "--- 8 Compiled WFST that brings in input the words and gives in output the tag."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
fstclosure $outputFolder/finalCONCEPTtagger.fst>$outputFolder/finalCONCEPTtaggerC.fst
echo -n "--- 9 Done the closure operation WFST that brings in input the words and gives in output the tag."
echo " $((`date +%s`-start)) sec"
start=`date +%s`
./$trainFolder/5CONCEPTfarCREATE.sh $outputFolder/CONCEPTtrain.far
echo " $((`date +%s`-start)) sec"
start=`date +%s`
echo -n "--- 10 Generated the archive of finite state machine of all the CONCEPT sentences."
./$trainFolder/6CONCEPTlmCREATE.sh
echo -n "--- 11 Finished to generated the language model of the concept with different order and smoothing method. In order to reduce the time you can edit the file 6CONCEPTlmCREATE.sh"
echo " $((`date +%s`-start)) sec"
start=`date +%s`
