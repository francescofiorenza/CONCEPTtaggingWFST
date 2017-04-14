#!/bin/bash
#Converte le parole per ogni linea in frasi per linea (TokenPerLine2SentencePerLine)
./convTPL2SPLtrain.sh >SPLtrain
#Final
farfile=$1
SPL=SPLtrain
farcompilestrings --symbols=lex.txt --unknown_symbol='<unk>' "$SPL" > $farfile
