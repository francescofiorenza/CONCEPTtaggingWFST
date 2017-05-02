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

./$testFolder/1SENTENCEfarCREATE.sh 

./$testFolder/2EXTRACTfstSENTENCE.sh

echo -n "--- start tagging with concept..."
./$testFolder/3CONCEPT_ML_taggingSENTENCEtest.sh

mkdir -p $ConceptOUTtoConllevalFolder
cat $dataFolder/$testFileName|awk '$1 {print $1}' > $outputFolder/token
cat $dataFolder/$testFeatFileName|awk '$1 {print $2}' > $outputFolder/pos
cat $dataFolder/$testFileName|awk '$1 {print $2}' > $outputFolder/CONCEPTtag
cat $ConceptTaggedOutpuFolder/ML.txt|awk '$1 {print $2}' > $outputFolder/predictedCONCEPTtag
paste $outputFolder/token $outputFolder/pos $outputFolder/CONCEPTtag $outputFolder/predictedCONCEPTtag > $ConceptOUTtoConllevalFolder/OUTml.txt


perl $toolsEval/conlleval.pl -d '\t' < $ConceptOUTtoConllevalFolder/OUTml.txt > $ConceptConllevalOutFolder/accuracyML.txt
echo 'accuracy & precision & recall & FB1 \\'  > $ConceptPlotFolder/ML.dat
echo -en 'ML & '"$(cat $ConceptConllevalOutFolder/accuracyML.txt|grep 'accuracy: '|awk '{print $2}'|tr -d ['%;'])" >> $ConceptPlotFolder/ML.dat
echo -en ' & '"$(cat $ConceptConllevalOutFolder/accuracyML.txt|grep 'accuracy: '|awk '{print $4}'|tr -d ['%;'])" >> $ConceptPlotFolder/ML.dat
echo -en ' & '"$(cat $ConceptConllevalOutFolder/accuracyML.txt|grep 'accuracy: '|awk '{print $6}'|tr -d ['%;'])" >> $ConceptPlotFolder/ML.dat
echo -en ' & '"$(cat $ConceptConllevalOutFolder/accuracyML.txt|grep 'accuracy: '|awk '{print $8}'|tr -d ['%;'])" >> $ConceptPlotFolder/ML.dat
echo -en ' \\\\ ' >> $ConceptPlotFolder/ML.dat

