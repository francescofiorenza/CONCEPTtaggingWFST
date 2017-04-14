#!/bin/bash

./farcompiletest.sh datatest.far
rm test
mkdir -p test
cd test
farextract ../datatest.far
cd ..
./tagCONCEPT.sh >taggedCONCEPT.txt
./outCreate.sh
perl conlleval.pl -d '\t' < out.txt>accuracy.txt