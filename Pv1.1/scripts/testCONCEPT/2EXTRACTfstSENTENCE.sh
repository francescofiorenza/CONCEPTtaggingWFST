#!/bin/bash
temppath=$(pwd)
rm -Rf ../output/temp/test
mkdir -p ../output/temp/test
cd ../output/temp/test
#farextract --filename_prefix='test_sentence_number_' --fst_error_fatal=1 ../../SPLtokenTest.far
farextract --fst_error_fatal=1 ../../SPLtokenTest.far
cd $temppath