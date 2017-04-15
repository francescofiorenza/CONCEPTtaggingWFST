#!/bin/bash
SPL=SPLtokenTest.far
./testCONCEPT/1SENTENCEfarCREATE.sh ../output/$SPL
./testCONCEPT/2EXTRACTfstSENTENCE.sh
./testCONCEPT/3tagSENTENCEtest.sh
./testCONCEPT/4outCreate.sh 
./testCONCEPT/5evalCreate.sh 
./testCONCEPT/6plotCreate.sh 