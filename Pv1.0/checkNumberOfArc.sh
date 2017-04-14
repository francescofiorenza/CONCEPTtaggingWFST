#!/bin/bash
line=0
for file in test/*; do
  #fstinfo ${file%.*}|grep error|awk '$2=="y" {print $2}'
  line=$line,$(fstinfo ${file%.*}|grep arcs|awk '{print $4}')
done
IFS=', ' read -r -a array <<< "$line"
IFS='+' sum=$(echo "scale=1;${array[*]}"|bc)
echo $sum