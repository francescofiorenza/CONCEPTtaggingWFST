#!/bin/bash
SPL=SPLtokenTest.far
./testCONCEPT/1SENTENCEfarCREATE.sh ../output/$SPL
./testCONCEPT/2EXTRACTfstSENTENCE.sh
./testCONCEPT/3tagSENTENCEtest.sh >../output/predictedCONCEPTtag.txt
./testCONCEPT/4outCreate.sh >../output/out.txt
perl conlleval.pl -d '\t' < ../output/out.txt > ../output/accuracy.txt