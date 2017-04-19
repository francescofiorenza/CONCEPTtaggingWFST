#!/bin/bash

outputFolder=../output
plotFolder=$outputFolder/PLOT
ConceptPlotFolder=$plotFolder/CONCEPT

start1=`date +%s`
echo "############### START TRAIN and TEST SIMULATION ##################"
echo " "
echo "####Start simulation date `date`"
  start2=`date +%s`
  echo "-- START TRAINING PHASE "
      ./runTrain.sh
  echo "-- FINISH TRAINING PHASE IN  $((`date +%s`-start2)) sec ---"
  start2=`date +%s`
  echo "-- START TESTING PHASE "
    ./runTest.sh
  echo "-- FINISH TESTING PHASE IN  $((`date +%s`-start2)) sec "
echo "######FINISH TRAIN and TEST SIMULATION IN $((`date +%s`-start1)) sec ######"
echo "######FINISH simulation date `date`"

echo -e "Method\tgramOrder\tTimeSec" > $ConceptPlotFolder/ClassificationTime.log
cat outputLaunchTrainAndTest.POSasTOKEN_cutoff1.log |grep "test in"|awk '$5 {OFS="\t"; print $9,$7,$5}'>>$ConceptPlotFolder/ClassificationTime.log
