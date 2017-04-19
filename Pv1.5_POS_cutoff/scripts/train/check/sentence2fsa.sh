#!/bin/bash
#readinputstringfromSTDIN
#str=$(cat test.txt|sed 's/^ *$/#/g'|tr '\n' ' '|tr '#' '\n')
str=$1
#parseitintoarrayusingspaceasseparator
arr=($(echo $str|tr ' ' '\n'))
#setinitialstate
state=0
#iterate through array
#printing current and next states & token
for token in ${arr[@]};
do
	echo -e "$state\t$((state+1))\t$token\t$token"
	#incrementstate
	((state++));
done;
#print final state
echo $state