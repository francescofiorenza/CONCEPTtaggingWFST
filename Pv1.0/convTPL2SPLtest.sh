#!/bin/bash
#Prendiamo in input il nostro file di training con tutte le parole classificate nella loro classe sintattica
testdata='data/NLSPARQL.test.data'
#Estraiamo solo la classe sintattica per poi andare a calcola la probabilità che una appaia prima di un`altra dato che prima ne è apparsa un`altra ancora
cat $testdata | cut -f 1 |
#sostituiamo le righe vuote con un carattere speciale che poi sostituiremo con un accapo
sed 's/^ *$/#/g' |
#sostituiamo gli acapo con uno spazio
tr '\n' ' ' |
#ripristiniamo la righa vuota con un acapo per identificare che la frase è finita
tr '#' '\n' |
#eliminiamo tutte le possibili riche vuote causate da possibili doppi asterischi
sed 's/^ *//g;s/ *$//g'
