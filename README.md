# CONCEPTtaggingWFST
Develop Spoken Language Understanding (SLU) Module for Movie Domain using NL-SPARQL Data Set
using  WFST method with Marcov model for tagging words (and possible movie name) that compose a sentence.
# Installation
## Requirement
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

## Evaluation info
<http://www.cnts.ua.ac.be/conll2000/chunking/output.html>

## TODO

* Generate the bar plot of the accuracy with different Language Model
* Build a new lexicon with cutoff frequency 

#### Examples:
`cd /P1/Pv1.1/scripts`

`./runTrain.sh`

`./runTest.sh`

`perl conlleval.pl -d '\t' < ../output/out.txt > ../output/accuracy.txt`
