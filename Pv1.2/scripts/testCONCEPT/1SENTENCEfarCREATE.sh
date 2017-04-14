#!/bin/bash
#Converte le parole per ogni linea in frasi per linea (TokenPerLine2SentencePerLine)
SPL=SPLtokenTest
./testCONCEPT/tools/convTPL2SPLtest.sh >../output/$SPL
farfile=$1
#farcompilestrings --symbols=lex.txt --unknown_symbol='<unk>' -keep_symbols=1 "$SPL" > $farfile
farcompilestrings --symbols=../output/lex.txt --unknown_symbol='<unk>' --fst_error_fatal=1 ../output/$SPL > $farfile

