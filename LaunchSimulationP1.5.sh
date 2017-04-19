#!/bin/bash
CollectPlotFolderName=collectedPLOTandDAT
mkdir -p $CollectPlotFolderName

###################
cd Pv1.5_WORD_cutoff/scripts
#############BEGIN SIMULATION##########
./LaunchTrainAndTest.sh > outputLaunchTrainAndTest.WORDasTOKEN_cutoff1.log
#tail -n 1 -F outputLaunchTrainAndTest.WORDasTOKEN_cutoff1.log
#############END SIMULATION############
#####BEGIN GRAPH and COLLECTING########
#./test/6ConceptPlotCreate.sh
#./test/7_ComparationClassificationTime.sh
for file in ../output/PLOT/CONCEPT/*.png; do 
cp $file ../../$CollectPlotFolderName/$(basename $file | rev | cut -f 2- -d '.' | rev)_cutoff1.png; 
done
mkdir -p ../../$CollectPlotFolderName/WORDdat_cutoff1
cp ../output/PLOT/CONCEPT/*.dat ../../$CollectPlotFolderName/WORDdat_cutoff1
#####END GRAPH and COLLECTING########
###################

###################
cd ../../Pv1.5_LEMMA_cutoff/scripts
#############BEGIN SIMULATION##########
./LaunchTrainAndTest.sh > outputLaunchTrainAndTest.LEMMAasTOKEN_cutoff1.log
#tail -n 1 -F outputLaunchTrainAndTest.LEMMAasTOKEN_cutoff1.log
#############END SIMULATION############
#####BEGIN GRAPH and COLLECTING########
#./test/6ConceptPlotCreate.sh
#./test/7_ComparationClassificationTime.sh
for file in ../output/PLOT/CONCEPT/*.png; do 
cp $file ../../$CollectPlotFolderName/$(basename $file | rev | cut -f 2- -d '.' | rev)_cutoff1.png; 
done
mkdir -p ../../$CollectPlotFolderName/LEMMAdat_cutoff1
cp ../output/PLOT/CONCEPT/*.dat ../../$CollectPlotFolderName/LEMMAdat_cutoff1
#####END GRAPH and COLLECTING########

###################
cd ../../Pv1.5_POS_cutoff/scripts
#############BEGIN SIMULATION##########
./LaunchTrainAndTest.sh > outputLaunchTrainAndTest.POSasTOKEN_cutoff1.log
#tail -n 1 -F outputLaunchTrainAndTest.POSasTOKEN_cutoff1.log
#############END SIMULATION############
#####BEGIN GRAPH and COLLECTING########
#./test/6ConceptPlotCreate.sh
#./test/7_ComparationClassificationTime.sh
for file in ../output/PLOT/CONCEPT/*.png; do 
cp $file ../../$CollectPlotFolderName/$(basename $file | rev | cut -f 2- -d '.' | rev)_cutoff1.png; 
done
mkdir -p ../../$CollectPlotFolderName/POSdat_cutoff1
cp ../output/PLOT/CONCEPT/*.dat ../../$CollectPlotFolderName/POSdat_cutoff1
#####END GRAPH and COLLECTING########

###################
cd ../../Pv1.5_WORD/scripts
#############BEGIN SIMULATION##########
./LaunchTrainAndTest.sh > outputLaunchTrainAndTest.WORDasTOKEN.log
#tail -n 1 -F outputLaunchTrainAndTest.WORDasTOKEN.log
#############END SIMULATION############
#####BEGIN GRAPH and COLLECTING########
#./test/6ConceptPlotCreate.sh
#./test/7_ComparationClassificationTime.sh
for file in ../output/PLOT/CONCEPT/*.png; do 
cp $file ../../$CollectPlotFolderName/$(basename $file | rev | cut -f 2- -d '.' | rev).png; 
done
mkdir -p ../../$CollectPlotFolderName/WORDdat
cp ../output/PLOT/CONCEPT/*.dat ../../$CollectPlotFolderName/WORDdat
#####END GRAPH and COLLECTING########
###################

###################
cd ../../Pv1.5_LEMMA/scripts
#############BEGIN SIMULATION##########
./LaunchTrainAndTest.sh > outputLaunchTrainAndTest.LEMMAasTOKEN.log
#tail -n 1 -F outputLaunchTrainAndTest.LEMMAasTOKEN.log
#############END SIMULATION############
#####BEGIN GRAPH and COLLECTING########
#./test/6ConceptPlotCreate.sh
#./test/7_ComparationClassificationTime.sh
for file in ../output/PLOT/CONCEPT/*.png; do 
cp $file ../../$CollectPlotFolderName/$(basename $file | rev | cut -f 2- -d '.' | rev).png; 
done
mkdir -p ../../$CollectPlotFolderName/LEMMAdat
cp ../output/PLOT/CONCEPT/*.dat ../../$CollectPlotFolderName/LEMMAdat
#####END GRAPH and COLLECTING########

###################
cd ../../Pv1.5_POS/scripts
#############BEGIN SIMULATION##########
./LaunchTrainAndTest.sh > outputLaunchTrainAndTest.POSasTOKEN.log
#tail -n 1 -F outputLaunchTrainAndTest.POSasTOKEN.log
#############END SIMULATION############
#####BEGIN GRAPH and COLLECTING########
#./test/6ConceptPlotCreate.sh
#./test/7_ComparationClassificationTime.sh
for file in ../output/PLOT/CONCEPT/*.png; do 
cp $file ../../$CollectPlotFolderName/$(basename $file | rev | cut -f 2- -d '.' | rev).png; 
done
mkdir -p ../../$CollectPlotFolderName/POSdat
cp ../output/PLOT/CONCEPT/*.dat ../../$CollectPlotFolderName/POSdat
#####END GRAPH and COLLECTING########