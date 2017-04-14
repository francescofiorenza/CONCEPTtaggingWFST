#!/bin/bash
#Converte le parole per ogni linea in frasi per linea (TokenPerLine2SentencePerLine)
./convTPL2SPLtrain.sh >SPLtrain.txt
#Final
farfile=$1
SPL=SPLtrain.txt
farcompilestrings --symbols=lex.txt "$SPL" > $farfile
