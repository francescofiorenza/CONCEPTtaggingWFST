#!/bin/bash
start1=`date +%s`
echo "############### START TRAIN and TEST SIMULATION ##################"
echo " "
  start2=`date +%s`
  echo "-- START TRAINING PHASE "
      ./runTrain.sh
  echo "-- FINISH TRAINING PHASE IN  $((`date +%s`-start2)) sec ---"
  start2=`date +%s`
  echo "-- START TESTING PHASE "
    ./runTest.sh
  echo "-- FINISH TESTING PHASE IN  $((`date +%s`-start2)) sec "
echo "######FINISH TRAIN and TEST SIMULATION IN $((`date +%s`-start1)) sec ######"