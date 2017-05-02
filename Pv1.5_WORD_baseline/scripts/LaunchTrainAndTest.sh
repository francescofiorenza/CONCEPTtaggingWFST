#!/bin/bash
outputFolder=../output
plotFolder=$outputFolder/PLOT
ConceptPlotFolder=$plotFolder/CONCEPT

start1=`date +%s`
echo "############### START TRAIN and TEST BASELINE ##################"
echo " "
echo "####Start simulation date `date`"
  start2=`date +%s`
  echo "-- START TRAINING AND TEST MAJORITY"
      ./runTrainTestMajority.sh
  echo "-- FINISH TRAINING AND TEST MAJORITY IN  $((`date +%s`-start2)) sec ---"
  start2=`date +%s`
  echo "-- START TRAINING AND TEST ML"
    ./runTrainTestML.sh
  echo "-- FINISH TRAINING AND TEST ML IN  $((`date +%s`-start2)) sec "
  start2=`date +%s`
  echo "-- START TRAINING AND TEST MAP"
    ./runTrainTestMAP.sh
  echo "-- FINISH TRAINING AND TEST MAP IN  $((`date +%s`-start2)) sec "
echo "######FINISH TRAIN and TEST SIMULATION IN $((`date +%s`-start1)) sec ######"
echo "######FINISH simulation date `date`"
