#!/bin/bash
#Converte le parole per ogni linea in frasi per linea (TokenPerLine2SentencePerLine)
SPL=../output/SPLCONCEPTtrain
./trainCONCEPT/tools/convTPL2SPLtrain.sh > $SPL
farfile=$1
farcompilestrings --symbols=../output/lex.txt --unknown_symbol='<unk>' $SPL > $farfile
