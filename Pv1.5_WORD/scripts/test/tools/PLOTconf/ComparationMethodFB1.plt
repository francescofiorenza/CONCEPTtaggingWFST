set terminal pngcairo  font "arial,10" fontscale 1.0 size 600, 400 
set output '../output/PLOT/CONCEPT/ClusterMethodPlotFB1_WORD.png'
set title "WORD as TOKEN FB1\n NLSPARQL classification with the different smoothing method"  font "sans, 13" 
set xlabel "Language Model smoothing method"
set ylabel "FB1 %" 
set yrange [ 40 : 77 ] noreverse nowriteback
set auto x
set grid 

set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
set xtic rotate by -45
#set bmargin 10 
plot [:8] [:]'../output/PLOT/CONCEPT/FB1.dat' using 2:xtic(1) ti col,\
      '' u 3 ti col, \
      '' u 4 ti col, \
      '' u 5 ti col, \
      '' u 6 ti col, \
      '' u 7 ti col, \
      '' u 8 ti col, \
      '' u 9 ti col, \
      '' u 10 ti col, \
      '' u 11 ti col