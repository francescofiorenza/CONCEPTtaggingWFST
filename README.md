# CONCEPTtaggingWFST
Develop Spoken Language Understanding (SLU) Module for Movie Domain using NL-SPARQL Data Set
using  WFST method with Marcov model for tagging words (and possible movie name) that compose a sentence.
# Installation
## Requirement
* rc 
* tee 
* gawk - GNU awk, a pattern scanning and processing language
* sed - The GNU sed stream editor
* xdot - interactive viewer for Graphviz dot files
* perl - Larry Wall's Practical Extraction and Report Language
* conlleval.pl - A evaluation tools https://github.com/tpeng/npchunker/blob/master/conlleval.pl
* OpenFST from http://www.openfst.org/
* OpenGRM from http://www.opengrm.org/

MacOS Instructions
--------------------------------------------------------------------------------
NB: The project is done on linux and therefore I do not give any guarantee that 
it works on mac.

1. Install Command Line Tools (if Xcode is not installed)

   type "xcode-select --install" in terminal & follow instructions
   
2. Follow the instructions for compiling OpenFST and OpenGRM in INSTALL files
   in the downloaded archives
   configure OpenFST with '--enable-far' option
   
3. For visualization using graphviz:

   On MacOS 10.12 (Sierra), there are issues with pre-build version available
   from http://www.graphviz.org/
   
   install graphviz using macports (https://www.macports.org/, suggested) or 
   homebrew (https://brew.sh/)
--------------------------------------------------------------------------------
Linux Instructions
--------------------------------------------------------------------------------
(Tested with Debian 8.7 and Ubuntu 16.04)

1. Install build-essential (g++, make, etc.), if not installed
   sudo apt-get install build-essential
   
2. Set environment variables in .bashrc, if not set already
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
   export CPATH=$CPATH:/usr/local/include (optional, but better)

3. Follow the instructions for compiling OpenFST and OpenGRM in INSTALL files
   in the downloaded archives
   configure OpenFST with '--enable-far' option

4. For visualization using graphviz:
   install graphviz from repository

--------------------------------------------------------------------------------
Test installation of the tools of OpenFST
--------------------------------------------------------------------------------

in terminal go into testOPENFST directory and execute the following:

   (a) Compilation (test for FST tools)
   fstcompile --acceptor --isymbols=A.lex A.txt A.fsa
   
   (b) Visualization
   fstdraw --acceptor --isymbols=A.lex A.fsa | dot -Tpng > test.png
   
   You should see a figure similar to that of A.png
   
## Data for train and test
<http://www.cnts.ua.ac.be/conll2000/chunking/>
Download the training and test dataset:
http://www.cnts.ua.ac.be/conll2000/chunking/train.txt.gz
http://www.cnts.ua.ac.be/conll2000/chunking/test.txt.gz
cd CONCEPTtaggingWST/Pv1.2/data
wget http://www.cnts.ua.ac.be/conll2000/chunking/train.txt.gz
wget http://www.cnts.ua.ac.be/conll2000/chunking/test.txt.gz
gunzip train.txt.gz
gunzip test.txt.gz
rm train.txt.gz
rm test.txt.gz


## Evaluation info
<http://www.cnts.ua.ac.be/conll2000/chunking/output.html>

## Version
Pv1.0 Initial version

Pv1.1 

      * Done better structured folder

Pv1.2 

      * Reorganized better the folder
	  
      * Prepared the conlleval input files

Pv1.3

      * Parametrized all the directory and put each folder name in a header of each files
	  
      * Created the classification.conf in order to set the parameter of the train and test evaluation
	  
      * Defined the output of the simulation with the duration of the different step
	  
      * Generalised the concept of tagging for POS and LEMMA tagging
	  
Pv1.4

	  * Created a launch script.

	  * Classification through POS and LEMMA. Worse performance than through WORD

	  * Implemented the bar plot for comparation different model through different order.

	  * Implemented the bar plot for comparation different order through different method.
	  
## TODO

* Entire plot that show the best method and order through different TOKEN.

* Make the test of the classification of POS and LEMMA.

* Build a new lexicon with cutoff frequency.

#### Examples:

`cd P1v1.4_WORD/scripts`

`./LaunchTrainAndTest.sh 2>&1|tee outputLaunchTrainAndTest.WORD.log`

`cd P1v1.4_POS/scripts`

`./LaunchTrainAndTest.sh 2>&1|tee outputLaunchTrainAndTest.POS.log`

`cd P1v1.4_LEMMA/scripts`

`./LaunchTrainAndTest.sh 2>&1|tee outputLaunchTrainAndTest.LEMMA.log`
