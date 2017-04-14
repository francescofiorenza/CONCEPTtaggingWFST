#!/bin/bash
#Converte le parole per ogni linea in frasi per linea (TokenPerLine2SentencePerLine)
SPL=SPLtrainPOS
./convTPL2SPLtrainfeats.sh >$SPL
#Final
farfile=$1
farcompilestrings --symbols=lex.txt --unknown_symbol='<unk>' "$SPL" > $farfile
