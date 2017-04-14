#!/bin/bash
#Converte le parole per ogni linea in frasi per linea (TokenPerLine2SentencePerLine)
./convTPL2SPLtest.sh >SPLtest
#Final
farfile=$1
SPL=SPLtest
#farcompilestrings --symbols=lex.txt --unknown_symbol='<unk>' -keep_symbols=1 "$SPL" > $farfile
farcompilestrings --symbols=lex.txt --unknown_symbol='<unk>' "$SPL" > $farfile

